#!/usr/bin/env python3
import sys


directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
type Pos = tuple[int, int, int]
type Grid = list[list[str]]


def print_grid(g: Grid):
    print("\n".join(["".join(row) for row in g]))


def print_grid_with_path(g: Grid, path: list[tuple[int, int]]):
    grid_copy = [row[:] for row in g]
    for row, col in path:
        grid_copy[row][col] = "O"
    print_grid(grid_copy)


def find(grid: Grid, letter: str) -> tuple[int, int, int]:
    pos = next((i, row.index(letter)) for i, row in enumerate(grid) if letter in row)
    return (pos[0], pos[1], 0)


def find_optimal_path(
    grid: Grid,
) -> tuple[list[tuple[tuple[int, int, int], int]], int]:
    start = find(grid, "S")
    end = find(grid, "E")
    visited = {}
    queue = [(start, 0, [(start, 0)])]
    min_cost = float("inf")

    while queue:
        pos, cost, path = queue.pop(0)
        if pos is None:
            continue

        row, col, last_dir = pos
        if (row, col) == (end[0], end[1]):
            if cost < min_cost:
                min_cost = cost
                first_optimal = path
            continue
        if pos in visited and visited[pos] <= cost:
            continue
        visited[pos] = cost
        for dir_idx, (dr, dc) in enumerate(directions):
            new_row, new_col = row + dr, col + dc
            if grid[new_row][new_col] != "#":
                new_cost = cost + (1 if dir_idx == last_dir else 1001)
                if new_cost < min_cost:
                    new_pos = (new_row, new_col, dir_idx)
                    new_path = path + [(new_pos, new_cost)]
                    queue.append((new_pos, new_cost, new_path))

    return first_optimal, min_cost


def find_branch_paths(
    grid: Grid, optimal: list[tuple[tuple[int, int, int], int]], best: int
) -> list[tuple[int, int]]:
    all_optimal_positions = set((x, y) for (x, y, _), _ in optimal)
    optimal_costs = {pos: cost for pos, cost in optimal}
    dir_visited = {}

    def explore(pos: Pos, cost: int, visited: dict[tuple[int, int], int]) -> None:
        base_pos = (pos[0], pos[1])

        if pos in optimal_costs:
            if cost <= optimal_costs[pos]:
                all_optimal_positions.update(visited.keys())
                all_optimal_positions.add(base_pos)
                return
        if pos in dir_visited and cost > dir_visited[pos]:
            return

        dir_visited[pos] = cost
        visited[base_pos] = cost

        row, col, last_dir = pos
        for dir_idx, (dr, dc) in enumerate(directions):
            next_pos = (row + dr, col + dc, dir_idx)
            if grid[next_pos[0]][next_pos[1]] != "#":
                new_cost = cost + (1 if dir_idx == last_dir else 1001)

                if new_cost <= best:
                    explore(next_pos, new_cost, visited.copy())

    for pos, cost in optimal:
        row, col, _ = pos
        for new_dir_idx, (dr, dc) in enumerate(directions):
            next_pos = (row + dr, col + dc, new_dir_idx)
            if grid[next_pos[0]][next_pos[1]] != "#" and next_pos not in optimal_costs:
                explore(next_pos, cost + 1, {(row, col): cost})

    return all_optimal_positions


def main():
    grid: Grid = [list(line) for line in sys.stdin.read().strip().splitlines()]
    path, cost = find_optimal_path(grid)
    pos = find_branch_paths(grid, path, cost)
    print(f"part_one: {cost}, part_two: {len(pos)}")


if __name__ == "__main__":
    main()
