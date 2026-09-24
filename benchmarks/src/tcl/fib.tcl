proc fib {n} { if {$n < 2} { return $n } else { return [expr {[fib [expr {$n - 1}]] + [fib [expr {$n - 2}]]}] } }
set start [clock milliseconds]; set res [fib 30]; set end [clock milliseconds]
puts "Result: $res"; puts "Time: [expr {$end - $start}]ms"