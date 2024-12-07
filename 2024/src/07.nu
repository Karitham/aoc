#!/usr/bin/env -S nu --stdin --config ./src/config.nu

def main [] {
    let input = $in | str trim | lines | split column ':' target numbers | update numbers {split words | each {into int}} | update target {into int}
    {part_one: (part_one $input), part_two: (part_two $input)}
}

def part_one [input] {
    $input | filter {|row|
        dfs_apply [
            {|x, y| $x * $y},
            {|x, y| $x + $y},
        ] $row.numbers $row.target
    } | reduce -f 0 {|row, acc| $acc + $row.target}
}

def part_two [input] {
    $input | filter {|row|
        dfs_apply [
            {|x, y| $x * $y},
            {|x, y| $x + $y},
            {|x, y| $"($x)($y)" | into int},
        ] $row.numbers $row.target
    } | reduce -f 0 {|row, acc| $acc + $row.target}
}

def dfs_apply [
    operators: list<closure>,
    values: list,
    target: int,
] -> bool {
    for o in $operators {
        if ($values | length) < 2 {
            return ($target == ($values | get 0))
        }

        let result = (do $o ($values | get 0) ($values | get 1))
        let new_values = $values | range 2.. | prepend $result
        let r2 = dfs_apply $operators $new_values $target
        if $r2 {
            return true
        }
    }

    return false
}