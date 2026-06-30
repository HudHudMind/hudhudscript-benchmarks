set arr {}; for {set i 1} {$i <= 100000} {incr i} { lappend arr $i }
set start [clock milliseconds]; set res {}; set sum 0
for {set i 0} {$i < 100000} {incr i} { set sum [expr {$sum + [lindex $arr $i]}]; lappend res $sum }
set end [clock milliseconds]; puts "Last sum: [lindex $res end]"; puts "Time: [expr {$end - $start}]ms"