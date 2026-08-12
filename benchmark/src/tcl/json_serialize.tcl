set seed 12345
proc ri {m} { global seed; set seed [expr {($seed * 16807) % 2147483647}]; return [expr {$seed % $m}] }

proc gen {depth} {
    if {$depth == 7} { return [ri 100000] }
    set a [expr {[ri 4] == 0 ? [ri 100000] : [gen [expr {$depth + 1}]]}]
    set b [expr {[ri 4] == 0 ? [ri 100000] : [gen [expr {$depth + 1}]]}]
    set c [expr {[ri 4] == 0 ? [ri 100000] : [gen [expr {$depth + 1}]]}]
    set s "x[ri 1000]"
    return [list $a $b $c $s]
}

proc count_nodes {node} {
    if {[llength $node] != 4} { return 0 }
    lassign $node a b c s
    return [expr {1 + [count_nodes $a] + [count_nodes $b] + [count_nodes $c]}]
}

proc serialize {node} {
    if {[llength $node] != 4} { return $node }
    lassign $node a b c s
    set parts [list]
    lappend parts "\{\"a\":"
    lappend parts [serialize $a]
    lappend parts ",\"b\":"
    lappend parts [serialize $b]
    lappend parts ",\"c\":"
    lappend parts [serialize $c]
    lappend parts ",\"s\":\""
    lappend parts $s
    lappend parts "\"\}"
    return [join $parts ""]
}

set tree [gen 0]
set nc [count_nodes $tree]
set start [clock milliseconds]
set total 0
for {set i 0} {$i < 50} {incr i} { incr total [string length [serialize $tree]] }
set end [clock milliseconds]
puts "Result: [expr {$total % 1000003}]_${nc}"
puts "Time: [expr {$end - $start}]ms"
