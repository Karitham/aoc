import sys
import re


def digits1(l: str) -> int:
    return l2n(l.strip("abcdefghijklmnopqrstuvwxyz"))


dmap = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}
dl = list(dmap.keys())
dl.extend(dmap.values())
pattern = re.compile("|".join(dl))
l2n = lambda l: (ord(l[0]) - 48) * 10 + (ord(l[-1]) - 48)


def digits2(l: str) -> int:
    matches = []
    for i in range(len(l)):
        x = pattern.search(l, i)
        if x is not None:
            matches.append(dmap[x.group(0)] if x.group(0) in dmap else x.group(0))
    return l2n(matches)


with sys.stdin as f:
    lines = f.readlines()
    s1 = sum([digits1(l.strip()) for l in lines])
    s2 = sum([digits2(l.strip()) for l in lines])
    print(s1, s2)

assert (
    sum(
        [
            digits1(l)
            for l in """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""".splitlines()
        ]
    )
    == 142
)

assert (
    sum(
        [
            digits2(l)
            for l in """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".splitlines()
        ]
    )
    == 281
)
