const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);


    if(args.len < 2) {
        const usage = 
            \\
            \\    usage: psa -m=<mode> -h=<your-hash>
            \\    Modes: dict (dictionary attack), brute (brute-force), audit (batch audit)
            \\    Example: psa -m=dict -h=5f4dcc3b5aa765d61d8327deb882cf99 -w=rockyou.txt
            \\
        ;
        std.debug.print("{s}\n", .{usage});
        return;
    }

    var mode: ?[]const u8 = null;
    var hash: ?[]const u8 = null;

    for(args[1..]) |arg| {
        if(std.mem.startsWith(u8, arg, "-m=")) {
            mode = arg[3..];
        }
        if(std.mem.startsWith(u8, arg, "-h=")) {
            hash = arg[3..];
        }
    }

    if(mode) |m| {
        std.debug.print("    mode: {s}\n", .{m});
    } else {
        std.debug.print("    ERROR!!!: mode required.", .{});
        return;
    }
    if(hash) |h| std.debug.print("    hash: {s}\n", .{h});
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


    const test_args = [_][]const u8{"psa", "-m=dict"};
    const args = try allocator.dupe([]const u8, &test_args);
    defer allocator.free(args);

    var mode: ?[]const u8 = null;
    var hash: ?[]const u8 = null;

    for(args[1..]) |arg| {
        if(std.mem.startsWith(u8, arg, "-m=")) {
            mode = arg[3..];
        }
        if(std.mem.startsWith(u8, arg, "-h=")) {
            hash = arg[3..];
        }
    }

    try std.testing.expect(mode != null);
    try std.testing.expect(std.mem.eql(u8, mode.?, "dict"));
}
