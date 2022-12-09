const std = @import("std");
const input = @embedFile("06.input");

pub fn main() !void {
    var size: usize = 4;

    var packet: usize = 0;
    while (true) : (packet += 1) {
        var set = std.bit_set.IntegerBitSet(26).initEmpty();
        for (input[packet .. packet + size]) |c| set.set(c - 'a');

        if (set.count() != size) continue;

        packet += size;
        break;
    }

    size = 14;

    std.debug.print("06.1: {}\n", .{packet});
    std.debug.print("06.2: {}\n", .{message});
}

fn solve(in: []const u8, size: usize) usize {
    var end: usize = 0;
    while (true) : (end += 1) {
        var set = std.bit_set.IntegerBitSet(26).initEmpty();
        for (in[end .. end + size]) |c| set.set(c - 'a');

        if (set.count() != size) continue;

        end += size;
        break;
    }

    return end;
}
