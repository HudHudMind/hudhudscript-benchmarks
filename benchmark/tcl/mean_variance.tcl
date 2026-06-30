set arr {}; for {set i 1} {$i <= 10000} {incr i} { lappend arr $i }
proc mv {} { global arr; set n [llength $arr]; set sum 0.0; foreach x $arr { set sum [expr {$sum + $x}] }; set mean [expr {$sum / $n}]; set var 0.0
    foreach x $arr { set d [expr {$x - $mean}]; set var [expr {$var + $d * $d}] }; return [expr {$var / $n}] }
set start [clock milliseconds]; set res 0; for {set i 0} {$i < 10000} {incr i} { set res [mv] }
set end [clock milliseconds]; puts "Var: $res"; puts "Time: [expr {$end - $start}]ms"