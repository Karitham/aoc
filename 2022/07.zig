const std = @import("std");

pub fn main() !void {}

const CdCMD = struct {
    dir: []const u8,

    pub fn parse(line: []const u8) CdCMD {
        var line_it = std.mem.tokenize(u8, line, " ");
        _ = line_it.next().?;
        return CdCMD{
            .dir = line_it.next().?,
        };
    }
};

const LSCommand = struct {};

const Command = union(enum) {
    cd: CdCMD,
    ls,

    pub fn parse(line: []const u8) Command {
        var line_it = std.mem.tokenize(u8, line, " ");
        const cmd = line_it.peek().?;
        if (std.mem.eql(u8, cmd, "cd")) {
            return Command{ .cd = CdCMD.parse(line) };
        } else if (std.mem.eql(u8, line_it.rest(), "ls")) {
            return Command{.ls};
        }

        unreachable;
    }
};

const Folder = struct {
    name: []const u8,
    entries: std.ArrayListUnmanaged(Entry) = .{},

    pub fn parse(line: []const u8) Folder {
        var line_it = std.mem.tokenize(u8, line, " ");
        _ = line_it.next().?;
        return Folder{
            .name = line_it.rest(),
        };
    }

    pub fn deinit(self: *Folder, alloc: std.mem.Allocator) void {
        for (self.entries.items) |*entry| {
            switch (entry.*) {
                .Folder => |*folder| folder.deinit(alloc),
                .File => {},
            }
        }
        self.entries.deinit(alloc);
    }

    pub fn append(self: *Folder, alloc: std.mem.Allocator, entry: Entry) !void {
        try self.entries.append(alloc, entry);
    }

    fn size(self: Folder) usize {
        var s: usize = 0;
        for (self.entries.items) |file| {
            s += file.size();
        }
        return s;
    }

    pub fn format(self: Folder, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try std.fmt.format(writer, "{s} ({} bytes)\n", .{ self.name, self.size() });

        for (self.entries.items) |entry| {
            try std.fmt.format(writer, " {s}\n", .{entry});
        }
    }
};

const File = struct {
    name: []const u8,
    size: usize,

    pub fn parse(line: []const u8) File {
        var line_it = std.mem.tokenize(u8, line, " ");
        const size = line_it.next().?;
        return File{
            .name = line_it.rest(),
            .size = std.fmt.parseInt(usize, size, 10) catch unreachable,
        };
    }

    pub fn format(self: File, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try std.fmt.format(writer, "{d} {s}", .{ self.size, self.name });
    }
};

const Entry = union(enum) {
    Folder: Folder,
    File: File,

    pub fn parse(line: []const u8) Entry {
        var line_it = std.mem.tokenize(u8, line, " ");
        const firstWord = line_it.next().?;
        if (std.mem.eql(u8, firstWord, "dir")) {
            return Entry{ .Folder = Folder.parse(line) };
        } else {
            return Entry{ .File = File.parse(line) };
        }
    }

    fn deinit(self: *Entry, alloc: std.mem.Allocator) void {
        switch (self.*) {
            .Folder => |*folder| folder.deinit(alloc),
            .File => {},
        }
    }

    fn name(self: Entry) []const u8 {
        return switch (self) {
            .Folder => self.Folder.name,
            .File => self.File.name,
        };
    }

    fn size(self: Entry) usize {
        return switch (self) {
            .Folder => self.Folder.size(),
            .File => self.File.size,
        };
    }

    pub fn format(self: Entry, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return switch (self) {
            .Folder => |folder| std.fmt.format(writer, "{s}", .{folder}),
            .File => |file| std.fmt.format(writer, "{s}", .{file}),
        };
    }
};

const Statement = union(enum) {
    command: Command,
    entry: Entry,

    pub fn parse(line: []const u8) Statement {
        var it = std.mem.tokenize(u8, line, " ");
        const peek = it.peek().?;

        return if (std.mem.eql(u8, peek, "$"))
            Statement{ .command = Command.parse(line) }
        else
            Statement{ .entry = Entry.parse(line) };
    }
};

const example_input =
    \\ $ cd /
    \\ $ ls
    \\ dir a
    \\ 14848514 b.txt
    \\ 8504156 c.dat
    \\ dir d
    \\ $ cd a
    \\ $ ls
    \\ dir e
    \\ 29116 f
    \\ 2557 g
    \\ 62596 h.lst
    \\ $ cd e
    \\ $ ls
    \\ 584 i
    \\ $ cd ..
    \\ $ cd ..
    \\ $ cd d
    \\ $ ls
    \\ 4060174 j
    \\ 8033020 d.log
    \\ 5626152 d.ext
    \\ 7214296 k
;
