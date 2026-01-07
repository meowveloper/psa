const std = @import("std");
const constants = @import("constants.zig");
const utilities = @import("utility.zig");
const dict = @import("dict.zig");
const brute = @import("brute.zig");

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
    
    if(!try utilities.check_mode(mode)) return;

    if(std.mem.eql(u8, mode.?, constants.dict_mode_string)) {
        try dict.dictionary_attack(hash, wordlist);
    }
    if(std.mem.eql(u8, mode.?, constants.brute_mode_string)) {
        try brute.init_brute_force_attack(hash);
    }
}

