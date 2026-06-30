set v1 {}; set v2 {}; for {set i 1} {$i <= 500000} {incr i} { lappend v1 $i; lappend v2 [expr {$i + 1}] }
set start [clock milliseconds]; set s 0; for {set i 0} {$i < 500000} {incr i} { set s [expr {$s + [lindex $v1 $i] * [lindex $v2 $i]}] }
set end [clock milliseconds]; puts "Dot: $s"; puts "Time: [expr {$end - $start}]ms"