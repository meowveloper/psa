const std = @import("std");
const utilities = @import("utility.zig");

pub fn init_dictionary_attack (hash: ?[]const u8, wordlist: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing dictionary attack!!\n", .{});
    try utilities.print("hash: {s},\nwordlist: {s}\n", .{ hash.?, wordlist.? });
    try utilities.print("------------------------------\n\n\n", .{});

    const cwd = std.fs.cwd();
    const file = cwd.openFile(wordlist.?, .{ .mode = .read_only }) catch {
        try utilities.print("ERROR: cannot open the file at {s}", .{wordlist.?});
        return;
    };
    defer file.close();

    var share_file_buffer: [4096]u8 = undefined;
    var timer = try std.time.Timer.start();

    const result = try dictionary_attack(&share_file_buffer, hash, file);
    const elapsed_ns = timer.read();
    try utilities.print("\n", .{});
    if(result.found_pw == null) {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("Congratuations!! your hashed password was NOT found in the dictionary file!!\n", .{});
        try utilities.print("------------------------------\n", .{});
    } else {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("your hashed password was FOUND in the dictionary file!!\n", .{});
        try utilities.print("found password: {s}\n", .{result.found_pw.?});
        try utilities.print("------------------------------\n", .{});
    }
    try utilities.attack_summery(result.line_num, elapsed_ns); 
}

pub fn dictionary_attack(file_buffer: []u8, hash: ?[]const u8, wordlist_file: std.fs.File) !struct {found_pw: ?[]const u8, line_num: usize} {
    var reader = wordlist_file.reader(file_buffer);

    var target_hash_bytes: [16]u8 = undefined;
    _ = try std.fmt.hexToBytes(&target_hash_bytes, hash.?);

    var found_pw: ?[]const u8 = null;
    var line_num: usize = 0;

    while (try reader.interface.takeDelimiter('\n')) |raw_line| {
        const line = std.mem.trimRight(u8, raw_line, &std.ascii.whitespace);
        if(line_num % 1000 == 0) try utilities.print("trying the word {s}.\r", .{line});
        line_num += 1;
        if(utilities.is_md5_hash_equal(line, &target_hash_bytes)) {
            found_pw = line;
            break;
        }
    }
    return .{
        .found_pw = found_pw,
        .line_num = line_num
    };
}

test "dictionary_attack - finding 'hello' in wordlist" {
    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();

    const file_name = "wordlist.txt";
    try tmp.dir.writeFile(.{ .sub_path = file_name, .data = "password\n123456\nhello\nadmin\n" });
    
    const file = try tmp.dir.openFile(file_name, .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    const hello_hash_hex = "5d41402abc4b2a76b9719d911017c592"; // MD5 for "hello"
    
    const result = try dictionary_attack(&buffer, hello_hash_hex, file);
    
    try std.testing.expect(result.found_pw != null);
    try std.testing.expectEqualStrings("hello", result.found_pw.?);
    try std.testing.expectEqual(@as(usize, 3), result.line_num);
}

