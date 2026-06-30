proc heapify {n i} { global arr; set largest $i; set l [expr {2 * $i + 1}]; set r [expr {2 * $i + 2}]
    if {$l < $n && [lindex $arr $l] > [lindex $arr $largest]} { set largest $l }
    if {$r < $n && [lindex $arr $r] > [lindex $arr $largest]} { set largest $r }
    if {$largest != $i} { set t [lindex $arr $i]; lset arr $i [lindex $arr $largest]; lset arr $largest $t; heapify $n $largest } }
proc heapSort {} { global arr; set n [llength $arr]; for {set i [expr {$n / 2 - 1}]} {$i >= 0} {incr i -1} { heapify $n $i }
    for {set i [expr {$n - 1}]} {$i > 0} {incr i -1} { set t [lindex $arr 0]; lset arr 0 [lindex $arr $i]; lset arr $i $t; heapify $i 0 } }
set start [clock milliseconds]; for {set j 0} {$j < 100} {incr j} { set arr {}; for {set i 1000} {$i >= 1} {incr i -1} { lappend arr $i }; heapSort }
set end [clock milliseconds]; puts "First: [lindex $arr 0]"; puts "Last: [lindex $arr end]"; puts "Time: [expr {$end - $start}]ms"