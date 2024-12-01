#!/usr/bin/env -S nu --stdin

def main [] {
    let inputs = $in | str trim | lines | each { split words | each { $in | into int } } | each {|e| { left: $e.0, right: $e.1 } }
    let part_one = ($inputs.left | sort) | zip ($inputs.right | sort) | reduce -f 0 {|e, acc| $acc + ($e.0 - $e.1 | math abs) }
    let part_two = $inputs.left | reduce -f 0 {|l, acc| ($inputs.right | where $l == $it | length) * $l + $acc}
    {part_one: $part_one, part_two: $part_two}
}