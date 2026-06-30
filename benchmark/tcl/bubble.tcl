proc bubbleSort {} { global arr; set n [llength $arr]; for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < [expr {$n - $i - 1}]} {incr j} {
        if {[lindex $arr $j] > [lindex $arr [expr {$j + 1}]]} { set t [lindex $arr $j]; lset arr $j [lindex $arr [expr {$j + 1}]]; lset arr [expr {$j + 1}] $t } } } }
set start [clock milliseconds]; for {set k 0} {$k < 100} {incr k} { set arr {}; for {set i 500} {$i >= 1} {incr i -1} { lappend arr $i }; bubbleSort }
set end [clock milliseconds]; puts "First: [lindex $arr 0]"; puts "Last: [lindex $arr end]"; puts "Time: [expr {$end - $start}]ms"