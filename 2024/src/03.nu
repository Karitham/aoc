#!/usr/bin/env -S nu --stdin

def main [] {
    let input = $in | str trim
    let part_one = $input | parse --regex 'mul\((?<a>\d+),(?<b>\d+)\)' | reduce -f 0 {|v, acc| $acc + (($v.a | into int) * ($v.b | into int))}
    let part_two = $input 
        | str replace -m -a "don't()" "END" 
        | str replace -m -a "do()" "START"
        | str replace -m -a --regex `END[^START]*START` '' # I think nu's regex engine doesn't support `()` in inverse-match-groups
        | parse --regex 'mul\((?<a>\d+),(?<b>\d+)\)' 
        | reduce -f 0 {|v, acc| $acc + (($v.a | into int) * ($v.b | into int))}
    {part_one: $part_one, part_two: $part_two}
}