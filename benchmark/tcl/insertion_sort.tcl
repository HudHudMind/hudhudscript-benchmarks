proc insertSort {} { global arr; set n [llength $arr]; for {set i 1} {$i < $n} {incr i} { set key [lindex $arr $i]; set j [expr {$i - 1}]
        while {$j >= 0 && [lindex $arr $j] > $key} { lset arr [expr {$j + 1}] [lindex $arr $j]; incr j -1 }; lset arr [expr {$j + 1}] $key } }
set start [clock milliseconds]; for {set k 0} {$k < 10} {incr k} { set arr {}; for {set i 1000} {$i >= 1} {incr i -1} { lappend arr $i }; insertSort }
set end [clock milliseconds]; puts "First: [lindex $arr 0]"; puts "Last: [lindex $arr end]"; puts "Time: [expr {$end - $start}]ms"