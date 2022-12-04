const std = @import("std");
const input = @embedFile("04.input");

pub fn main() !void {
    const partOne = try countFullOverlap(input);
    const partTwo = try countPartialOverlap(input);

    std.debug.print("part 1: {any}\n", .{partOne});
    std.debug.print("part 2: {any}\n", .{partTwo});
}

const WorkArea = struct {
    data: std.bit_set.IntegerBitSet(128),

    pub fn initEmpty() WorkArea {
        return WorkArea{
            .data = std.bit_set.IntegerBitSet(128).initEmpty(),
        };
    }

    fn overlaps(wa: WorkArea, r: Range) bool {
        return wa.overlapCount(r) == r.count();
    }

    fn overlapCount(wa: WorkArea, r: Range) u16 {
        var overlapping: u16 = 0;

        var range = r;
        while (range.next()) |i| {
            if (wa.isSet(i)) {
                overlapping += 1;
            }
        }

        return overlapping;
    }

    fn isSet(wa: WorkArea, i: u16) bool {
        return wa.data.isSet(i);
    }

    fn set(wa: *WorkArea, i: u16) void {
        wa.data.set(i);
    }

    fn setRangeValue(wa: *WorkArea, r: Range, value: bool) void {
        wa.data.setRangeValue(.{
            .start = r.start,
            // inclusive
            .end = r.end + 1,
        }, value);
    }
};

fn countFullOverlap(in: []const u8) !u16 {
    var it = std.mem.split(u8, in, "\n");

    var count: u16 = 0;
    while (it.next()) |line| {
        var elf_pair = try Range.fromLine(line);

        var elf_a = elf_pair[0];
        var elf_b = elf_pair[1];

        if (elf_a.count() <= elf_b.count()) std.mem.swap(Range, &elf_a, &elf_b);

        var wa = WorkArea.initEmpty();
        wa.setRangeValue(elf_a, true);
        if (wa.overlaps(elf_b)) count += 1;
    }

    return count;
}

test "countInclusiveRange" {
    const in =
        \\2-4,6-8
        \\2-3,4-5
        \\5-7,7-9
        \\2-8,3-7
        \\6-6,4-6
        \\2-6,4-8
    ;

    const count = try countFullOverlap(in);
    try std.testing.expectEqual(count, 2);
}

fn countPartialOverlap(in: []const u8) !u16 {
    var it = std.mem.split(u8, in, "\n");

    var count: u16 = 0;
    while (it.next()) |line| {
        var elf_pair = try Range.fromLine(line);

        var elf_a = elf_pair[0];
        var elf_b = elf_pair[1];

        if (elf_a.count() <= elf_b.count()) std.mem.swap(Range, &elf_a, &elf_b);

        var wa = WorkArea.initEmpty();
        wa.setRangeValue(elf_a, true);
        if (wa.overlapCount(elf_b) > 0) count += 1;
    }

    return count;
}

test "countOverlaps" {
    const in =
        \\2-4,6-8
        \\2-3,4-5
        \\5-7,7-9
        \\2-8,3-7
        \\6-6,4-6
        \\2-6,4-8
    ;

    const count = try countPartialOverlap(in);
    try std.testing.expectEqual(count, 4);
}

const Range = struct {
    start: u16,
    end: u16,

    iter: u16,

    fn asc(_: void, a: Range, b: Range) bool {
        return a.count() < b.count();
    }

    fn desc(_: void, a: Range, b: Range) bool {
        return a.count() > b.count();
    }

    fn fromRange(line: []const u8) !Range {
        var parts = std.mem.split(u8, line, "-");

        const first_half = parts.next().?;
        const second_half = parts.next().?;

        const start = try std.fmt.parseInt(u16, first_half, 10);
        const end = try std.fmt.parseInt(u16, second_half, 10);
        return Range{ .start = start, .end = end, .iter = start };
    }

    test "parseRange" {
        const r = try fromRange("123-456");
        try std.testing.expectEqual(Range{ .start = 123, .end = 456, .iter = 123 }, r);
    }

    pub fn fromLine(line: []const u8) ![2]Range {
        var parts = std.mem.split(u8, line, ",");
        const first = try fromRange(parts.next().?);
        const second = try fromRange(parts.next().?);

        return .{ first, second };
    }

    test "parseLine" {
        const r = try fromLine("123-456,789-1011");
        try std.testing.expectEqual(Range{ .start = 123, .end = 456, .iter = 123 }, r[0]);
        try std.testing.expectEqual(Range{ .start = 789, .end = 1011, .iter = 789 }, r[1]);
    }

    fn next(self: *Range) ?u16 {
        if (self.iter > self.end) return null;
        const ret = self.iter;
        self.iter += 1;
        return ret;
    }

    test "iter" {
        var r = try Range.fromRange("2-4");
        try std.testing.expectEqual(r.next(), 2);
        try std.testing.expectEqual(r.next(), 3);
        try std.testing.expectEqual(r.next(), 4);
        try std.testing.expectEqual(r.next(), null);

        r = try Range.fromRange("5-7");
        try std.testing.expectEqual(r.next(), 5);
        try std.testing.expectEqual(r.next(), 6);
        try std.testing.expectEqual(r.next(), 7);
        try std.testing.expectEqual(r.next(), null);

        r = try Range.fromRange("7-9");
        try std.testing.expectEqual(r.next(), 7);
        try std.testing.expectEqual(r.next(), 8);
        try std.testing.expectEqual(r.next(), 9);
        try std.testing.expectEqual(r.next(), null);

        r = try Range.fromRange("6-6");
        try std.testing.expectEqual(r.next(), 6);
        try std.testing.expectEqual(r.next(), null);
    }

    fn count(self: Range) u16 {
        return (self.end - self.start) + 1;
    }

    test "count" {
        var r = try Range.fromRange("2-4");
        try std.testing.expectEqual(r.count(), 3);

        r = try Range.fromRange("5-7");
        try std.testing.expectEqual(r.count(), 3);

        r = try Range.fromRange("7-9");
        try std.testing.expectEqual(r.count(), 3);

        r = try Range.fromRange("6-6");
        try std.testing.expectEqual(r.count(), 1);
    }
};
