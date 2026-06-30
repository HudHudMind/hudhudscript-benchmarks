set start [clock milliseconds]

set seed 42
proc rand_val {max_val} {
    global seed
    set seed [expr {($seed * 3877 + 29573) % 139968}]
    return [expr {$max_val * $seed / 139968.0}]
}

set iub {
    {a 0.27} {c 0.12} {g 0.12} {t 0.27}
    {B 0.02} {D 0.02} {H 0.02} {K 0.02}
    {M 0.02} {N 0.02} {R 0.02} {S 0.02}
    {V 0.02} {W 0.02} {Y 0.02}
}

set cp 0.0
for {set i 0} {$i < [llength $iub]} {incr i} {
    set x [lindex $iub $i]
    set cp [expr {$cp + [lindex $x 1]}]
    lset iub $i 1 $cp
}

set res 0
set n 50000

set total [expr {$n * 2}]
while {$total > 0} {
    set chunk [expr {$total < 60 ? $total : 60}]
    incr res $chunk
    incr total -$chunk
}

set total [expr {$n * 3}]
while {$total > 0} {
    set chunk [expr {$total < 60 ? $total : 60}]
    for {set c 0} {$c < $chunk} {incr c} {
        set r [rand_val 1.0]
        for {set j 0} {$j < [llength $iub]} {incr j} {
            if {$r < [lindex [lindex $iub $j] 1]} {
                incr res
                break
            }
        }
    }
    incr total -$chunk
}

set end [clock milliseconds]
puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
