const std = @import("std");
const input = @embedFile("05.input");

pub fn main() !void {
    var buf: [2048]u8 = undefined;
    var fbs = std.heap.FixedBufferAllocator.init(&buf);
    var alloc = fbs.allocator();

    var lines = std.mem.split(u8, input, "\n\n");

    const stacks = lines.next().?;
    const instructions = lines.next().?;

    var it = std.mem.tokenize(u8, instructions, "\n");
    {
        var stack = try Stack.parse(alloc, stacks);
        defer stack.deinit(alloc);

        while (it.next()) |instruction| {
            const m = try Move.parse(instruction);
            try stack.apply(alloc, m);
        }

        var tops: [9]u8 = undefined;
        for (tops) |*t, i| {
            t.* = stack.stacks[i].items[0];
        }

        std.debug.print("part 1: {s}\n", .{tops});
    }

    it.reset();
    {
        var stack = try Stack.parse(alloc, stacks);
        defer stack.deinit(alloc);

        while (it.next()) |instruction| {
            const m = try Move.parse(instruction);
            try stack.apply2(alloc, m);
        }

        var tops: [9]u8 = undefined;
        for (tops) |*t, i| {
            t.* = stack.stacks[i].items[0];
        }

        std.debug.print("part 2: {s}\n", .{tops});
    }
}

test "part 1" {
    std.debug.print("part 1 test:\n", .{});
    const in =
        \\    [D]    
        \\[N] [C]    
        \\[Z] [M] [P]
        \\ 1   2   3 
        \\
        \\move 1 from 2 to 1
        \\move 3 from 1 to 3
        \\move 2 from 2 to 1
        \\move 1 from 1 to 2
    ;

    var lines = std.mem.split(u8, in, "\n\n");

    var alloc = std.testing.allocator;
    var stack = try Stack.parse(alloc, lines.first());
    defer stack.deinit(alloc);

    var instructions = lines.rest();

    var it = std.mem.tokenize(u8, instructions, "\n");

    while (it.next()) |instruction| {
        const m = try Move.parse(instruction);

        try stack.apply(alloc, m);
    }

    var tops: [3]u8 = undefined;
    for (tops) |*t, i| {
        t.* = stack.stacks[i].items[0];
    }

    std.debug.print("part 1: {s}\n", .{tops});
}

const Move = struct {
    src: u8,
    dst: u8,
    qty: u8,

    pub fn parse(in: []const u8) !Move {
        var it = std.mem.tokenize(u8, in, " ");

        // move
        _ = it.next().?;
        const qty = try std.fmt.parseInt(u8, it.next() orelse return error.BadMove, 10);
        // from
        _ = it.next().?;
        const src = try std.fmt.parseInt(u8, it.next() orelse return error.BadMove, 10);
        // to
        _ = it.next().?;
        const dst = try std.fmt.parseInt(u8, it.next() orelse return error.BadMove, 10);

        return Move{
            .src = src,
            .dst = dst,
            .qty = qty,
        };
    }

    test "parse" {
        const in =
            \\move 1 from 2 to 1
            \\move 3 from 1 to 3
            \\move 2 from 2 to 1
            \\move 1 from 1 to 2
        ;

        var it = std.mem.tokenize(u8, in, "\n");
        const m1 = try Move.parse(it.next().?);
        const m2 = try Move.parse(it.next().?);
        const m3 = try Move.parse(it.next().?);
        const m4 = try Move.parse(it.next().?);

        try std.testing.expectEqual(Move{ .src = 2, .dst = 1, .qty = 1 }, m1);
        try std.testing.expectEqual(Move{ .src = 1, .dst = 3, .qty = 3 }, m2);
        try std.testing.expectEqual(Move{ .src = 2, .dst = 1, .qty = 2 }, m3);
        try std.testing.expectEqual(Move{ .src = 1, .dst = 2, .qty = 1 }, m4);
    }
};

