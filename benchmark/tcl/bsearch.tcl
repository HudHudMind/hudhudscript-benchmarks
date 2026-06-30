proc bsearch {x} { global arr; set l 0; set r [expr {[llength $arr] - 1}]
    while {$l <= $r} { set m [expr {$l + ($r - $l) / 2}]; set val [lindex $arr $m]
        if {$val == $x} { return $m } elseif {$val < $x} { set l [expr {$m + 1}] } else { set r [expr {$m - 1}] } }; return -1 }
set arr {}; for {set i 1} {$i <= 100000} {incr i} { lappend arr $i }; set start [clock milliseconds]; set found 0
for {set i 1} {$i <= 10000} {incr i} { if {[bsearch [expr {$i * 5}]] != -1} { incr found } }
set end [clock milliseconds]; puts "Found: $found"; puts "Time: [expr {$end - $start}]ms"