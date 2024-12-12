#!/usr/bin/env python3
import sys

# thought process:
# Look through each point in the grid. Every time we stumble upon a kind, measure it.
# Store all the passed through points such that we only go through them once.
# Iterate the grid, recurse into each grid part that's not stored yet.
#
# The area of a thing is the total count of points,
# The perimeter can be computed while we flood-fill the area.

Area = set[tuple[int, int]]
Plant = str
directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]


def areas(grid: list[list[Plant]]) -> dict[Plant, list[Area]]:
    result = {}
    visited = set()
    rows, cols = len(grid), len(grid[0])

    def flood_fill(r: int, c: int, plant: Plant) -> Area:
        if (
            not (0 <= r < rows and 0 <= c < cols)
            or grid[r][c] != plant
            or (r, c) in visited
        ):
            return set()

        area = {(r, c)}
        visited.add((r, c))
        for dr, dc in directions:
            area.update(flood_fill(r + dr, c + dc, plant))
        return area

    for r in range(rows):
        for c in range(cols):
            if (r, c) not in visited:
                plant = grid[r][c]
                if area := flood_fill(r, c, plant):
                    result.setdefault(plant, []).append(area)
    return result


def perim(area: Area) -> int:
    return sum(
        sum(1 for dr, dc in directions if (r + dr, c + dc) not in area) for r, c in area
    )


def sides(area: Area) -> int:
    # idea from https://github.com/SHA65536/AdventOfCodeGo/blob/42536cbc645bba04f1c0f1cd1eefbf83ef53b9f5/2024/day12/day12.go#L81
    # I did not come up with this scanning approach.
    def scan(points: tuple[int, int], direction: tuple[int, int]) -> int:
        dx, dy = direction
        count = 0
        bulk = False
        for pos in points:
            if pos not in area:
                bulk = False
                continue

            if (pos[0] + dx, pos[1] + dy) not in area and not bulk:
                count += 1
            bulk = (pos[0] + dx, pos[1] + dy) not in area
        return count

    # Get the bounding box coordinates
    min_x, max_x = min(x for x, _ in area), max(x for x, _ in area)
    min_y, max_y = min(y for _, y in area), max(y for _, y in area)

    # Create a grid of all points within the bounding box
    rows = [[(x, y) for y in range(min_y, max_y + 1)] for x in range(min_x, max_x + 1)]

    # Transpose rows to get columns
    cols = list(zip(*rows))

    up = sum(scan(row, (-1, 0)) for row in rows)
    down = sum(scan(row, (1, 0)) for row in rows)
    left = sum(scan(col, (0, -1)) for col in cols)
    right = sum(scan(col, (0, 1)) for col in cols)
    return up + down + left + right


def main():
    plots = areas(list(map(list, sys.stdin.read().strip().split())))
    part_one = sum(len(area) * perim(area) for pl in plots for area in plots[pl])
    part_two = sum(len(area) * sides(area) for pl in plots for area in plots[pl])
    print(f"part_one: {part_one}, part_two: {part_two}")


if __name__ == "__main__":
    main()
