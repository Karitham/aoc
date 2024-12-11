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
    def process_number(s: int) -> tuple[int, int | None]:
        dl = digits_len(s)
        if s == 0:
            return (1, None)
        elif dl % 2 == 0:
            half = 10 ** (dl // 2)
            return (s // half, s % half)
        else:
            return (s * 2024, None)

    result = [s for s in stones]
    for _ in range(it):
        for i, s in enumerate(result[: len(result)]):
            new_val, remainder = process_number(s)
            result[i] = new_val
            if remainder is not None:
                result.append(remainder)
    return len(result)


def main():
    stones = list(map(int, sys.stdin.read().strip().split()))
    print(f"part_one: {solve(stones, 25)}, part_two: {solve(stones, 75)}")


if __name__ == "__main__":
    main()
