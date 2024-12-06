#!/usr/bin/env -S nu --stdin --config ./src/config.nu

def main [] {
    let input = $in | str trim | lines | split chars
    {part_one: (part_one $input)}
}

# this used to be a cool recursive solution and now it's just this mutable mess
def part_one [grid: list<list<string>>] {
    mut current_grid = $grid
    mut current_pos = $grid | enumerate | reduce -f null {|row, acc|
        let rp = ($row.item | enumerate | reduce -f null {|col, acc| if $col.item == "^" { $col.index } else $acc});
        if ($rp != null) { {x: $rp, y: $row.index} } else $acc
    }
    mut current_dir = {x: 0, y: -1} # facing up
    loop {
        let row = ($current_grid | get $current_pos.y)
        let new_row = ($row | update $current_pos.x "X")
        $current_grid = ($current_grid | update $current_pos.y  $new_row )
        print ("\u{001b}[H\u{001b}[2J" ++ $current_grid | each { str join "" } | str join "\n"); sleep 12ms

        let new_pos: record<x: int, y: int> = {x: ($current_pos.x + $current_dir.x), y: ($current_pos.y + $current_dir.y)}
        if $new_pos.x < 0 or $new_pos.y < 0 or $new_pos.x >= ($grid | get 0 | length) or $new_pos.y >= ($grid | length) {
            break
        } else if ($grid | get $new_pos.y | get $new_pos.x) == "#" {
            $current_dir = ($current_dir | turn_right)
            continue
        }
        $current_pos = $new_pos
    }
    
    
    $current_grid | reduce -f 0 {|col, acc| 
        $acc + ($col | reduce -f 0 {|row, acc|
            $acc + if ($row == "X") { 1 } else 0
        })
    }
}

def turn_right []: record<x: int, y: int> -> record<x: int, y: int> { {x: ($in.y * -1), y: $in.x} }