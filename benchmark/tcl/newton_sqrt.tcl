proc nsqrt {n} { set x $n; set y 1.0; set e 0.000001; while {[expr {$x - $y}] > $e} { set x [expr {($x + $y) / 2.0}]; set y [expr {$n / $x}] }; return $x }
set start [clock milliseconds]; set res 0; for {set i 0} {$i < 100000} {incr i} { set res [nsqrt 1000000.0] }
set end [clock milliseconds]; puts "Sqrt: $res"; puts "Time: [expr {$end - $start}]ms"