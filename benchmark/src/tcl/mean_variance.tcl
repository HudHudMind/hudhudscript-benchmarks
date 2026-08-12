set n 1000000; set a {}; for {set i 1} {$i <= $n} {incr i} { lappend a $i }
set start [clock milliseconds]
set m 0; for {set i 0} {$i < $n} {incr i} { set m [expr {$m + [lindex $a $i]}] }
set m [expr {$m / double($n)}]
set v 0; for {set i 0} {$i < $n} {incr i} { set d [expr {[lindex $a $i] - $m}]; set v [expr {$v + $d*$d}] }
set v [expr {$v / double($n)}]
set end [clock milliseconds]
puts "Result: [format %.1f $m]/[format %.1f $v]"
puts "Time: [expr {$end-$start}]ms"