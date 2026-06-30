set n 100; array set adj {}; for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { set adj($i,$j) 0 } }
for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { if {[expr {($i * 3 + $j * 7) % 11}] == 0 && $i != $j} { set adj($i,$j) 1 } } }
set start [clock milliseconds]; array set visited {}; for {set i 0} {$i < $n} {incr i} { set visited($i) 0 }
set queue {0}; set head 0; set count 0
while {$head < [llength $queue]} { set node [lindex $queue $head]; incr head
    if {!$visited($node)} { set visited($node) 1; incr count
        for {set neighbor 0} {$neighbor < $n} {incr neighbor} { if {$adj($node,$neighbor) == 1 && !$visited($neighbor)} { lappend queue $neighbor } } } }
set end [clock milliseconds]; puts "Visited: $count"; puts "Time: [expr {$end - $start}]ms"