#!/usr/bin/env python3
import sys

directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]


def main():
    grid = [list(lines) for lines in sys.stdin.read().strip().splitlines()]
    print(f"part_one: {paths(grid, 100, 2)}")


def print_grid(g: list[list[str]]):
    print("\n".join(["".join(row) for row in g]))


def print_grid_with_path(g: list[list[str]], path: list[tuple[int, int]]):
    for y, row in enumerate(g):
        for x, c in enumerate(row):
            if (x, y) in path:
                print("O", end="")
            else:
                print(c, end="")
        print()


def find(grid: list[list[str]], letter: str) -> tuple[int, int]:
    pos = next((i, row.index(letter)) for i, row in enumerate(grid) if letter in row)
    return (pos[0], pos[1])


def paths(grid: list[list[str]], skip_at_least: int, cheat_blocks: int):
    pathcount = 0
    visited = set()

    def in_bounds(x: int, y: int) -> bool:
        return x >= 0 and x < len(grid) and y >= 0 and y < len(grid[0])

    def find_wall_path(
        pos: tuple[int, int], wall_pos: tuple[int, int]
    ) -> list[tuple[int, int]]:
        wall_x, wall_y = wall_pos
        for steps in range(1, cheat_blocks):
            for dx2, dy2 in directions:
                next_x, next_y = wall_x + dx2 * steps, wall_y + dy2 * steps
                if in_bounds(next_x, next_y) and grid[next_x][next_y] != "#":
                    end_pos = (next_x, next_y)
                    if end_pos in visited:  # dont backtrack
                        continue
                    p = path_len(grid, pos, end_pos)
                    if (p - steps) > skip_at_least and end_pos != pos:
                        return end_pos, p - steps
        return None

    start = find(grid, "S")
    end = find(grid, "E")
    queue = [(0, start)]
    while queue:
        cost, pos = queue.pop(0)
        if pos == end:
            continue

        if pos in visited:
            continue

        visited.add(pos)
        for dx, dy in directions:
            new_x, new_y = pos[0] + dx, pos[1] + dy
            new_pos = (new_x, new_y)
            if not in_bounds(new_x, new_y):
                continue

            if grid[new_x][new_y] == "#":
                wall_path = find_wall_path(pos, (new_x, new_y))
                if wall_path and wall_path[0] != pos:
                    pathcount += 1
            else:
                queue.append((cost + 1, new_pos))
    return pathcount


def path_len(
    grid: list[list[str]], start: tuple[int, int], end: tuple[int, int]
) -> int:
    visited = set()
    queue = [(0, start)]

    while queue:
        cost, pos = queue.pop(0)
        if pos == end:
            return cost

        if pos in visited:
            continue

        visited.add(pos)

        for dx, dy in directions:
            new_x, new_y = pos[0] + dx, pos[1] + dy
            if 0 <= new_x < len(grid) and 0 <= new_y < len(grid[0]):
                if grid[new_x][new_y] != "#":
                    queue.append((cost + 1, (new_x, new_y)))

    return None


if __name__ == "__main__":
    main()
