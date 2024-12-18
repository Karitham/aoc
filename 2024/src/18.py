#!/usr/bin/env python3
import sys
import collections


def bfs(start, end, max, obstacles):
    queue = collections.deque([(start, 0)])  # (position, distance)
    visited = {start}

    while queue:
        pos, dist = queue.popleft()
        if pos == end:
            return dist

        # Check all 4 directions
        for dx, dy in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
            next_pos = (pos[0] + dx, pos[1] + dy)

            # Valid move checks
            if (
                0 <= next_pos[0] <= max[0]
                and 0 <= next_pos[1] <= max[1]
                and next_pos not in obstacles
                and next_pos not in visited
            ):
                queue.append((next_pos, dist + 1))
                visited.add(next_pos)

    return None  # No path found


def main():
    obstacles = [
        tuple(map(int, line.split(",")))
        for line in sys.stdin.read().strip().splitlines()
    ]

    pathAt = bfs((0, 0), (70, 70), (70, 70), set(obstacles[:1024]))
    lastInvalid = (0, 0)
    for i in range(len(obstacles)):
        obst = obstacles[: len(obstacles) - 1 - i]
        if bfs((0, 0), (70, 70), (70, 70), set(obst)):
            # this one got through, so the lastInvalid is
            lastInvalid = obstacles[len(obstacles) - i - 1]
            break
    print(f"part_one: '{pathAt}', part_two: '{lastInvalid[0]},{lastInvalid[1]}'")


if __name__ == "__main__":
    main()
