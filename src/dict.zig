const std = @import("std");
const utilities = @import("utility.zig");

pub fn dictionary_attack(hash: ?[]const u8, wordlist: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing dictionary attack!!\n", .{});
    try utilities.print("hash: {s},\nwordlist: {s}\n", .{ hash.?, wordlist.? });
    try utilities.print("------------------------------\n\n\n", .{});

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(wordlist.?, .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);

    var target_hash_bytes: [16]u8 = undefined;
    _ = try std.fmt.hexToBytes(&target_hash_bytes, hash.?);

    var is_equal: bool = false;
    var found_pw: []u8 = undefined;
    var line_num: usize = 0;

    var timer = try std.time.Timer.start();

    while (try reader.interface.takeDelimiter('\n')) |line| {
        if(line_num % 1000 == 0) try utilities.print("trying the word {s}.\r", .{line});
        line_num += 1;
        is_equal = utilities.is_md5_hash_equal(line, &target_hash_bytes);
        if(is_equal) {
            found_pw = line;
            break;
        }
    }
    
    const elapsed_ns = timer.read();
    const elapsed_s = @as(f64, @floatFromInt(elapsed_ns)) / std.time.ns_per_s;
    const hps = if (elapsed_s > 0) @as(f64, @floatFromInt(line_num)) / elapsed_s else 0;
    
    
    try utilities.print("\n\n", .{});
    if(is_equal) {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("your hashed password was FOUND in the dictionary file!!\n", .{});
        try utilities.print("found password: {s}\n", .{found_pw});
        try utilities.print("------------------------------\n", .{});
    } else {
        try utilities.print("------------------------------\n", .{});
        try utilities.print("Congratuations!! your hashed password was NOT found in the dictionary file!!\n", .{});
        try utilities.print("------------------------------\n", .{});
    }

    try utilities.print("\n\n", .{});
    try utilities.print("-----ATTACK SUMMARY-----\n", .{});
    try utilities.print("Total Attempts: {d}\n", .{line_num});
    try utilities.print("Total Time: {d:.4} seconds\n", .{elapsed_s});
    try utilities.print("Speed: {d:.2} hashes per second\n", .{hps});
    try utilities.print("-----ATTACK SUMMARY-----\n", .{});
}

