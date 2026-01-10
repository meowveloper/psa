const std = @import("std");
const utilities = @import("utility.zig");

const cwd = std.fs.cwd();

var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(&stdin_buffer);
const stdin = &stdin_reader.interface;

pub fn init_audit_mode () !void {
    try utilities.print("------------------------------\n", .{});
    try utilities.print("performing brute force attack!!\n", .{});
    try utilities.print("------------------------------\n\n\n", .{});


    try utilities.print("type the name of the hashlist file: ", .{}); 
    const hashlist_raw = try stdin.takeDelimiter('\n');
    const hashlist = std.mem.trim(u8, hashlist_raw.?, &std.ascii.whitespace);
    const hashlist_file = cwd.openFile(hashlist, .{ .mode = .read_only }) catch {
        try utilities.print("ERROR: cannot open the file {s}\n", .{hashlist});
        return;
    };
    defer hashlist_file.close();

    try utilities.print("type the name of the wordlist file: ", .{}); 
    const wordlist_raw = try stdin.takeDelimiter('\n');
    const wordlist = std.mem.trim(u8, wordlist_raw.?, &std.ascii.whitespace);
    const wordlist_file = cwd.openFile(wordlist, .{ .mode = .read_only }) catch {
        try utilities.print("ERROR: cannot open the file {s}\n", .{wordlist});
        return;
    };
    defer wordlist_file.close();


    try run_audit_mode(hashlist_file, wordlist_file);

}

fn run_audit_mode (hashlist_file: std.fs.File, wordlist_file: std.fs.File) !void {
    _ = wordlist_file;

    var hashlist_file_buffer: [4096]u8 = undefined;
    var hashlist_file_reader = hashlist_file.reader(&hashlist_file_buffer);
    // var wordlist_file_buffer: [4096]u8 = undefined;
    // var wordlist_file_reader = wordlist_file.read(&wordlist_file_buffer);

    while (try hashlist_file_reader.interface.takeDelimiter('\n')) |line| {
        var target_hash_bytes: [16]u8 = undefined;
        _ = try std.fmt.hexToBytes(&target_hash_bytes, line);
        std.debug.print("bytes: {s}\n", .{target_hash_bytes});
    }
}
