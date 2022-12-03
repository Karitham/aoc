const std = @import("std");
const input = @embedFile("01.input");

pub fn main() !void {
    var buf: [1024]u8 = undefined;
    var fbs = std.heap.FixedBufferAllocator.init(&buf);

    var alloc = fbs.allocator();

    var elfs = std.ArrayListUnmanaged(u32){};
    elfs.append(alloc, 0) catch unreachable;

    var lines = std.mem.split(u8, input, "\n");
    while (lines.next()) |l| {
        if (l.len == 0) {
            try elfs.append(alloc, 0);
            continue;
        }

        elfs.items[elfs.items.len - 1] += try std.fmt.parseInt(u32, l, 10);
    }

    std.sort.sort(u32, elfs.items, {}, std.sort.desc(u32));

    std.debug.print("part 1: {any}\n", .{elfs.items[0]});
    std.debug.print("part 2: {any}\n", .{elfs.items[0] + elfs.items[1] + elfs.items[2]});
}
