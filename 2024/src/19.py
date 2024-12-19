#!/usr/bin/env python3
import sys
from functools import cache


def main():
    lines = sys.stdin.read().strip().splitlines()
    patterns = set(pat.strip() for pat in lines[0].split(","))
    wanted = lines[2:]
    print(
        f"part_one: {sum(1 if towel(t, patterns) else 0 for t in wanted)}, part_two: {sum(towel(t, patterns) for t in wanted)}"
    )


def towel(t: str, patterns: set[str]) -> int:
    max_pat = max(len(pat) for pat in patterns)

    @cache
    def dfs(t: str) -> int:
        if not t:
            return 1

        total = 0
        for j in range(min(max_pat, len(t)), 0, -1):
            if t[:j] in patterns:
                total += dfs(t[j:])

        return total

    return dfs(t)


if __name__ == "__main__":
    main()
