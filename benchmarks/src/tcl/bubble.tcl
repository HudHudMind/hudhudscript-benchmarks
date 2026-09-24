set n 500; set a {}; for {set i $n} {$i >= 1} {incr i -1} {lappend a $i}
set start [clock milliseconds]
for {set i 0} {$i < $n} {incr i} {for {set j 0} {$j < $n - 1} {incr j} {if {[lindex $a $j] > [lindex $a [expr {$j + 1}]]} {set t [lindex $a $j]; lset a $j [lindex $a [expr {$j + 1}]]; lset a [expr {$j + 1}] $t}}}
set end [clock milliseconds]; puts "Result: [lindex $a 0]/[lindex $a [expr {$n-1}]]"; puts "Time: [expr {$end-$start}]ms"
