set n 1000; set coeff {}; for {set i 1} {$i<=[expr {$n+1}]} {incr i} {lappend coeff [expr {$i*1.0}]}
set R 100000; set x 1.5; set total 0.0; set start [clock milliseconds]
for {set r 0} {$r < $R} {incr r} {set y [lindex $coeff $n]
 for {set i [expr {$n-1}]} {$i >= 0} {incr i -1} {set y [expr {$y*$x+[lindex $coeff $i]}]}
 set total [expr {$total+$y}]}
set end [clock milliseconds]; puts "Result: $total"; puts "Time: [expr {$end-$start}]ms"