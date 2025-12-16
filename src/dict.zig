const std = @import("std");

pub fn dictionary_attack(hash: ?[]const u8, wordlist: ?[]const u8) !void {
    std.debug.print("performing dictionary attack!!\n", .{});
    std.debug.print("hash: {s}, wordlist: {s}\n", .{hash.?, wordlist.?});


    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var threaded: std.Io.Threaded = .init(allocator);
    const io = threaded.io();
    defer threaded.deinit();

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(wordlist.?, .{ .mode = .read_only });
    defer file.close();

    var read_buffer: [4096]u8 = undefined;
    var fr = file.reader(io, &read_buffer);
    var reader = &fr.interface;

    var buffer: [1024]u8 = undefined;
    @memset(buffer[0..], 0);
    _ = reader.readSliceAll(buffer[0..]) catch 0;
    std.debug.print("{s}\n", .{buffer});
}
