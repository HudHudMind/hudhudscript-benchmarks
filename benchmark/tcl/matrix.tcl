set n 150; array set A {}; array set B {}; array set C {}
for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} {
    set A($i,$j) [expr {$i + $j}]; set B($i,$j) [expr {$i - $j}]; set C($i,$j) 0 } }
set start [clock milliseconds]
for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { for {set k 0} {$k < $n} {incr k} {
    set C($i,$j) [expr {$C($i,$j) + $A($i,$k) * $B($k,$j)}] } } }
set end [clock milliseconds]; puts "Corner: $C(0,0)/$C([expr {$n-1}],[expr {$n-1}])"; puts "Time: [expr {$end - $start}]ms"