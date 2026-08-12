oo::class create Counter {
    variable c
    constructor {start} { set c $start }
    method next {} { set c [expr {$c + 1}]; return $c }
}

set N 150000
set acc 0
set start [clock milliseconds]
for {set i 0} {$i < $N} {incr i} {
    set ctr [Counter new [expr {$i % 1000}]]
    set acc [expr {($acc + [$ctr next] + [$ctr next] + [$ctr next]) % 1000003}]
    $ctr destroy
}
set end [clock milliseconds]
puts "Result: $acc"
puts "Time: [expr {$end - $start}]ms"
