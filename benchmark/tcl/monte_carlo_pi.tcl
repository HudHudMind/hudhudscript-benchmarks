set inside 0
set total 500000
set seed 12345

proc next_random {} {
    global seed
    set seed [expr {($seed * 16807) % 2147483647}]
    return [expr {$seed / 2147483647.0}]
}

set start [clock milliseconds]
for {set i 0} {$i < $total} {incr i} {
    set x [next_random]
    set y [next_random]
    if {[expr {$x * $x + $y * $y}] <= 1.0} {
        incr inside
    }
}
set end [clock milliseconds]
set pi [expr {4.0 * $inside / $total}]
puts "Pi: $pi"
puts "Time: [expr {$end - $start}]ms"
