set n 100000; set total 0; set start [clock milliseconds]
for {set i 1} {$i <= $n} {incr i} {set x $i
 while {$x > 0} {incr total [expr {$x % 2}]; set x [expr {$x / 2}]}}
set end [clock milliseconds]; puts "Result: $total"; puts "Time: [expr {$end - $start}]ms"