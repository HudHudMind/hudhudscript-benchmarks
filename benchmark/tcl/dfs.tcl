set n 100; array set adj {}; for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { set adj($i,$j) 0 } }
for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { if {[expr {($i * 3 + $j * 7) % 11}] == 0 && $i != $j} { set adj($i,$j) 1 } } }
set start [clock milliseconds]; array set visited {}; for {set i 0} {$i < $n} {incr i} { set visited($i) 0 }
set stack {0}; set count 0
while {[llength $stack] > 0} { set node [lindex $stack end]; set stack [lrange $stack 0 end-1]
    if {!$visited($node)} { set visited($node) 1; incr count
        for {set neighbor [expr {$n - 1}]} {$neighbor >= 0} {incr neighbor -1} { if {$adj($node,$neighbor) == 1 && !$visited($neighbor)} { lappend stack $neighbor } } } }
set end [clock milliseconds]; puts "Visited: $count"; puts "Time: [expr {$end - $start}]ms"