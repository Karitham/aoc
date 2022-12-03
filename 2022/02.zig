const std = @import("std");
const input = @embedFile("02.input");

pub fn main() !void {
    var lines = std.mem.split(u8, input, "\n");

    const partOne = x: {
        var total: u32 = 0;
        while (lines.next()) |line| {
            var parts = std.mem.tokenize(u8, line, " ");

            const them = parts.next().?;
            const us = parts.next().?;

            total += wins(us, them) * 3;
            total += partOneLookupMap.get(us) orelse 0;
        }

        break :x total;
    };

    lines.reset();

    const partTwo = x: {
        var total: u32 = 0;
        while (lines.next()) |line| {
            var parts = std.mem.tokenize(u8, line, " ");

            const them = parts.next().?;
            const outcome = parts.next().?;

            total += outcomeTable.get(outcome) orelse 0;
            total += playedBasedOnOutcome(outcome, them);
        }

        break :x total;
    };

    std.debug.print("part 1: {any}\n", .{partOne});
    std.debug.print("part 2: {any}\n", .{partTwo});
}

const partOneLookupMap = std.ComptimeStringMap(u32, .{
    .{ "A", 1 }, // Rock
    .{ "B", 2 }, // Paper
    .{ "C", 3 }, // Scissors
    .{ "X", 1 }, // Rock
    .{ "Y", 2 }, // Paper
    .{ "Z", 3 }, // Scissors
});

const outcomeTable = std.ComptimeStringMap(u32, .{
    .{ "X", 0 }, // Lose
    .{ "Y", 3 }, // Draw
    .{ "Z", 6 }, // Win
});

const looseTable = std.ComptimeStringMap([]const u8, .{
    .{ "A", "C" },
    .{ "B", "A" },
    .{ "C", "B" },
});

const winTable = std.ComptimeStringMap([]const u8, .{
    .{ "A", "B" },
    .{ "B", "C" },
    .{ "C", "A" },
});

fn playedBasedOnOutcome(outcome: []const u8, them: []const u8) u32 {
    return switch (outcome[0]) {
        'X' => partOneLookupMap.get(looseTable.get(them).?) orelse 0,
        'Y' => partOneLookupMap.get(them) orelse 0,
        'Z' => partOneLookupMap.get(winTable.get(them).?) orelse 0,
        else => unreachable,
    };
}

// For player 1
// 0 => loss
// 1 => draw
// 2 => win
fn wins(us: []const u8, them: []const u8) u32 {
    const p1 = partOneLookupMap.get(us) orelse unreachable;
    const p2 = partOneLookupMap.get(them) orelse unreachable;

    if (p1 == p2) return 1;
    if (p1 == 1 and p2 == 3) return 2;
    if (p1 == 2 and p2 == 1) return 2;
    if (p1 == 3 and p2 == 2) return 2;

    return 0;
}

test "part 1" {}
