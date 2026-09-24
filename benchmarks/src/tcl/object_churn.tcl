set N 500000
set acc 0
set start [clock milliseconds]
for {set i 0} {$i < $N} {incr i} {
    array unset p
    array set p {}
    set p(x) $i
    set p(y) [expr {$i * 2}]
    set p(z) 0
    set p(z) [expr {$p(x) + $p(y)}]
    set acc [expr {($acc + $p(z)) % 1000003}]
}
set end [clock milliseconds]
puts "Result: $acc"
puts "Time: [expr {$end-$start}]ms"
