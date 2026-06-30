set start [clock milliseconds]; set s ""; for {set i 0} {$i < 50000} {incr i} { append s "a" }
set end [clock milliseconds]; puts "Len: [string length $s]"; puts "Time: [expr {$end - $start}]ms"