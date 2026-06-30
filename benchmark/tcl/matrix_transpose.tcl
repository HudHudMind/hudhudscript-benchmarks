proc transpose {A n} { array set a $A; array set B {}
    for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { set B($i,$j) $a($j,$i) } }; return [array get B] }
set start [clock milliseconds]; array set A {}; for {set i 0} {$i < 500} {incr i} { for {set j 0} {$j < 500} {incr j} { set A($i,$j) [expr {$i + $j}] } }
set res 0; for {set k 0} {$k < 100} {incr k} { array set B [transpose [array get A] 500]; set res $B(0,0) }
set end [clock milliseconds]; puts "First: $res"; puts "Time: [expr {$end - $start}]ms"