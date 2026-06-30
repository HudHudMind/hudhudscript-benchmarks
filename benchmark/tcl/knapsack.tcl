proc knapsack {W wt val n} { array set K {}; for {set i 0} {$i <= $n} {incr i} { for {set w 0} {$w <= $W} {incr w} {
        if {$i == 0 || $w == 0} { set K($i,$w) 0 } elseif {[lindex $wt [expr {$i-1}]] <= $w} {
        set a [expr {[lindex $val [expr {$i-1}]] + $K([expr {$i-1}],[expr {$w - [lindex $wt [expr {$i-1}]]}])}]; set b $K([expr {$i-1}],$w)
        if {$a > $b} { set K($i,$w) $a } else { set K($i,$w) $b } } else { set K($i,$w) $K([expr {$i-1}],$w) } } }; return $K($n,$W) }
set start [clock milliseconds]; set wt {}; set val {}; for {set i 1} {$i <= 50} {incr i} { lappend wt $i; lappend val [expr {$i*2}] }
set res 0; for {set i 0} {$i < 10} {incr i} { set res [knapsack 100 $wt $val 50] }
set end [clock milliseconds]; puts "Max Value: $res"; puts "Time: [expr {$end - $start}]ms"