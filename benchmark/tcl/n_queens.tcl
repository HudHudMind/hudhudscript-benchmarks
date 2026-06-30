proc solve {r n} { global cols d1 d2; if {$r == $n} { return 1 }; set c 0
    for {set i 0} {$i < $n} {incr i} { if {![info exists cols($i)] && ![info exists d1([expr {$r+$i}])] && ![info exists d2([expr {$r-$i+$n}])]} {
        set cols($i) 1; set d1([expr {$r+$i}]) 1; set d2([expr {$r-$i+$n}]) 1; set c [expr {$c + [solve [expr {$r+1}] $n]}]
        unset cols($i); unset d1([expr {$r+$i}]); unset d2([expr {$r-$i+$n}]) } }; return $c }
set start [clock milliseconds]; set res 0; for {set k 0} {$k < 100} {incr k} { array unset cols; array unset d1; array unset d2; array set cols {}; array set d1 {}; array set d2 {}; set res [solve 0 8] }
set end [clock milliseconds]; puts "Count: $res"; puts "Time: [expr {$end - $start}]ms"