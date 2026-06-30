proc isPrime {n} { if {$n < 2} { return 0 }; if {$n == 2} { return 1 }; if {$n % 2 == 0} { return 0 }
    set i 3; while {$i * $i <= $n} { if {$n % $i == 0} { return 0 }; incr i 2 }; return 1 }
set start [clock milliseconds]; set c 0; for {set i 1} {$i <= 100000} {incr i} { if {[isPrime $i]} { incr c } }
set end [clock milliseconds]; puts "Primes: $c"; puts "Time: [expr {$end - $start}]ms"