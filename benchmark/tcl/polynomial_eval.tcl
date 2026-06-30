proc eval {x coeffs} { set res 0.0; for {set i [expr {[llength $coeffs] - 1}]} {$i >= 0} {incr i -1} { set res [expr {$res * $x + [lindex $coeffs $i]}] }; return $res }
set start [clock milliseconds]; set coeffs {}; for {set i 1} {$i <= 1000} {incr i} { lappend coeffs $i }; set res 0
for {set i 0} {$i < 100000} {incr i} { set res [eval 1.0001 $coeffs] }
set end [clock milliseconds]; puts "Eval: $res"; puts "Time: [expr {$end - $start}]ms"