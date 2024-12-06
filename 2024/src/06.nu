#!/usr/bin/env -S nu --stdin --config ./src/config.nu

def main [] {
    let input = $in | str trim | lines | split chars
    {part_one: (part_one $input)}
}

def part_one [grid: list<list<string>>] {
    # find coordinate of cursor
    let starting_pos = $grid | enumerate | reduce -f null {|row, acc| 
        let rp = ($row.item | enumerate | reduce -f null {|col, acc| if $col.item == "^" { $col.index } else $acc});
        if ($rp != null) { {x: $rp, y: $row.index} } else $acc
    }
    let starting_dir = {x: 0, y: -1} # facing up

    def turn_right []: record<x: int, y: int> -> record<x: int, y: int> { {x: ($in.y * -1), y: $in.x} }

    def walk [
        grid: list<list<string>>,
        pos: record<x: int, y: int>,
        dir: record<x: int, y: int>,
    ] {
        let new_pos = {x: ($pos.x + $dir.x), y: ($pos.y + $dir.y)}
        let updated_grid = ($grid | update $pos.y { |row| $row | update $pos.x { "X" } })
        # print ($updated_grid | each { str join "" } | str join "\n") ""

        if $new_pos.x < 0 or $new_pos.y < 0 or $new_pos.x >= ($grid | get 0 | length) or $new_pos.y >= ($grid | length) {
            $updated_grid
        } else if ($grid | get $new_pos.y | get $new_pos.x) == "#" {
            walk $updated_grid $pos ($dir | turn_right)
        } else walk $updated_grid $new_pos $dir
    }
    
    walk $grid $starting_pos $starting_dir | reduce -f 0 {|col, acc| 
        $acc + ($col | reduce -f 0 {|row, acc|
            $acc + if ($row == "X") { 1 } else 0
        })
    }
}
