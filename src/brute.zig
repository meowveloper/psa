const std = @import("std");
const utilities = @import("utility.zig");

pub fn run_brute_force_attack(hash: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing brute force attack!!\n", .{});
    try utilities.print("hash: {s},\n", .{ hash.? });
    try utilities.print("------------------------------\n\n\n", .{});

    const wordlist = "abcdefghijklmnopqrstuvwxyz0123456789";
    _ = wordlist;


}
