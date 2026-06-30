proc collatz {n} { set len 0; set curr $n
    while {$curr != 1} { if {[expr {$curr % 2}] == 0} { set curr [expr {$curr / 2}] } else { set curr [expr {3 * $curr + 1}] }; incr len }; return $len }
set start [clock milliseconds]; set max_steps 0; set max_n 0
for {set i 1} {$i <= 10000} {incr i} { set l [collatz $i]; if {$l > $max_steps} { set max_steps $l; set max_n $i } }
set end [clock milliseconds]; puts "Max steps: $max_steps at n=$max_n"; puts "Time: [expr {$end - $start}]ms"