set total 0.0; set start [clock milliseconds]
for {set i 1} {$i <= 10000} {incr i} {set x [expr {1.0*$i}]; set guess [expr {$x/2.0}]
 for {set s 0} {$s < 20} {incr s} {set guess [expr {($guess+$x/$guess)/2.0}]}
 set total [expr {$total+$guess}]}
set end [clock milliseconds]; puts "Result: $total"; puts "Time: [expr {$end-$start}]ms"