set N 100000; set seed 12345; set acc 0; set start [clock milliseconds]
set head ""; for {set i 0} {$i < $N} {incr i} {set seed [expr {($seed*16807)%2147483647}]; set head [list value [expr {$seed%10000}] next $head]}
set prev ""; set cur $head; for {set i 0} {$i < $N} {incr i} {set nxt [lindex $cur 3]; lset cur 3 $prev; set prev $cur; set cur $nxt}
set pos 0; set walk $prev; for {set i 0} {$i < $N} {incr i} {set acc [expr {($acc + [lindex $walk 1] * $pos) % 1000003}]; incr pos; set walk [lindex $walk 3]}
set end [clock milliseconds]; puts "Result: $acc"; puts "Time: [expr {$end-$start}]ms"
