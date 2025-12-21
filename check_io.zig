const std = @import("std");

pub fn main() !void {
    const io_info = @typeInfo(std.io);
    // Access the union field safely or directly if we know it's a struct
    switch (io_info) {
        .struct => |s| {
            inline for (s.decls) |decl| {
               if (std.mem.indexOf(u8, decl.name, "uffered") != null) {
                    std.debug.print("Found in std.io: {s}\n", .{decl.name});
               }
            }
        },
        else => {
            std.debug.print("std.io is not a struct!\n", .{});
        }
    }
}