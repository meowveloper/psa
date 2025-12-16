const std = @import("std");
const constants = @import("constants.zig");

pub fn print(comptime format_str: []const u8, values: anytype) !void {
    var stdout_buffer: [2048]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print(format_str, values);
    try stdout.flush();
}

pub fn check_mode(mode: ?[]const u8) !bool {
    if (mode == null) {
        try print("    Error: -m required.\n", .{});
        return false;
    }
    const valid_mode = std.mem.eql(u8, mode.?, constants.dict_mode_string) or
        std.mem.eql(u8, mode.?, constants.brute_mode_string) or
        std.mem.eql(u8, mode.?, constants.audit_mode_string);

    if (!valid_mode) {
        try print("    Error: invalid mode {s}. Must be {s}, {s}, or {s}.\n", .{ mode.?, constants.dict_mode_string, constants.brute_mode_string, constants.audit_mode_string });
        return false;
    }
    return true;
}
