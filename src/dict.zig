const std = @import("std");

pub fn dictionary_attack(allocator: std.mem.Allocator, hash: ?[]const u8, wordlist: ?[]const u8) !void {
    _ = allocator;
    std.debug.print("performing dictionary attack!!\n", .{});
    std.debug.print("hash: {s}, wordlist: {s}\n", .{ hash.?, wordlist.? });

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(wordlist.?, .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);

    var line_no: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        line_no += 1;
        std.debug.print("{d}--{s}\n", .{line_no, line});
    }
}
