#!/usr/bin/env python3
import sys
import re

# thought process:
# Using a regression would probably work but most likely I would be stuck with local minimas and stuff. Bad idea
# Since this is a system of 2 equations, there must be a mathy way of solving it.
# I don't know how to solve it by hand so I'm looking through the math ways of doing things.

system = tuple[tuple[tuple[int, int], tuple[int, int]], tuple[int, int]]


# https://en.wikipedia.org/wiki/Cramer%27s_rule#Explicit_formulas_for_small_systems
def cramer(s: system):
    ((a1, a2), (b1, b2)), (r1, r2) = s

    # Calculate determinant of coefficient matrix
    D = a1 * b2 - a2 * b1

    # Calculate determinant for x
    Dx = r1 * b2 - r2 * b1

    # Calculate determinant for y
    Dy = a1 * r2 - a2 * r1

    # Apply Cramer's rule
    x = Dx / D
    y = Dy / D

    return (x, y)


# Button A: X+26, Y+66
# Button B: X+67, Y+21
# Prize: X=12748, Y=12176
def parse(lines: list[str]) -> system:
    a = map(int, re.findall(r"Button A: X\+(\d+), Y\+(\d+)", lines[0])[0])
    b = map(int, re.findall(r"Button B: X\+(\d+), Y\+(\d+)", lines[1])[0])
    r = map(int, re.findall(r"Prize: X=(\d+), Y=(\d+)", lines[2])[0])
    return ((tuple(a), tuple(b)), tuple(r))


def main():
    systems = [parse(line.splitlines()) for line in sys.stdin.read().split("\n\n")]
    part_one = []
    part_two = []

    for s in systems:
        x, y = cramer(s)
        if x.is_integer() and y.is_integer() and 0 <= x < 100 and 0 <= y < 100:
            part_one.append(int(x * 3 + y))

        e, (r1, r2) = s
        x, y = cramer((e, (r1 + 10000000000000, r2 + 10000000000000)))
        if x.is_integer() and y.is_integer():
            part_two.append(int(x * 3 + y))

    print(f"part_one: {sum(part_one)}, part_two: {sum(part_two)}")


if __name__ == "__main__":
    main()
