const std = @import("std");
const utilities = @import("utility.zig");

pub fn dictionary_attack(allocator: std.mem.Allocator, hash: ?[]const u8, wordlist: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing dictionary attack!!\n", .{});
    try utilities.print("hash: {s},\nwordlist: {s}\n", .{ hash.?, wordlist.? });
    try utilities.print("------------------------------\n\n\n", .{});

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(wordlist.?, .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);

    var line_no: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        line_no += 1;
        try utilities.print("{d}--{s}\n", .{line_no, line});
        const is_equal = try utilities.is_md5_hash_equal(allocator, line, hash.?);
        try utilities.print("{}\n", .{is_equal});
    }
}

