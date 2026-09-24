proc gcd {a b} {
    while {$b != 0} {set t $b; set b [expr {$a % $b}]; set a $t}
    return $a
}
set start [clock milliseconds]
set result 0
for {set i 1} {$i <= 10000} {incr i} {set result [gcd [expr {$i * 12345}] [expr {$i * 6789 + 1}]]}
set end [clock milliseconds]
puts "Result: $result"
puts "Time: [expr {$end - $start}]ms"