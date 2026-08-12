interp recursionlimit {} 50000

proc tak {x y z} {
    if {$y < $x} {
        return [tak \
            [tak [expr {$x - 1}] $y $z] \
            [tak [expr {$y - 1}] $z $x] \
            [tak [expr {$z - 1}] $x $y] \
        ]
    }
    return $z
}

set start [clock milliseconds]
set res 0
for {set i 0} {$i < 10} {incr i} {
    set res [tak 18 12 6]
}
set end [clock milliseconds]

puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
