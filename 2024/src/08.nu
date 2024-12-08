#!/usr/bin/env -S nu --stdin --config ./src/config.nu

def main [] {
    let input = $in | str trim | lines | split chars
    {part_one: (part_one $input), part_two: (part_two $input)}
}

def part_one [input] {
    let bounds = [($input | length), ($input.0 | length)]
    let adj_list = $input | enumerate | each {|col|
        $col.item | enumerate | filter {|row| $row.item != "."} | each {|row| [$row.item, $col.index, $row.index]}
    } | filter {is-not-empty} | flatten | reduce -f {} {|item, acc| $acc | upsert $item.0 {append [($item | skip 1)]}}

    $adj_list | values | each {pairs {|a, b|
        let dist = [($b.0 - $a.0), ($b.1 - $a.1)]
        [[($a.0 - $dist.0), ($a.1 - $dist.1)], [($b.0 + $dist.0), ($b.1 + $dist.1)]]
    } | flatten} | flatten | filter {|l| in bounds $bounds} | uniq | length
}

def part_two [input] {
    let bounds = [($input | length), ($input.0 | length)]
    let adj_list = $input | enumerate | each {|col|
        $col.item | enumerate | filter {|row| $row.item != "."} | each {|row| [$row.item, $col.index, $row.index]}
    } | filter {is-not-empty} | flatten | reduce -f {} {|item, acc| $acc | upsert $item.0 {append [($item | skip 1)]}}

    $adj_list | values | each {pairs {|a, b|
        let dist = [($b.0 - $a.0), ($b.1 - $a.1)]
        (generate_points $a $dist $bounds)
            | append (generate_points $a [($dist.0 * -1), ($dist.1 * -1)] $bounds)
            | append (generate_points $b $dist $bounds)
            | append (generate_points $b [($dist.0 * -1), ($dist.1 * -1)] $bounds)
    } | flatten} | flatten | filter {|l| in bounds $bounds} | uniq | length
}

def "in bounds" [bounds] bool {$in.0 >= 0 and $in.1 >= 0 and $in.0 < $bounds.0 and $in.1 < $bounds.1}
def "print grid" [grid, anti] {$anti | reduce -f $grid {|p, acc| $acc | update $p.0 {update $p.1 '#'}} | each { str join '' } | str join "\n"}
def pairs [f: closure] list -> list {
    let values = $in
    let n = ($values | length)
    0..$n | par-each {|i| ($i + 1)..$n | each {|j|
        if $j >= ($values | length) { return [] }
        do $f ($values | get $i) ($values | get $j)
    }} | flatten
}
def "generate_points" [start, dist, bounds] {
    mut points = [$start]
    while (($points | last) | in bounds $bounds) {
        let p = ($points | last)
        $points = $points | append [[($p.0 + $dist.0), ($p.1 + $dist.1)]]
    }
    $points
}
