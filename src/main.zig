const std = @import("std");
const constants = @import("constants.zig");
const utilities = @import("utility.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try utilities.print("{s}\n", .{constants.usage_string});
        return;
    }

    var mode: ?[]const u8 = null;
    var hash: ?[]const u8 = null;
    var wordlist: ?[]const u8 = null;

    for (args[1..]) |arg| {
        if (std.mem.startsWith(u8, arg, "-m=")) {
            mode = arg[3..];
        }
        if (std.mem.startsWith(u8, arg, "-h=")) {
            hash = arg[3..];
        }
        if (std.mem.startsWith(u8, arg, "-w=")) {
            wordlist = arg[3..];
        }
    }

    if (mode == null) {
        try utilities.print("    Error: -m required.\n", .{});
        return;
    }

    const valid_mode = std.mem.eql(u8, mode.?, constants.dict_mode_string) or
        std.mem.eql(u8, mode.?, constants.brute_mode_string) or
        std.mem.eql(u8, mode.?, constants.audit_mode_string);

    if (!valid_mode) {
        try utilities.print("    Error: invalid mode {s}. Must be {s}, {s}, or {s}.\n", .{ mode.?, constants.dict_mode_string, constants.brute_mode_string, constants.audit_mode_string });
        return;
    }

    try utilities.print("    mode: {s}\n", .{mode.?});
    if (hash) |h| try utilities.print("    hash: {s}\n", .{h});
    if (wordlist) |w| try utilities.print("    wordlist: {s}\n", .{w});
}
