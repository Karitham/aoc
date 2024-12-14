#!/usr/bin/env python3
import sys
import re

# The first two are position, the last two are direction
type Robot = tuple[int, int, int, int]
type Grid = tuple[int, int]


def move(robot: Robot, pmax: Grid) -> Robot:
    x, y, dx, dy = robot
    x = ((x + dx) % pmax[0] + pmax[0]) % pmax[0]
    y = ((y + dy) % pmax[1] + pmax[1]) % pmax[1]
    return x, y, dx, dy


def print_robots(robots: list[Robot], pmax: Grid):
    grid = [[0] * pmax[0] for _ in range(pmax[1])]
    for x, y, _, _ in robots:
        grid[y][x] += 1

    for row in grid:
        for count in row:
            print("." if count == 0 else str(count), end="")
        print()
    print()


def isTree(robots: list[Robot], pmax: Grid) -> bool:
    grid = [[0] * pmax[0] for _ in range(pmax[1])]
    for x, y, _, _ in robots:
        grid[y][x] += 1

    for row in grid:
        count = 0
        for cell in row:
            if cell > 0:
                count += 1
            else:
                count = 0
            if count >= 10:
                return True
    return False


def quadrants(robots: list[Robot], pmax: Grid) -> int:
    mid_x = pmax[0] // 2
    mid_y = pmax[1] // 2
    q1, q2, q3, q4 = 0, 0, 0, 0

    for x, y, _, _ in robots:
        if x > mid_x and y < mid_y:
            q1 += 1
        elif x < mid_x and y < mid_y:
            q2 += 1
        elif x < mid_x and y > mid_y:
            q3 += 1
        elif x > mid_x and y > mid_y:
            q4 += 1

    return q1 * q2 * q3 * q4


def main():
    robots = [
        tuple([int(arg) for arg in re.findall("-?\\d+", line)])
        for line in sys.stdin.read().splitlines()
    ]
    grid = (101, 103)
    r = [r for r in robots]
    for _ in range(100):
        for i, robot in enumerate(r):
            r[i] = move(robot, grid)
    q = quadrants(r, grid)

    r = [r for r in robots]
    iters = 0
    while not isTree(r, grid):
        iters += 1
        for i, robot in enumerate(r):
            r[i] = move(robot, grid)
        # print_robots(r, grid)
    print(f"part_one: {q}, part_two: {iters}")


if __name__ == "__main__":
    main()
