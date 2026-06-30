proc sieve {n} { array set prime {}; for {set i 0} {$i <= $n} {incr i} { set prime($i) 1 }; set p 2
    while {$p * $p <= $n} { if {$prime($p)} { set i [expr {$p * $p}]; while {$i <= $n} { set prime($i) 0; set i [expr {$i + $p}] } }; incr p }
    set c 0; for {set i 2} {$i <= $n} {incr i} { if {$prime($i)} { incr c } }; return $c }
set start [clock milliseconds]; set c 0; for {set j 0} {$j < 100} {incr j} { set c [sieve 10000] }
set end [clock milliseconds]; puts "Primes: $c"; puts "Time: [expr {$end - $start}]ms"