set arr {}; for {set i 0} {$i < 10000} {incr i} { lappend arr $i }
set sum 0; set start [clock milliseconds]
for {set i 0} {$i < 10000} {incr i} { set sum [expr {$sum + [lindex $arr $i]}] }
set end [clock milliseconds]; puts "Sum: $sum"; puts "Time: [expr {$end - $start}]ms"