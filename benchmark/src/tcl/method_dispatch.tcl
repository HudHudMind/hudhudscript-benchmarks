oo::class create Shape { method score {} { return 0 } }
oo::class create A {
    superclass Shape
    variable v
    constructor {} { set v 0 }
    method setV {val} { set v $val }
    method score {} { return [expr {$v * 2}] }
}
oo::class create B {
    superclass Shape
    variable v
    constructor {} { set v 0 }
    method setV {val} { set v $val }
    method score {} { return [expr {$v * 3 + 1}] }
}
oo::class create C {
    superclass Shape
    variable v
    constructor {} { set v 0 }
    method setV {val} { set v $val }
    method score {} { return [expr {$v * 5 - 2}] }
}

set shapes {}
for {set i 0} {$i < 3000} {incr i} {
    set r [expr {$i % 3}]
    if {$r == 0} { set obj [A new]; $obj setV [expr {$i % 97}] } elseif {$r == 1} { set obj [B new]; $obj setV [expr {$i % 97}] } else { set obj [C new]; $obj setV [expr {$i % 97}] }
    lappend shapes $obj
}

set P 300
set acc 0
set start [clock milliseconds]
for {set round 0} {$round < $P} {incr round} {
    foreach s $shapes {
        set acc [expr {($acc + [$s score]) % 1000003}]
    }
}
set end [clock milliseconds]
puts "Result: $acc"
puts "Time: [expr {$end - $start}]ms"
