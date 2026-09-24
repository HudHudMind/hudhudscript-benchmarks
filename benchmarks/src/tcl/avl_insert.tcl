set n 100000
set seed 12345
proc ri {m} { global seed; set seed [expr {($seed * 16807) % 2147483647}]; return [expr {$seed % $m}] }
set sz [expr {$n + 10}]
set key {}; set left {}; set right {}; set height {}
for {set i 0} {$i < $sz} {incr i} { lappend key 0; lappend left 0; lappend right 0; lappend height 0 }
set nodes 0

proc new_node {k} {
    global nodes key left right height
    incr nodes
    lset key $nodes $k
    lset left $nodes 0
    lset right $nodes 0
    lset height $nodes 1
    return $nodes
}
proc get_h {nd} { global height; if {$nd == 0} { return 0 }; return [lindex $height $nd] }
proc upd_h {nd} {
    global left right height
    set hl [get_h [lindex $left $nd]]
    set hr [get_h [lindex $right $nd]]
    if {$hl > $hr} { lset height $nd [expr {$hl + 1}] } else { lset height $nd [expr {$hr + 1}] }
}
proc bal {nd} { global left right; return [expr {[get_h [lindex $left $nd]] - [get_h [lindex $right $nd]]}] }
proc rot_r {y} {
    global left right
    set x [lindex $left $y]; set T [lindex $right $x]
    lset right $x $y; lset left $y $T
    upd_h $y; upd_h $x; return $x
}
proc rot_l {x} {
    global left right
    set y [lindex $right $x]; set T [lindex $left $y]
    lset left $y $x; lset right $x $T
    upd_h $x; upd_h $y; return $y
}
proc insert {nd k} {
    global key left right
    if {$nd == 0} { return [new_node $k] }
    if {$k < [lindex $key $nd]} {
        lset left $nd [insert [lindex $left $nd] $k]
    } elseif {$k > [lindex $key $nd]} {
        lset right $nd [insert [lindex $right $nd] $k]
    } else { return $nd }
    upd_h $nd; set b [bal $nd]
    if {$b > 1 && $k < [lindex $key [lindex $left $nd]]} { return [rot_r $nd] }
    if {$b < -1 && $k > [lindex $key [lindex $right $nd]]} { return [rot_l $nd] }
    if {$b > 1 && $k > [lindex $key [lindex $left $nd]]} {
        lset left $nd [rot_l [lindex $left $nd]]; return [rot_r $nd]
    }
    if {$b < -1 && $k < [lindex $key [lindex $right $nd]]} {
        lset right $nd [rot_r [lindex $right $nd]]; return [rot_l $nd]
    }
    return $nd
}

set root 0
for {set i 0} {$i < $n} {incr i} { set root [insert $root [ri 1000000]] }

set start [clock milliseconds]
set c 0; set idx 0; set stack {}; set cur $root
while {[llength $stack] > 0 || $cur != 0} {
    while {$cur != 0} { lappend stack $cur; set cur [lindex $left $cur] }
    set cur [lindex $stack end]; set stack [lrange $stack 0 end-1]
    set c [expr {($c + [lindex $key $cur] * ($idx % 13)) % 1000003}]
    incr idx; set cur [lindex $right $cur]
}
set end [clock milliseconds]
puts "Result: [lindex $height $root]_${c}"
puts "Time: [expr {$end - $start}]ms"
