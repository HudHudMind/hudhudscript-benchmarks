proc hanoi {n} {if {$n == 1} {return 1}; return [expr {[hanoi [expr {$n - 1}]] + 1 + [hanoi [expr {$n - 1}]]}]}
set start [clock milliseconds]; set res [hanoi 20]; set end [clock milliseconds]
puts "Result: $res"; puts "Time: [expr {$end - $start}]ms"