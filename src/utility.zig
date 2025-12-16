const std = @import("std");

pub fn print(comptime format_str: []const u8, values: anytype) !void {
    var stdout_buffer: [2048]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print(format_str, values);
    try stdout.flush();
}
