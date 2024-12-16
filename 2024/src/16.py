#!/usr/bin/env python3
import sys


directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
type Pos = tuple[int, int]
type Grid = list[list[str]]


def print_grid(g: Grid):
    print("\n".join(["".join(row) for row in g]))


def print_grid_with_path(g: Grid, path: list[tuple[int, int]]):
    grid_copy = [row[:] for row in g]
    for row, col in path:
        if grid_copy[row][col] not in ["S", "E"]:
            grid_copy[row][col] = "O"
    print_grid(grid_copy)


def find(grid: Grid, letter: str) -> tuple[int, int]:
    return next((i, row.index(letter)) for i, row in enumerate(grid) if letter in row)


def find_optimal_path(grid: Grid) -> tuple[list[tuple[tuple[int, int], int]], int]:
    start = find(grid, "S")
    end = find(grid, "E")
    rows = len(grid)
    cols = len(grid[0])
    visited = {}
    queue = [(start, 0, (0, 1), [(start, 0)])]
    first_optimal = None
    min_cost = float("inf")

    while queue:
        pos, cost, last_dir, path = queue.pop(0)
        if pos is None:
            continue
        row, col = pos
        if pos == end:
            if cost < min_cost:
                min_cost = cost
                first_optimal = path
            continue
        if pos in visited and visited[pos] <= cost:
            continue
        visited[pos] = cost
        for dr, dc in directions:
            new_row, new_col = row + dr, col + dc
            new_dir = (dr, dc)
            if (
                0 <= new_row < rows
                and 0 <= new_col < cols
                and grid[new_row][new_col] != "#"
            ):
                # turn + move
                new_cost = cost + (
                    1 if new_dir == last_dir or last_dir is None else 1001
                )

                if new_cost < min_cost:
                    new_path = path + [((new_row, new_col), new_cost)]
                    queue.append(((new_row, new_col), new_cost, new_dir, new_path))

    return first_optimal, min_cost


def find_branch_paths(
    grid: Grid, optimal: list[tuple[tuple[int, int], int]], best: int
) -> list[tuple[int, int]]:
    all_optimal_positions = set(pos for pos, _ in optimal)
    optimal_costs = {pos: cost for pos, cost in optimal}
    rejected_paths: dict[tuple[Pos, tuple[int, int] | None], int] = {}

    def is_valid(row: int, col: int) -> bool:
        return grid[row][col] != "#"

    def explore(
        pos: Pos, cost: int, last_dir: tuple[int, int] | None, visited: dict[Pos, int]
    ) -> None:
        if cost > best:
            rejected_paths[(pos, last_dir)] = cost
            return
        state = (pos, last_dir)
        if state in rejected_paths and cost >= rejected_paths[state]:
            return

        if pos in visited and visited[pos] <= cost and pos not in optimal_costs:
            rejected_paths[state] = cost
            return

        visited[pos] = cost
        row, col = pos

        if pos in optimal_costs and cost == optimal_costs[pos]:
            all_optimal_positions.update(visited.keys())
            return

        for dr, dc in directions:
            next_pos = (row + dr, col + dc)
            if not is_valid(next_pos[0], next_pos[1]):
                continue

            new_cost = cost + (1 if (dr, dc) == last_dir or last_dir is None else 1001)

            if new_cost <= best:
                explore(next_pos, new_cost, (dr, dc), visited.copy())

    start = find(grid, "S")
    explore(start, 0, None, {})

    for pos, cost in optimal:
        row, col = pos
        for dr, dc in directions:
            next_pos = (row + dr, col + dc)
            if is_valid(next_pos[0], next_pos[1]) and next_pos not in optimal_costs:
                explore(next_pos, cost + 1, (dr, dc), {pos: cost})

    return all_optimal_positions


def main():
    grid: Grid = [list(line) for line in sys.stdin.read().strip().splitlines()]
    path, cost = find_optimal_path(grid)
    pos = find_branch_paths(grid, path, cost)
    print(f"part_one: {cost}, part_two: {len(pos)}")


if __name__ == "__main__":
    main()
