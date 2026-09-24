proc ack {m n} { if {$m == 0} { return [expr {$n + 1}] } elseif {$n == 0} { return [ack [expr {$m - 1}] 1] } else { return [ack [expr {$m - 1}] [ack $m [expr {$n - 1}]]] } }
set start [clock milliseconds]; set result [ack 3 6]; set end [clock milliseconds]
puts "Result: $result"; puts "Time: [expr {$end - $start}]ms"