const std = @import("std");
const input = @embedFile("07.input");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var alloc = arena.allocator();

    var lines = std.mem.split(u8, input, "\n");

    // parse input into list of statements
    var statements = std.ArrayListUnmanaged(Statement){};
    defer statements.deinit(alloc);
    while (lines.next()) |line| {
        try statements.append(alloc, Statement.parse(line));
    }

    // create root folder
    var root = Folder{
        .name = "/",
    };

    // execute statements
    var current_folder = &root;

    // construct a tree of folders
    for (statements.items) |statement| {
        switch (statement) {
            .command => |cmd| {
                switch (cmd) {
                    .cd => |cd| {
                        if (std.mem.eql(u8, cd.dir, "..")) {
                            current_folder = &root;
                        } else {
                            for (current_folder.entries.items) |*entry| {
                                if (std.mem.eql(u8, entry.name(), cd.dir)) {
                                    current_folder = &entry.Folder;
                                    break;
                                }
                            }
                        }
                    },
                    .ls => {},
                }
            },
            .entry => |entry| {
                try current_folder.append(alloc, entry);
            },
        }
    }

    // printTree(root, 0);
    try std.json.stringify(
        root,
        std.json.StringifyOptions{},
        std.io.getStdOut().writer(),
    );

    const total_size = findSub(root, 100000);
    _ = total_size;
    // std.debug.print("total size: {}\n", .{total_size});
}

fn findSub(root: Folder, max_size: usize) usize {
    var total_size: usize = 0;
    for (root.entries.items) |entry| {
        switch (entry) {
            .Folder => |folder| {
                total_size += findSub(folder, max_size);
                if (folder.size() <= max_size and folder.size() > 0) {
                    total_size += folder.size();
                }
            },
            .File => {},
        }
    }
    return total_size;
}

// printTree prints the tree by recursively calling itself such that the tree is indentated
fn printTree(folder: Folder, indent: usize) void {
    var i: usize = 0;
    while (i < indent) : (i += 1) {
        std.debug.print("\t", .{});
    }
    std.debug.print("{}\n", .{folder});

    for (folder.entries.items) |entry| {
        i = 0;
        while (i < indent) : (i += 1) {
            std.debug.print("\t", .{});
        }

        switch (entry) {
            .Folder => |f| printTree(f, indent + 1),
            .File => |f| std.debug.print("{}\n", .{f}),
        }
    }
}

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
            return .ls;
        }

        std.debug.panic("panic {s}", .{line});
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
        try std.fmt.format(writer, "{s} (dir, size={d})", .{ self.name, self.size() });
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
        try std.fmt.format(writer, "{s} (file, size={})", .{ self.name, self.size });
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

    fn format(self: Entry, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return switch (self) {
            .Folder => |f| std.fmt.format(writer, "{}", .{f}),
            .File => |f| std.fmt.format(writer, "{}", .{f}),
        };
    }
};

const Statement = union(enum) {
    command: Command,
    entry: Entry,

    pub fn parse(line: []const u8) Statement {
        var it = std.mem.tokenize(u8, line, " ");
        const peek = it.peek().?;

        return if (std.mem.eql(u8, peek, "$")) x: {
            _ = it.next().?;
            break :x Statement{ .command = Command.parse(it.rest()) };
        } else Statement{ .entry = Entry.parse(line) };
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
