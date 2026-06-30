proc fib {n} { if {$n <= 1} { return $n }; set a 0; set b 1; for {set i 2} {$i <= $n} {incr i} { set t [expr {$a + $b}]; set a $b; set b $t }; return $b }
set start [clock milliseconds]; set s 0; for {set i 0} {$i < 10000} {incr i} { set s [expr {$s + [fib 1000]}] }
set end [clock milliseconds]; puts "Sum: $s"; puts "Time: [expr {$end - $start}]ms"