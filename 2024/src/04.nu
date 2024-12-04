#!/usr/bin/env -S nu --stdin

def main [] {
    let input = $in | str trim | lines | split chars
    # turn the list<list<u8>> into N list<list<u8>>, each with a single direction
    let multi = [
        $input,
        ($input | each { reverse }),
        ($input | trans),
        ($input | trans | each { reverse }),
        ($input | diagonals),
        ($input | diagonals | each { reverse } ),
        ($input | reverse | diagonals),
        ($input | reverse | diagonals | each { reverse }) 
    ]
    let part_one = $multi | reduce -f 0 {|list, acc| $acc + ($list | reduce -f 0 {|list, acc| $acc + ($list | count [X M A S])}) }
    let part_two = $input | 2d_sliding_window 3 {|w|
        match $w {
            # match MAS in the shape of an X
            [
                ["M",_,"M"],
                [_,"A",_],
                ["S",_,"S"]
            ] => 1,
            [
                ["S",_,"S"],
                [_,"A",_],
                ["M",_,"M"]
            ] => 1,
            [
                ["M",_,"S"],
                [_,"A",_],
                ["M",_,"S"]
            ] => 1,
            [
                ["S",_,"M"],
                [_,"A",_],
                ["S",_,"M"]
            ] => 1,
            _ => 0
        }    } | math sum;
    {part_one: $part_one, part_two: $part_two}
}

def trans [] <list<list<any>> -> <list<list<any>> {
    let input = $in
    let height = ($input | length)
    let width = ($input | first | length)
    mut output = []
    for $i in 0..$width {
        mut nr = []
        for $j in 0..$height {
            let val = ($input | get -i $j | get -i $i)
            $nr = $nr | append $val
        }
        $output = $output | append [$nr]
    }
    $output
}

# diagonals returns all diagonals of the input list
def diagonals [] list<list<any>> -> list<list<any>> {
    let input = $in
    mut output = [];
    let height = ($input | length)
    let width = ($input | first | length)
    # Start from negative offset to get all diagonals
    for $i in (($height + 1) * -1)..($width) {
        mut nr = [];
        for $j in 0..$height {
            let row = $j
            let col = $i + $j
            if $col >= 0 and $col < $width {
                let val = ($input | get -i $row | get -i $col)
                $nr = $nr | append $val
            }
        }
        if ($nr | length) > 0 {
            $output = $output | append [$nr]
        }
    }
    $output
}

# count counts the occurence of a chunk of a list
# if we want fast we can implement Boyer–Moore or similar
def count [filter: list<any>] list<list<any> -> int { $in | window ($filter | length) | where $it == $filter | length }

def 2d_sliding_window [n: int, closure: closure] list<list<any>> -> list<any> {
    let input = $in
    mut window_results = [];

    for arr in ($input | window $n) {
        for sub in ($arr | trans | window $n) {
            if ($sub | length) < $n or ($sub | any {($in | length) < $n}) {
                break
            }
            $window_results = $window_results | append (do $closure $sub)
        }
    }
    
    $window_results
}

# Different part_one solution that I like more but is even slower (up to 3 minutes total runtime???)
# def part_one [grid: list<list<string>>] -> int {
#     const word = "XMAS" | split chars

#     def isXMAS [
#         grid: list<list<string>>
#         x: int,
#         y: int,
#         dir: list<int>, # directions to move towards
#         matched: int,
#     ] -> bool {
#         $matched == 4 or (
#             $x >= 0 and $x < ($grid | length) and
#             $y >= 0 and $y < ($grid | get $x | length) and
#             (($grid | get $x | get $y) == ($word | get $matched)) and
#             (isXMAS $grid ($x + $dir.0) ($y + $dir.1) $dir ($matched + 1))
#         )
#     }

#     # traverse the grid and for each "X", look whether it's XMAS
#     $grid | enumerate | each {|row|
#         $row.item | enumerate | each {|col|
#             if ($col.item != "X") {return 0}
#             [[-1, -1] [0, -1] [1, -1] [1, 0] [1, 1] [0, 1] [-1, 1] [-1, 0]] | reduce -f 0 {|dir, acc|
#                 $acc + (if (isXMAS $grid $row.index $col.index $dir 0) {1} else {0})
#             }
#         } | math sum
#     } | math sum
# }

