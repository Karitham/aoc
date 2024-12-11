#!/usr/bin/env python3
import sys


def solve(stones: list[int], it: int = 25) -> int:
    from functools import cache

    @cache
    def digits_len(v: int) -> int:
        if v // 10 == 0:
            return 1
        return digits_len(v // 10) + 1

    @cache
    def process_stone(stone: int, depth: int) -> int:
        if depth == it:
            return 1

        dl = digits_len(stone)
        if stone == 0:
            new_val, remainder = (1, None)
        elif dl % 2 == 0:
            half = 10 ** (dl // 2)
            new_val, remainder = (stone // half, stone % half)
        else:
            new_val, remainder = (stone * 2024, None)

        if remainder is None:
            return process_stone(new_val, depth + 1)
        return process_stone(new_val, depth + 1) + process_stone(remainder, depth + 1)

    return sum(process_stone(stone, 0) for stone in stones)


def main():
    stones = list(map(int, sys.stdin.read().strip().split()))
    print(f"part_one: {solve(stones, 25)}, part_two: {solve(stones, 75)}")


if __name__ == "__main__":
    main()
