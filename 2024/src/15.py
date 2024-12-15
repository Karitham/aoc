#!/usr/bin/env python3
import sys

type Pos = tuple[int, int]
type Grid = list[list[str]]
type MoveSet = list[tuple[int, int]]

moves = {"v": (1, 0), "^": (-1, 0), ">": (0, 1), "<": (0, -1)}


def print_grid(g: Grid):
    print("\n".join(["".join(row) for row in g]))


def move(g: Grid, robot: Pos, ms: MoveSet) -> Grid:
    g = [row[:] for row in g]
    ry, rx = robot
    height, width = len(g), len(g[0])
    for my, mx in ms:
        ny, nx = ry + my, rx + mx

        if g[ny][nx] == "#":
            continue

        if g[ny][nx] == ".":
            g[ry][rx] = "."
            g[ny][nx] = "@"
            ry, rx = ny, nx
            continue

        if g[ny][nx] == "O":
            first_o_pos = (ny, nx)
            while True:
                ny, nx = ny + my, nx + mx
                if ny < 0 or ny >= height or nx < 0 or nx >= width or g[ny][nx] == "#":
                    ny, nx = ny - my, nx - mx
                    break

                if g[ny][nx] == ".":
                    g[first_o_pos[0]][first_o_pos[1]] = "."
                    g[ny][nx] = "O"
                    g[ry][rx] = "."
                    g[first_o_pos[0]][first_o_pos[1]] = "@"
                    ry, rx = first_o_pos[0], first_o_pos[1]
                    break
    return g


def widen(g: Grid) -> Grid:
    new_grid = []
    for row in g:
        new_row = []
        for tile in row:
            if tile == "#":
                new_row.extend(["#", "#"])
            elif tile == "O":
                new_row.extend(["[", "]"])
            elif tile == ".":
                new_row.extend([".", "."])
            elif tile == "@":
                new_row.extend(["@", "."])
        new_grid.append(new_row)
    return new_grid


def move2(g: Grid, robot: Pos, ms: MoveSet) -> Grid:
    pass


def main():
    sections: list[str] = sys.stdin.read().split("\n\n")
    moveset = [moves[let] for let in "".join(sections[1].strip().splitlines())]
    grid = [list(line) for line in sections[0].splitlines()]
    robot = next((i, row.index("@")) for i, row in enumerate(grid) if "@" in row)
    ng = move(grid, robot, moveset)
    part_one = sum(
        sum(100 * i + j for j, point in enumerate(row) if point == "O")
        for i, row in enumerate(ng)
    )
    ng2 = move2(widen(grid), robot, moveset)
    part_two = sum(
        sum(100 * i + j for j, point in enumerate(row) if point == "[")
        for i, row in enumerate(ng2)
    )
    print_grid(ng2)
    print(f"part_one: {part_one}, part_two: {part_two}")


if __name__ == "__main__":
    main()
