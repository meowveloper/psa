const std = @import("std");
const constants = @import("constants.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        std.debug.print("{s}\n", .{constants.usage_string});
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
        std.debug.print("    Error: -m required.\n", .{});
        return;
    }

    const valid_mode = std.mem.eql(u8, mode.?, constants.dict_mode_string) or
        std.mem.eql(u8, mode.?, constants.brute_mode_string) or
        std.mem.eql(u8, mode.?, constants.audit_mode_string);

    if (!valid_mode) {
        std.debug.print("    Error: invalid mode {s}. Must be {s}, {s}, or {s}.\n", .{ mode.?, constants.dict_mode_string, constants.brute_mode_string, constants.audit_mode_string });
        return;
    }

    std.debug.print("    mode: {s}\n", .{mode.?});
    if (hash) |h| std.debug.print("    hash: {s}\n", .{h});
    if (wordlist) |w| std.debug.print("    wordlist: {s}\n", .{w});
}

test "basic arg alloc" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    try std.testing.expect(args.len > 0);
}

test "arg parsing" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const test_args = [_][]const u8{ "psa", "-m=dict" };
    const args = try allocator.dupe([]const u8, &test_args);
    defer allocator.free(args);

    var mode: ?[]const u8 = null;
    var hash: ?[]const u8 = null;

    for (args[1..]) |arg| {
        if (std.mem.startsWith(u8, arg, "-m=")) {
            mode = arg[3..];
        }
        if (std.mem.startsWith(u8, arg, "-h=")) {
            hash = arg[3..];
        }
    }

    try std.testing.expect(mode != null);
    try std.testing.expect(std.mem.eql(u8, mode.?, "dict"));
}
