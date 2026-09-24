set n 1000; set a {}; for {set i $n} {$i >= 1} {incr i -1} {lappend a $i}
set start [clock milliseconds]
for {set i 1} {$i < $n} {incr i} {set key [lindex $a $i]; set j [expr {$i - 1}]
 while {$j >= 0 && [lindex $a $j] > $key} {lset a [expr {$j + 1}] [lindex $a $j]; incr j -1}
 lset a [expr {$j + 1}] $key}
set end [clock milliseconds]; puts "Result: [lindex $a 0]/[lindex $a [expr {$n-1}]]"; puts "Time: [expr {$end - $start}]ms"