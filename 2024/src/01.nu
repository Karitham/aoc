#!/usr/bin/env -S nu --stdin

def main [] {
    let inputs = $in | str trim | lines | each { split words | each { $in | into int } } | each {|e| { left: $e.0, right: $e.1 } }
    let sorted = {left: ($inputs.left | sort), right: ($inputs.right | sort) }
    let part_one = $sorted | get left | zip $sorted.right | each {|e| $e.0 - $e.1 | math abs } | math sum
    let part_two = $inputs.left | each {|l| ($inputs.right | where $l == $it | length) * $l} | math sum
    {part_one: $part_one, part_two: $part_two}
}