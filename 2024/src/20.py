#!/usr/bin/env python3
import sys

directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]


def main():
    grid = [list(lines) for lines in sys.stdin.read().strip().splitlines()]
    print(f"part_one: {paths(grid, 100, 2)}, part_two: {paths(grid, 100, 2)}")


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


def manhattan_distance(a: tuple[int, int], b: tuple[int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


def paths(grid: list[list[str]], skip_at_least: int, cheat_blocks: int):
    pathcount = 0
    visited = set()

    def in_bounds(x: int, y: int) -> bool:
        return x >= 0 and x < len(grid) and y >= 0 and y < len(grid[0])

    def path_len(start: tuple[int, int], end: tuple[int, int]) -> int:
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

    def find_wall_path(
        path_pos: tuple[int, int], wall_pos: tuple[int, int]
    ) -> list[tuple[int, int]]:
        wall_x, wall_y = wall_pos
        end_pos_candidates = set()
        for dx, dy in directions:
            for i in range(1, cheat_blocks):
                end_x, end_y = wall_x + dx * i, wall_y + dy * i
                if (
                    in_bounds(end_x, end_y)
                    and grid[end_x][end_y] != "#"
                    and (end_x, end_y) not in visited
                    and manhattan_distance(path_pos, (end_x, end_y)) <= cheat_blocks
                    and (end_x, end_y) != wall_pos
                ):
                    end_pos_candidates.add((end_x, end_y))
        s = 0
        for end_pos in end_pos_candidates:
            p = path_len(path_pos, end_pos)
            # print_grid_with_path(grid, [path_pos, wall_pos, end_pos])
            if (
                p
                and end_pos != path_pos
                and (p - manhattan_distance(path_pos, end_pos)) >= skip_at_least
            ):
                s += 1
        return s

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
                if wall_path:
                    pathcount += wall_path
            else:
                queue.append((cost + 1, new_pos))
    return pathcount


if __name__ == "__main__":
    main()
