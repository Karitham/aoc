# dfs_topological_sort ([
#     # Layer 1 -> 2
#     [1 4]
#     [1 5]
#     [2 4]
#     [2 6]
#     [3 5]
#     # Layer 2 -> 3
#     [4 7]
#     [5 8]
#     [6 8]
# ] | reduce -f {} {|v, dag| $dag | upsert $"($v.0)" {append $"($v.1)"} })

# dfs_topological_sort returns a topological sort of the provided graph
export def dfs_topological_sort [graph: record<any, list<any>>] {
    let nodes = ($graph | columns)
    let out = ($nodes | reduce -f [[] [] [] true] {|node, acc|
        if $acc.3 {
            visit $node $graph $acc.0 $acc.1 $acc.2
        } else $acc
    })
    
    if $out.3 {
        $out.2
    } else null  # Return null if cycle detected
}

def visit [node: string, graph: record, visited: list, temp: list, order: list] {
    # Return early with success if already visited
    if ($visited | any {|n| $n == $node}) {
        return [$visited $temp $order true]
    }

    # Return early with failure if in temp (cycle)
    if ($temp | any {|n| $n == $node}) {
        return [$visited $temp $order false]
    }

    let new_temp = ($temp | append $node)
    let neighbors = ($graph | get -i $node | default [])
    
    # Process all neighbors with current state
    let result = ($neighbors | reduce -f [$visited $new_temp $order true] {|neighbor, acc|
        if $acc.3 {
            visit $neighbor $graph $acc.0 $acc.1 $acc.2
        } else $acc
    })
    
    # Only if all neighbors processed successfully, add this node
    if $result.3 {
        let cleaned_temp = ($result.1 | where $it != $node)
        let new_visited = ($result.0 | append $node)
        let new_order = ($result.2 | append $node)
        [$new_visited $cleaned_temp $new_order true]
    } else $result
}

