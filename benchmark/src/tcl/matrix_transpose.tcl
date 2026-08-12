set n 300; set m {}; for {set i 0} {$i<$n} {incr i} {set r {}; for {set j 0} {$j<$n} {incr j} {lappend r [expr {$i+$j}]}; lappend m $r}
set t {}; for {set i 0} {$i<$n} {incr i} {set r {}; for {set j 0} {$j<$n} {incr j} {lappend r 0}; lappend t $r}
set start [clock milliseconds]
for {set i 0} {$i<$n} {incr i} {for {set j 0} {$j<$n} {incr j} {lset t $j $i [lindex $m $i $j]}}
set end [clock milliseconds]; puts "Result: [lindex $t 0 0]/[lindex $t [expr {$n-1}] [expr {$n-1}]]"; puts "Time: [expr {$end-$start}]ms"