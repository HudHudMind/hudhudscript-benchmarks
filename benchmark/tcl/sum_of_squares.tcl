set start [clock milliseconds]; set s 0; for {set i 1} {$i <= 1000000} {incr i} { set s [expr {$s + $i * $i}] }
set end [clock milliseconds]; puts "Sum: $s"; puts "Time: [expr {$end - $start}]ms"