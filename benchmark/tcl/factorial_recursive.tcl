proc fact {n} { if {$n <= 1} { return 1 } else { return [expr {$n * [fact [expr {$n - 1}]]}] } }
set start [clock milliseconds]; set res 0; for {set i 0} {$i < 10000} {incr i} { set res [fact 150] }
set end [clock milliseconds]; puts "Result: $res"; puts "Time: [expr {$end - $start}]ms"