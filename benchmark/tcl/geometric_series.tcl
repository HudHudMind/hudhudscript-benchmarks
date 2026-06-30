set start [clock milliseconds]; set s 0.0; set r 0.999; set term 1.0
for {set i 0} {$i < 1000000} {incr i} { set s [expr {$s + $term}]; set term [expr {$term * $r}] }
set end [clock milliseconds]; puts "Sum: $s"; puts "Time: [expr {$end - $start}]ms"