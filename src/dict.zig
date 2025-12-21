const std = @import("std");

pub fn dictionary_attack(allocator: std.mem.Allocator, hash: ?[]const u8, wordlist: ?[]const u8) !void {
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
        const is_equal = try is_md5_hash_equal(allocator, line, hash.?);
        std.debug.print("{}\n", .{is_equal});
    }
}

pub fn is_md5_hash_equal(allocaltor: std.mem.Allocator, str: []const u8, hash_str: []const u8) !bool {
    var hasher = std.crypto.hash.Md5.init(.{});
    hasher.update(str);
    var output: [16]u8 = undefined;
    hasher.final(&output);
    const string = try std.fmt.allocPrint(allocaltor, "{x}", .{output});
    defer allocaltor.free(string);
    return std.mem.eql(u8, string, hash_str);
}
