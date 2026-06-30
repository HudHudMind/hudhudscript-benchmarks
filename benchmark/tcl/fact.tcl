set start [clock milliseconds]
set result 1
for {set i 2} {$i <= 10000} {incr i} {
    set result [expr {$result * $i}]
}
set end [clock milliseconds]
puts "Result: $result"
puts "Time: [expr {$end - $start}]ms"
