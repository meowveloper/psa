const std = @import("std");
const utilities = @import("utility.zig");
const constants = @import("constants.zig");

pub fn init_brute_force_attack(hash: ?[]const u8, max_length: usize) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing brute force attack!!\n", .{});
    try utilities.print("hash: {s},\n", .{ hash.? });
    try utilities.print("------------------------------\n\n\n", .{});


    try utilities.print("choose one character set\n", .{});
    try utilities.print("1. small letters or lower case letters (a-z)\n", .{});
    try utilities.print("2. small letters or lower case letters and numbers (a-z,0-9)\n", .{});
    try utilities.print("3. small letters or lower case letters, numbers and capital letters (a-z,0-9,A-Z)\n", .{});
    try utilities.print("4. small letters or lower case letters, numbers, capital letters and special characters (a-z,0-9,A-Z,!@#$%^&*()-_=+)\n", .{});
    try utilities.print("choose one number (1, 2, 3 or 4): ", .{});

    var stdin_buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
    const stdin = &stdin_reader.interface;
    const data = try stdin.takeDelimiterExclusive('\n');

    if(std.mem.eql(u8, data, "1")) {
        try run_brute_force_attack(constants.lowers, hash, max_length);
    } else if(std.mem.eql(u8, data, "2")) {
        try run_brute_force_attack(constants.lowers_and_numbers, hash, max_length);
    } else if(std.mem.eql(u8, data, "3")) {
        try run_brute_force_attack(constants.lowers_numbers_and_uppers, hash, max_length);
    } else if(std.mem.eql(u8, data, "4")) {
        try run_brute_force_attack(constants.lowers_numbers_uppers_specChars, hash, max_length);
    } else {
        try utilities.print("ERROR: invalid input!!!\n", .{});
    }

}

fn run_brute_force_attack(wordlist: []const u8,hash: ?[]const u8, max_length: usize) !void {
    var is_equal: bool = false;
    var attempts: usize = 0;

    var target_hash_bytes: [16]u8 = undefined;
    _ = try std.fmt.hexToBytes(&target_hash_bytes, hash.?);

    var buffer: [64]u8 = undefined;
    @memset(buffer[0..], 0);

    var timer = try std.time.Timer.start();

    for(0..max_length + 1) |i| {
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
        try utilities.print("Congratuations!! your hashed password was NOT found within the following constraints.\n", .{});
        try utilities.print("character set: {s}\n", .{wordlist});
        try utilities.print("max password length: {d}\n", .{max_length});
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

