proc countBits {n} { set count 0; while {$n > 0} { set count [expr {$count + ($n & 1)}]; set n [expr {$n >> 1}] }; return $count }
set start [clock milliseconds]; set total 0; for {set i 1} {$i <= 100000} {incr i} { set total [expr {$total + [countBits $i]}] }
set end [clock milliseconds]; puts "Total: $total"; puts "Time: [expr {$end - $start}]ms"