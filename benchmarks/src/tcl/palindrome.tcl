set N 50000
set s [string repeat "a" $N]
set R 1000
set ok true
set start [clock milliseconds]
for {set r 0} {$r < $R} {incr r} {
    set left 0
    set right [expr {$N - 1}]
    while {$left < $right} {
        if {[string index $s $left] ne [string index $s $right]} {set ok false; break}
        incr left; incr right -1
    }
}
set end [clock milliseconds]
puts "Result: $ok"
puts "Time: [expr {$end - $start}]ms"
