set start [clock milliseconds]; set s 0; for {set i 0} {$i < 10000} {incr i} { set s [expr {$s + (2 ** 1000)}] }
set end [clock milliseconds]; puts "Sum: $s"; puts "Time: [expr {$end - $start}]ms"