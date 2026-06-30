interp recursionlimit {} 5000; proc partition {l h} { global arr; set p [lindex $arr $h]; set i [expr {$l - 1}]; for {set j $l} {$j < $h} {incr j} {
        if {[lindex $arr $j] <= $p} { incr i; set t [lindex $arr $i]; lset arr $i [lindex $arr $j]; lset arr $j $t } }
        set t [lindex $arr [expr {$i+1}]]; lset arr [expr {$i+1}] [lindex $arr $h]; lset arr $h $t; return [expr {$i + 1}] }
proc quick {l h} { global arr; if {$l < $h} { set pi [partition $l $h]; quick $l [expr {$pi - 1}]; quick [expr {$pi + 1}] $h } }
set start [clock milliseconds]; set first 0; for {set k 0} {$k < 100} {incr k} { set arr {}; for {set i 1000} {$i >= 1} {incr i -1} { lappend arr $i }; quick 0 999; set first [lindex $arr 0] }
set end [clock milliseconds]; puts "First: $first"; puts "Time: [expr {$end - $start}]ms"