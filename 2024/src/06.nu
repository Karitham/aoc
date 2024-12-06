#!/usr/bin/env -S nu --stdin --config ./src/config.nu

def main [] {
    let input = $in | str trim | lines | split chars
    {
        part_one: (part_one $input),
        part_two: (part_two $input)
    }
}

const DIR_UP = 1
const DIR_RIGHT =  2
const DIR_DOWN = 4
const DIR_LEFT = 8
def turn_right [] -> int {match $in {
    1 => $DIR_RIGHT
    2 => $DIR_DOWN
    4 => $DIR_LEFT
    8 => $DIR_UP
}}
def advance [pos: record<x: int, y: int>, dir: int] -> record<x: int, y: int> {match $dir {
    1 => {x: $pos.x, y: ($pos.y - 1)}
    2 => {x: ($pos.x + 1), y: $pos.y}
    4 => {x: $pos.x, y: ($pos.y + 1)}
    8 => {x: ($pos.x - 1), y: $pos.y}
}}
def in_bounds [pos: record<x: int, y: int>, grid] {$pos.x >= 0 and $pos.y >= 0 and $pos.x < ($grid | get 0 | length) and $pos.y < ($grid | length)}
def "print grid" [grid: list<list<string>>] {print ($grid | each { str join "" } | str join "\n") ""}
def "hash record" [x: int, y: int, z: int] -> string {([$x, $y, $z] | str join ',' | hash md5)}
def "to str" [] int -> int {match $in {
    1 => "^"
    2 => "v"
    4 => "<"
    8 => ">"
}}

def part_one [grid: list<list<string>>] {
    mut current_pos = $grid | enumerate | where {|row| "^" in $row.item} | first | {
        x: ($in.item | enumerate | where {|col| $col.item == "^"} | first | get index),
        y: $in.index
    }
    mut current_dir = $DIR_UP # facing up
    mut visited = [$current_pos]
    loop {
        let new_pos = advance $current_pos $current_dir
        if not (in_bounds $new_pos $grid) {
            break
        } else if ($grid | get $new_pos.y | get $new_pos.x) == "#" {
            $current_dir = ($current_dir | turn_right)
            continue
        }
        $current_pos = $new_pos
        $visited = ($visited | append $current_pos)
    }
    
    $visited | uniq | length
}


def part_two [grid: list<list<string>>] {
    def check_intersection [visited: record, pos: record<x: int, y: int>, dir: int] -> bool {
        mut current_pos = $pos
        mut current_dir = $dir
        mut path = $visited
        loop {
            let new_pos = advance $current_pos $current_dir
            if ((hash record $new_pos.x $new_pos.y $current_dir) in $path) {
                return true
            }
            if not (in_bounds $new_pos $grid) {
                return false
            } else if ($grid | get $new_pos.y | get $new_pos.x) == "#" {
                $current_dir = ($current_dir | turn_right)
                continue
            }
            $path = ($path | insert (hash record $new_pos.x $new_pos.y $current_dir) ())
            $current_pos = $new_pos
        }
    }

    mut current_pos = $grid | enumerate | where {|row| "^" in $row.item} | first | {
        x: ($in.item | enumerate | where {|col| $col.item == "^"} | first | get index),
        y: $in.index
    }
    mut current_dir = $DIR_UP
    mut visited: record<string, any> = {}
    mut crossed = 0

    loop {
        let new_pos = advance $current_pos $current_dir
        $visited = ($visited | insert (hash record $new_pos.x $new_pos.y $current_dir) ())
        if not (in_bounds $new_pos $grid) {
            break
        } else if ($grid | get $new_pos.y | get $new_pos.x) == "#" {
            $current_dir = ($current_dir | turn_right)
            continue
        }
        
        print $"Checking ([$current_pos.x,$current_pos.y]) ($current_dir | to str)"
        if (check_intersection $visited $current_pos ($current_dir | turn_right)) {
            $crossed += 1
            print $"Crossed ($crossed) at ([$current_pos.x,$current_pos.y]) ($current_dir | to str)"
        }
        $current_pos = $new_pos
    }

    $crossed
}