const Stack = struct {
    stacks: []std.ArrayListUnmanaged(u8),

    fn deinit(self: *Stack, alloc: std.mem.Allocator) void {
        for (self.stacks) |*stack| {
            stack.deinit(alloc);
        }

        alloc.free(self.stacks);
    }

    pub fn parse(alloc: std.mem.Allocator, in: []const u8) !Stack {
        var it = std.mem.split(u8, in, "\n");

        var self = Stack{
            .stacks = try alloc.alloc(std.ArrayListUnmanaged(u8), 9),
        };

        for (self.stacks) |*stack| {
            stack.* = try std.ArrayListUnmanaged(u8).initCapacity(alloc, 64);
        }

        while (it.next()) |line| {
            // last line starts with " 1"
            if (line[0] == ' ' and std.ascii.isDigit(line[1])) break;

            // read by blocks of 3 chars `[A-Z]|   ` then ` ` to loop or `\n` to continue
            var line_it = std.mem.split(u8, line, " ");

            var i: usize = 0;

            while (line_it.next()) |block| : (i += 1) {
                if (block.len == 0) {
                    _ = line_it.next().?;
                    _ = line_it.next().?;
                    _ = line_it.next().?;
                    continue;
                }
                if (block.len != 3) return error.BadStack;

                self.stacks[i].appendAssumeCapacity(block[1]);
            }
        }

        return self;
    }

    test "parse" {
        const in =
            \\[T]             [P]     [J]        
            \\[F]     [S]     [T]     [R]     [B]
            \\[V]     [M] [H] [S]     [F]     [R]
            \\[Z]     [P] [Q] [B]     [S] [W] [P]
            \\[C]     [Q] [R] [D] [Z] [N] [H] [Q]
            \\[W] [B] [T] [F] [L] [T] [M] [F] [T]
            \\[S] [R] [Z] [V] [G] [R] [Q] [N] [Z]
            \\[Q] [Q] [B] [D] [J] [W] [H] [R] [J]
            \\ 1   2   3   4   5   6   7   8   9 
        ;

        var alloc = std.testing.allocator;
        var stacks = try Stack.parse(alloc, in);
        defer stacks.deinit(alloc);

        try std.testing.expectEqual(stacks.stacks[0].items.len, 8);
        try std.testing.expectEqual(stacks.stacks[1].items.len, 3);
        try std.testing.expectEqual(stacks.stacks[2].items.len, 7);
        try std.testing.expectEqual(stacks.stacks[3].items.len, 6);
        try std.testing.expectEqual(stacks.stacks[4].items.len, 8);
        try std.testing.expectEqual(stacks.stacks[5].items.len, 4);
        try std.testing.expectEqual(stacks.stacks[6].items.len, 8);
        try std.testing.expectEqual(stacks.stacks[7].items.len, 5);
        try std.testing.expectEqual(stacks.stacks[8].items.len, 7);

        try std.testing.expectEqual(stacks.stacks[0].items[0], 'T');
        try std.testing.expectEqual(stacks.stacks[0].items[1], 'F');

        try std.testing.expectEqual(stacks.stacks[1].items[0], 'B');
        try std.testing.expectEqual(stacks.stacks[1].items[1], 'R');
    }

    fn apply(self: *Stack, alloc: std.mem.Allocator, move: Move) !void {
        var i: usize = 0;
        var src = &self.stacks[move.src - 1];
        var dst = &self.stacks[move.dst - 1];

        while (i < move.qty) : (i += 1) {
            try dst.insert(alloc, 0, src.orderedRemove(0));
        }
    }

    // apply2 is the same as apply except the moved blocks are inserted all at once
    fn apply2(self: *Stack, alloc: std.mem.Allocator, move: Move) !void {
        var i: usize = 0;
        var src = &self.stacks[move.src - 1];
        var dst = &self.stacks[move.dst - 1];

        try dst.insertSlice(alloc, 0, src.items[0..move.qty]);

        while (i < move.qty) : (i += 1) {
            _ = src.orderedRemove(0);
        }
    }
};

test {
    std.testing.refAllDecls(Move);
    std.testing.refAllDecls(Stack);
}
