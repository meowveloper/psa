const std = @import("std");
const utilities = @import("utility.zig");
const dict = @import("dict.zig");

const cwd = std.fs.cwd();

var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn init_audit_mode() !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing audit mode!!\n", .{});
    try utilities.print("------------------------------\n\n\n", .{});

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

    var timer = try std.time.Timer.start();
    const result = try run_audit_mode(hashlist_file, wordlist_file);
    const elapsed_ns = timer.read();

    try utilities.print("****** DONE ******\n", .{});
    try utilities.print("Total password hashes: {d}\n", .{result.total_hash});
    try utilities.print("Number of successfully attacked password hashes: {d}\n", .{result.total_found});
    try utilities.print("Cracked Percentage: {d:.2}%\n", .{
        (
            @as(f64, @floatFromInt(result.total_found))
            /
            @as(f64, @floatFromInt(result.total_hash))
        ) * 100
    });
    try utilities.attack_summery(result.total_attempts, elapsed_ns);
}

fn run_audit_mode(hashlist_file: std.fs.File, wordlist_file: std.fs.File) !struct { total_hash: usize, total_found: usize, total_attempts: usize } {
    var hashlist_file_buffer: [4096]u8 = undefined;
    var hashlist_file_reader = hashlist_file.reader(&hashlist_file_buffer);
    var wordlist_file_buffer: [4096]u8 = undefined;

    var line_num: usize = 0;
    var found_count: usize = 0;
    var total_attempts: usize = 0;

    while (try hashlist_file_reader.interface.takeDelimiter('\n')) |line| {
        line_num += 1;
        try utilities.print("\n========================\n", .{});
        try utilities.print("running dictionary attack on {s}.\n", .{line});
        const result = try dict.dictionary_attack(&wordlist_file_buffer, line, wordlist_file);
        total_attempts += result.line_num;
        if (result.found_pw != null) {
            try utilities.print("\nFound: {s}\n", .{result.found_pw.?});
            found_count += 1;
        } else try utilities.print("\nNOT Found\n", .{});
        try utilities.print("========================\n", .{});
    }

    return .{ .total_hash = line_num, .total_found = found_count, .total_attempts = total_attempts };
}
