proc gcd {a b} { if {$b == 0} { return $a } else { return [gcd $b [expr {$a % $b}]] } }
set start [clock milliseconds]; set result 0; for {set i 1} {$i <= 10000} {incr i} { set result [gcd [expr {$i * 12345}] [expr {$i * 6789 + 1}]] }
set end [clock milliseconds]; puts "Result: $result"; puts "Time: [expr {$end - $start}]ms"