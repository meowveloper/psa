const std = @import("std");
const utilities = @import("utility.zig");
const dict = @import("dict.zig");


var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
const stdin = &stdin_reader.interface;

const Found_Pw = struct { found_pw: []u8, hash: []u8 };

pub fn init_audit_mode(allocator: std.mem.Allocator) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing audit mode!!\n", .{});
    try utilities.print("------------------------------\n\n\n", .{});

    const cwd = std.fs.cwd();
    try utilities.print("type the name of the hashlist file: ", .{});
    const hashlist_raw = try stdin.takeDelimiter('\n');
    const hashlist = std.mem.trim(u8, hashlist_raw.?, &std.ascii.whitespace);
    const hashlist_file = cwd.openFile(hashlist, .{ .mode = .read_only }) catch {
        try utilities.print("ERROR: cannot open the file {s}\n", .{hashlist});
        return;
    };
    defer hashlist_file.close();

    try utilities.print("type the name of the wordlist file: ", .{});
    const wordlist_raw = try stdin.takeDelimiter('\n');
    const wordlist = std.mem.trim(u8, wordlist_raw.?, &std.ascii.whitespace);
    const wordlist_file = cwd.openFile(wordlist, .{ .mode = .read_only }) catch {
        try utilities.print("ERROR: cannot open the file {s}\n", .{wordlist});
        return;
    };
    defer wordlist_file.close();

    var found_pws : std.ArrayList(Found_Pw) = .empty;
    defer {
        for (found_pws.items) |item| {
            allocator.free(item.found_pw);
            allocator.free(item.hash);
        }
        found_pws.deinit(allocator);
    }

    var timer = try std.time.Timer.start();
    const result = try run_audit_mode(allocator, hashlist_file, wordlist_file, &found_pws);
    const elapsed_ns = timer.read();
    
    try print_audit_report(found_pws.items, result.total_hash);
    
    try utilities.attack_summery(result.total_attempts, elapsed_ns);
}

fn print_audit_report(found_pws: []Found_Pw, total_hashes: usize) !void {
    try utilities.print("\n\n====== DETAILED AUDIT REPORT ======\n", .{});
    
    // 1. List Cracked Passwords
    try utilities.print("\n[Cracked Passwords List]\n", .{});
    var weak_len_count: usize = 0;
    var simple_char_count: usize = 0;

    for (found_pws, 0..) |item, i| {
        try utilities.print(" {d:>3}. {s}  (hash: {s})\n", .{i + 1, item.found_pw, item.hash});
        
        if (item.found_pw.len < 8) weak_len_count += 1;
        
        var has_digit = false;
        var has_symbol = false;
        for (item.found_pw) |c| {
            if (std.ascii.isDigit(c)) has_digit = true;
            if (!std.ascii.isAlphanumeric(c)) has_symbol = true;
        }
        if (!has_digit and !has_symbol) simple_char_count += 1;
    }

    if (found_pws.len == 0) {
        try utilities.print(" (No passwords were cracked)\n", .{});
    }

    // 2. Statistics
    const cracked_count = found_pws.len;
    const cracked_percent = if (total_hashes > 0) (@as(f64, @floatFromInt(cracked_count)) / @as(f64, @floatFromInt(total_hashes))) * 100.0 else 0.0;
    
    try utilities.print("\n[Vulnerability Statistics]\n", .{});
    try utilities.print("  Total Hashes Audited:    {d}\n", .{total_hashes});
    try utilities.print("  Total Cracked:           {d} ({d:.1}%)\n", .{cracked_count, cracked_percent});
    try utilities.print("  - Weak Length (<8 chars):{d}\n", .{weak_len_count});
    try utilities.print("  - Low Complexity (alpha):{d}\n", .{simple_char_count});

    // 3. Score & Recommendations
    try utilities.print("\n[Security Assessment]\n", .{});
    if (cracked_percent >= 50.0) {
        try utilities.print("  Status: CRITICAL VULNERABILITY\n", .{});
        try utilities.print("  Assessment: More than half of the passwords were found in a common wordlist.\n", .{});
        try utilities.print("  Recommendation: IMMEDIATE forced password reset required. Enforce min-length 12.\n", .{});
    } else if (cracked_percent > 0.0) {
        try utilities.print("  Status: WEAK\n", .{});
        try utilities.print("  Assessment: Several passwords are weak dictionary words.\n", .{});
        try utilities.print("  Recommendation: Enforce complexity rules (digits/symbols) and check against 'RockYou' list.\n", .{});
    } else {
         try utilities.print("  Status: PASS\n", .{});
         try utilities.print("  Assessment: No passwords matched the provided dictionary.\n", .{});
         try utilities.print("  Recommendation: Continue routine auditing. Consider testing with a larger wordlist.\n", .{});
    }
    try utilities.print("===================================\n", .{});
}

fn run_audit_mode(allocator: std.mem.Allocator, hashlist_file: std.fs.File, wordlist_file: std.fs.File, found_pws: *std.ArrayList(Found_Pw)) !struct { total_hash: usize, total_attempts: usize } {
    var hashlist_file_buffer: [4096]u8 = undefined;
    var hashlist_file_reader = hashlist_file.reader(&hashlist_file_buffer);
    var wordlist_file_buffer: [4096]u8 = undefined;

    var line_num: usize = 0;
    var total_attempts: usize = 0;


    while (try hashlist_file_reader.interface.takeDelimiter('\n')) |line| {
        line_num += 1;
        try utilities.print("\n========================\n", .{});
        try utilities.print("running dictionary attack on {s}.\n", .{line});

        const result = try dict.dictionary_attack(&wordlist_file_buffer, line, wordlist_file);
        total_attempts += result.line_num;

        if (result.found_pw != null) {
            try utilities.print("\nFound: {s}\n", .{result.found_pw.?});
            const found_word = try allocator.dupe(u8, result.found_pw.?);
            const hash = try allocator.dupe(u8, line);
            try found_pws.append(allocator, .{.found_pw = found_word, .hash = hash});
        } else try utilities.print("\nNOT Found\n", .{});

        try utilities.print("========================\n", .{});
    }

    return .{ .total_hash = line_num, .total_attempts = total_attempts };
}
