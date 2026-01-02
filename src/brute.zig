const std = @import("std");
const utilities = @import("utility.zig");

pub fn init_brute_force_attack(hash: ?[]const u8, max_length: usize) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing brute force attack!!\n", .{});
    try utilities.print("hash: {s},\n", .{ hash.? });
    try utilities.print("------------------------------\n\n\n", .{});


    try utilities.print("brute force attack will run with small letters (a-z). do you want to continue?\n", .{});
    const is_yes_1 = try ask_y_n();

    if(is_yes_1) {
        const wordlist_1 = "abcdefghijklmnopqrstuvwxyz";
        const found = try run_brute_force_attack(wordlist_1, hash, max_length);
        if(found) return;
    }
    // try utilities.print("brute force attack will run with small letters (a-z). do you want to continue?\n", .{});
    // const is_yes_2 = try ask_y_n();
    // const wordlist_2 = "abcdefghijklmnopqrstuvwxyz0123456789";
    // try run_brute_force_attack(wordlist_2, hash, max_length);
    // const wordlist_3 = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    // try run_brute_force_attack(wordlist_3, hash, max_length);
    // const wordlist_4 = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-_=+";
    // try run_brute_force_attack(wordlist_4, hash, max_length);
}

fn ask_y_n () !bool {
    try utilities.print("y/n: ", .{});
    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;
    const data = try stdin.takeDelimiterExclusive('\n');
    return std.mem.eql(u8, data, "y");
}

fn run_brute_force_attack(wordlist: []const u8,hash: ?[]const u8, max_length: usize) !bool {
    var is_equal: bool = false;
    var attempts: usize = 0;

    var target_hash_bytes: [16]u8 = undefined;
    _ = try std.fmt.hexToBytes(&target_hash_bytes, hash.?);

    var buffer: [64]u8 = undefined;
    @memset(buffer[0..], 0);

    var timer = try std.time.Timer.start();

    for(0..max_length) |i| {
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
    return is_equal;
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

