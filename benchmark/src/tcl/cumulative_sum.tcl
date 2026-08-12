set n 100000; set arr {}; for {set i 1} {$i <= $n} {incr i} {lappend arr $i}
set start [clock milliseconds]
set cum {}; set sum 0
foreach val $arr { incr sum $val; lappend cum $sum }
set end [clock milliseconds]
puts "Result: [lindex $cum end]"; puts "Time: [expr {$end-$start}]ms"
