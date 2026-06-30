proc hanoi {n} { if {$n == 1} { return 1 } else { return [expr {2 * [hanoi [expr {$n - 1}]] + 1}] } }
set start [clock milliseconds]; set res [hanoi 20]; set end [clock milliseconds]
puts "Moves: $res"; puts "Time: [expr {$end - $start}]ms"