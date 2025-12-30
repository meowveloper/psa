const std = @import("std");
const utilities = @import("utility.zig");

pub fn run_brute_force_attack(hash: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing brute force attack!!\n", .{});
    try utilities.print("hash: {s},\n", .{ hash.? });
    try utilities.print("------------------------------\n\n\n", .{});

    var is_equal: bool = false;
    var attempts: usize = 0;

    var target_hash_bytes: [16]u8 = undefined;
    _ = try std.fmt.hexToBytes(&target_hash_bytes, hash.?);

    const wordlist = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-_=+";
    var buffer: [64]u8 = undefined;
    @memset(buffer[0..], 0);


    var timer = try std.time.Timer.start();
    var max_length: usize = 0;

    for(0..9) |i| {
        max_length = i;
        is_equal = try brute_recursive(&buffer, 0, i, &target_hash_bytes, wordlist, &attempts);
        if(is_equal) break;
    }

    const elapsed_ns = timer.read();
    if(is_equal) {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("your hashed password was FOUND!!\n", .{});
        try utilities.print("found password: {s}\n", .{buffer});
        try utilities.print("------------------------------\n", .{});
    } else {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("Congratuations!! your hashed password was NOT found!!\n", .{});
        try utilities.print("------------------------------\n", .{});
    }
    try utilities.attack_summery(attempts, elapsed_ns);
}

fn brute_recursive(buffer: *[64]u8, current_index: usize, max_length: usize, target_hash: *const [16]u8, char_set: []const u8, attempts: *usize) !bool {

    if(current_index == max_length) {
        const result = buffer[0..max_length];
        attempts.* += 1;
        if(attempts.* % 1024 == 0) try utilities.print("trying word: {s}\r", .{result});
        return utilities.is_md5_hash_equal(result, target_hash);
    }
    for(char_set) |ch| {
        buffer[current_index] = ch; 
        if(try brute_recursive(buffer, current_index + 1, max_length, target_hash, char_set, attempts)) return true;
    }
    return false;
}
