const std = @import("std");
const input = @embedFile("03.input");

pub fn main() !void {
    var lines = std.mem.split(u8, input, "\n");

    var partOne: usize = x: {
        var sum: usize = 0;
        while (lines.next()) |line| sum += wrong(line);
        break :x sum;
    };

    lines.reset();

    var partTwo: usize = x: {
        var sum: usize = 0;
        while (true) {
            const a = lines.next() orelse break :x sum;
            const b = lines.next().?;
            const c = lines.next().?;

            sum += group(.{ a, b, c });
        }
        break :x sum;
    };

    std.debug.print("part 1: {any}\n", .{partOne});
    std.debug.print("part 2: {any}\n", .{partTwo});
}

fn wrong(line: []const u8) usize {
    const parts = splitHalf(u8, line);

    var r1 = toRugSack(parts[0]);
    const r2 = toRugSack(parts[1]);

    r1.setIntersection(r2);

    // starts at 1 because we 0-indexed the rug sack
    return (r1.findFirstSet() orelse 0) + 1;
}

fn group(lines: [3][]const u8) usize {
    var r1 = toRugSack(lines[0]);
    const r2 = toRugSack(lines[1]);
    const r3 = toRugSack(lines[2]);

    r1.setIntersection(r2);
    r1.setIntersection(r3);

    // starts at 1 because we 0-indexed the rug sack
    return (r1.findFirstSet() orelse 0) + 1;
}

// priority returns priority - 1 (0-indexed)
fn priority(l: u8) u32 {
    const lookupTable = comptime init: {
        var slice: [256]u32 = undefined;
        for (slice) |*v, i| v.* = if (i >= 'a' and i <= 'z')
            i - 'a'
        else if (i >= 'A' and i <= 'Z')
            i - 'A' + 26
        else
            0;
        break :init slice;
    };

    return lookupTable[l];
}

fn splitHalf(comptime T: type, slice: []const T) [2][]const T {
    const half = slice.len / 2;
    return .{
        slice[0..half],
        slice[half..],
    };
}

fn toRugSack(line: []const u8) RugSack {
    var rugSack = RugSack.initEmpty();
    for (line) |l| rugSack.set(priority(l));
    return rugSack;
}

const RugSack = std.bit_set.IntegerBitSet(52);

test "split half" {
    const s = splitHalf(u8, "abcdef");
    try std.testing.expectEqualSlices(u8, "abc", s[0]);
    try std.testing.expectEqualSlices(u8, "def", s[1]);
}

test "part 1 case" {
    const testin =
        \\vJrwpWtwJgWrhcsFMMfFFhFp
        \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        \\PmmdzqPrVvPwwTWBwg
        \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        \\ttgJtRGJQctTZtZT
        \\CrZsJsPPZsGzwwsLwLmpwMDw
    ;

    var lines = std.mem.split(u8, testin, "\n");

    try std.testing.expectEqual(wrong(lines.next().?), priority('p') + 1);
    try std.testing.expectEqual(wrong(lines.next().?), priority('L') + 1);
    try std.testing.expectEqual(wrong(lines.next().?), priority('P') + 1);
    try std.testing.expectEqual(wrong(lines.next().?), priority('v') + 1);
    try std.testing.expectEqual(wrong(lines.next().?), priority('t') + 1);
    try std.testing.expectEqual(wrong(lines.next().?), priority('s') + 1);

    lines.reset();
    const sum: usize = x: {
        var sum: usize = 0;
        while (lines.next()) |line| sum += wrong(line);

        break :x sum;
    };

    try std.testing.expectEqual(sum, 157);
}
