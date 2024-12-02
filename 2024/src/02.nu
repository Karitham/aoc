#!/usr/bin/env -S nu --stdin

def main [] {
    let input = $in | str trim | lines | each {split words | each {into int}}
    let is_safe = {|list| ($list | all {|v| ($v | math abs) <= 3}) and (($list | all {|v| $v > 0}) or ($list | all {|v| $v < 0}))}
    let into_difflist = {|list| $list | window 2 | each {$in.0 - $in.1}}
    let part_one = $input | each $into_difflist | filter $is_safe | length
    let part_two = $input | filter {|values| $values | enumerate | any {|i| do $is_safe (do $into_difflist ($values | reject $i.index))} } | length
    {part_one: $part_one, part_two: $part_two}
}