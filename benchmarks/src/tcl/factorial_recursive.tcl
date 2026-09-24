proc fact {n} {if {$n <= 1} {return 1}; return [expr {$n * [fact [expr {$n - 1}]]}]}
set start [clock milliseconds]
set res [fact 150]
set end [clock milliseconds]
puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
