set n 1000; set a {}; for {set i $n} {$i >= 1} {incr i -1} {lappend a $i}
proc heapify {a n i} {upvar $a arr; set big $i; set l [expr {2*$i+1}]; set r [expr {2*$i+2}]
 if {$l<$n&&[lindex $arr $l]>[lindex $arr $big]} {set big $l}
 if {$r<$n&&[lindex $arr $r]>[lindex $arr $big]} {set big $r}
 if {$big!=$i} {set t [lindex $arr $i];lset arr $i [lindex $arr $big];lset arr $big $t;heapify arr $n $big}}
set start [clock milliseconds]
for {set i [expr {$n/2-1}]} {$i>=0} {incr i -1} {heapify a $n $i}
for {set i [expr {$n-1}]} {$i>0} {incr i -1} {set t [lindex $a 0];lset a 0 [lindex $a $i];lset a $i $t;heapify a $i 0}
set end [clock milliseconds]; puts "Result: [lindex $a 0]/[lindex $a [expr {$n-1}]]"; puts "Time: [expr {$end-$start}]ms"