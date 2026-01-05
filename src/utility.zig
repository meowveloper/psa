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


pub fn is_md5_hash_equal(str: []const u8, target_hash: *const [16]u8) bool {
    var hasher = std.crypto.hash.Md5.init(.{});
    hasher.update(str);
    var output: [16]u8 = undefined;
    hasher.final(&output);
    return std.mem.eql(u8, &output, target_hash);
}


pub fn attack_summery (attempts: usize, elapsed_ns: u64) !void {
    const elapsed_s = @as(f64, @floatFromInt(elapsed_ns)) / std.time.ns_per_s;
    const hps = if (elapsed_s > 0) @as(f64, @floatFromInt(attempts)) / elapsed_s else 0;
    try print("\n\n", .{});
    try print("-----ATTACK SUMMARY-----\n", .{});
    try print("Total Attempts: {d}\n", .{attempts});
    try print("Total Time: {d:.4} seconds\n", .{elapsed_s});
    try print("Speed: {d:.2} hashes per second\n", .{hps});
}
