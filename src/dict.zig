const std = @import("std");
const utilities = @import("utility.zig");

pub fn dictionary_attack(allocator: std.mem.Allocator, hash: ?[]const u8, wordlist: ?[]const u8) !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing dictionary attack!!\n", .{});
    try utilities.print("hash: {s},\nwordlist: {s}\n", .{ hash.?, wordlist.? });
    try utilities.print("------------------------------\n\n\n", .{});

    const cwd = std.fs.cwd();
    const file = try cwd.openFile(wordlist.?, .{ .mode = .read_only });
    defer file.close();

    var file_buffer: [4096]u8 = undefined;
    var reader = file.reader(&file_buffer);

    var is_equal: bool = false;
    var found_pw: []u8 = undefined;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        try utilities.print("trying the word {s}.\n", .{line});
        is_equal = try utilities.is_md5_hash_equal(allocator, line, hash.?);
        if(is_equal) {
            found_pw = line;
            break;
        }
    }
    
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

}

