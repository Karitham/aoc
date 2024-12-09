#!/usr/bin/env -S nu --stdin

def main [] {
    let inputs = $in | str trim | split chars | each {into int}
    {
        # part_one: (defrag $inputs),
        # part_two: (defrag_blocks $inputs)
    }

    (defrag_blocks $inputs)
}
def repeat [n: int] -> list {let v = $in; 0..$n | each {$v} | take $n}
def defrag [inputs: list<int>] {
    let o = $inputs | chunks 2 | enumerate | reduce -f [] {|x, acc|
        $acc ++ ($"($x.index)" | repeat $x.item.0) ++ (if ($x.item | get -i 1) != null {'.' | repeat $x.item.1} else [])
    } | flatten
    let digits = ($o | enumerate | where item =~ '\d' | reverse | get item)
    let dot_positions = ($o | enumerate | where item == '.' | get index)
    
    let result = 0..(($digits | length) - 1) | par-each -k {|i|
        if ($dot_positions | where {|pos| $pos == $i} | length) > 0 {
            $digits | get (($dot_positions | where {|pos| $pos <= $i} | length) - 1)
        } else {$o | get $i}
    }

    $result | enumerate | reduce -f 0 {|elem, acc|$acc + ($elem.index * ($elem.item | into int))}
}

def defrag_blocks [inputs: list<int>] {
    let blocks = {
        digs: ($inputs | enumerate | window 1 -s 2 | flatten | rename pos size),
        dots: ($inputs | enumerate | skip 1 | window 1 -s 2 | flatten | rename pos size)
    }

    let digits = $blocks.digs
    mut holes = $blocks.dots
    mut displaced = []
    
    # Process digits from right to left
    for i in (($digits | length) - 1)..0 {
        let d = $digits | get $i
        # Try to find the rightmost suitable hole
        let suitable_holes = ($holes | enumerate | where {|h| $h.item.size >= $d.size})
        if ($suitable_holes | length) > 0 {
            let h = $suitable_holes | get -i 0
            $displaced = ($displaced | append {
                orig_pos: $d.pos,
                target_hole: ($h.index),
                size: $d.size,
                value: ($d.pos / 2 | into int)
            })
            # Update hole size after placement
            $holes = ($holes | update $h.index {|h|
                {size: ($h.size - $d.size)}
            })
        }
    }
    
    $inputs | rebuild_list $displaced | enumerate | where ($it.item | describe) == 'int' | reduce -f 0 {|elem, acc| $acc + ($elem.index * $elem.item)}
}

def rebuild_list [displacements: list] {
    let inputs = $in
    let initial = ($inputs 
        | chunks 2 
        | enumerate 
        | reduce -f [] {|chunk, acc|
            $acc ++ ($chunk.index | repeat $chunk.item.0) ++ (if ($chunk.item | get -i 1) != null {'.' | repeat $chunk.item.1} else {})
        }
        | flatten
    )
    let remove_displaced = $displacements | reduce -f $initial {|d, acc|
        $acc | enumerate | filter {$in.item == $d.value} | reduce -f $acc {|v, acc| $acc | update $v.index '.' }
    }

    mut hole_pos = []
    mut offset = 0
    for chunk in ($inputs | chunks 2 | enumerate) {
        $offset += $chunk.item.0
        if ($chunk.item | get -i 1) != null {
            $hole_pos = ($hole_pos | append {pos: $offset, size: $chunk.item.1})
            $offset += $chunk.item.1
        }
    }
    
    mut insert_displaced = $remove_displaced
    mut holes = $hole_pos
    for d in $displacements {
        let hole = $holes | get $d.target_hole
        for v in 0..($d.size - 1) {
            $insert_displaced = ($insert_displaced | update ($v + $hole.pos) $d.value)
        }

        $holes = $holes | update $d.target_hole {size: ($hole.size - $d.size), pos: ($hole.pos + $d.size)}
    }

    $insert_displaced
}