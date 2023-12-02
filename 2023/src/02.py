import sys
from functools import reduce
from operator import mul


def parse_game(l: str) -> tuple[int, list[dict[str, int]]]:
    [game, instructions] = l.split(":")
    colors = []

    sub = [s for s in instructions.split(";")]
    for sec in sub:
        c = {}
        for subc in sec.split(","):
            subc = subc.strip()
            [n, s] = subc.split(" ")
            c[s] = int(n)
        colors.append(c)

    return (int(game[5:]), colors)


def filter_p1(x: tuple[int, list[dict[str, int]]]) -> bool:
    game = max_color_bag(x[1])
    r = "red" not in game or game["red"] <= 12
    g = "green" not in game or game["green"] <= 13
    b = "blue" not in game or game["blue"] <= 14
    return r and g and b


def max_color_bag(games: list[dict[str, int]]) -> dict[str, int]:
    game = {}
    for g in games:
        for [c, n] in g.items():
            if c not in game or game[c] < n:
                game[c] = n
    return game


def bag_power(games: list[dict[str, int]]) -> int:
    return reduce(mul, max_color_bag(games).values())


assert (
    bag_power(parse_game("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")[1])
    == 48
)


with sys.stdin as f:
    lines = f.readlines()
    s1 = sum([v[0] for v in filter(filter_p1, [parse_game(l) for l in lines])])
    s2 = sum([bag_power(v[1]) for v in [parse_game(l) for l in lines]])
    print(s1, s2)
