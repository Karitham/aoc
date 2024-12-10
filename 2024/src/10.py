#!/usr/bin/env python3
import sys


directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]


def descend_set(pos: tuple[int, int], g: list[list[int]]) -> set[tuple[int, int]]:
    return (
        {pos}
        if g[pos[0]][pos[1]] == 9
        else set().union(
            *[
                descend_set((pos[0] + dx, pos[1] + dy), g)
                for dx, dy in directions
                if 0 <= pos[0] + dx < len(g)
                and 0 <= pos[1] + dy < len(g[0])
                and g[pos[0] + dx][pos[1] + dy] == g[pos[0]][pos[1]] + 1
            ]
        )
    )


def descend_int(pos: tuple[int, int], g: list[list[int]]) -> int:
    return (
        1
        if g[pos[0]][pos[1]] == 9
        else sum(
            descend_int((pos[0] + dx, pos[1] + dy), g)
            for dx, dy in directions
            if 0 <= pos[0] + dx < len(g)
            and 0 <= pos[1] + dy < len(g[0])
            and g[pos[0] + dx][pos[1] + dy] == g[pos[0]][pos[1]] + 1
        )
    )


def main():
    grid = [list(map(int, line)) for line in sys.stdin.read().strip().splitlines()]

    part_one = sum(
        len(descend_set((i, j), grid))
        for i, row in enumerate(grid)
        for j, val in enumerate(row)
        if val == 0
    )
    part_two = sum(
        descend_int((i, j), grid)
        for i, row in enumerate(grid)
        for j, val in enumerate(row)
        if val == 0
    )
    print(f"part_one: {part_one}, part_two: {part_two}")


if __name__ == "__main__":
    main()
