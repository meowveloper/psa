//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn bufferedPrint() !void {
    // Stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try stdout.flush(); // Don't forget to flush!
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
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
