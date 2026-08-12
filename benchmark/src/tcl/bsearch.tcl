set N 100000; set Q 10000
set arr {}; for {set i 0} {$i < $N} {incr i} {lappend arr [expr {2 * $i}]}
set found 0; set start [clock milliseconds]
for {set j 0} {$j < $Q} {incr j} {set target [expr {20 * $j}]; set left 0; set right [expr {$N - 1}]
 while {$left <= $right} {set mid [expr {($left + $right) / 2}]
  if {[lindex $arr $mid] == $target} {incr found; break
  } elseif {[lindex $arr $mid] < $target} {set left [expr {$mid + 1}]
  } else {set right [expr {$mid - 1}]}}}
set end [clock milliseconds]; puts "Result: $found"; puts "Time: [expr {$end - $start}]ms"