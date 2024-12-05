#!/usr/bin/env -S nu --stdin
use std assert

def main [] {
    let input = $in | str trim
    let parsed = $input | split column "\n\n" sort list | get 0 | update sort {lines | split column '|' l r} | update list {lines | split words}
    let graph = $parsed.sort | reduce -f {} {|v, g| $g | upsert $v.l {append $v.r}}

    # look at each number one after another in each list, if their *value* is lower than the previous one, we have a valid sort. Then just take the median of the list
    # because it's not a dag, we don't actually have a fixed order, it's just that i+1 must be on the right of i.
    # pick the number in the middle. DONT USE MEDIAN IT WILL SORT THEM
    let part_one = $parsed.list | reduce -f 0 {|sub, acc|
        if (is_sorted $graph $sub) {  $acc + ($sub | each {into int} | get (($sub | length) / 2 | into int)) } else $acc
    }

    let part_two = $parsed.list | reduce -f 0 {|sub, acc|
        if (not (is_sorted $graph $sub)) { $acc + ($sub | sort with-order $graph | each {into int} | get (($sub | length) / 2 | into int)) } else $acc
    }

    {part_one: $part_one, part_two: $part_two}
}

def is_sorted [graph: record, l: list] -> bool { $l | window 2 | each {|v| $v.1 in ($graph | get $v.0)} | all {$in} }

def "sort with-order" [graph: record]: list -> list {
    if ($in | length) <= 1 { return $in }
    let pivot = ($in | get 0)
    let rest = ($in | range 1..)
    
    let less = ($rest | where {|x| $x in ($graph | get $pivot)} | sort with-order $graph)
    let greater = ($rest | where {|x| not ($x in ($graph | get $pivot))} | sort with-order $graph)
    
    ($less | append $pivot | append $greater)
}