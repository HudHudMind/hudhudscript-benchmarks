# Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
# Tcl native big int (expr). D=600. Golden: 2668_6766940513

set D 600
set GUARD 5
set SCALE [expr {$D + 10}]

proc arctan_inv {x} {
    global SCALE
    set res 0
    set term [expr {10 ** $SCALE / $x}]
    set x2 [expr {$x * $x}]
    set sign 1
    set k 0
    while 1 {
        set divisor [expr {2 * $k + 1}]
        set t_k [expr {$term / $divisor}]
        if {$t_k == 0} break
        if {$sign > 0} {
            set res [expr {$res + $t_k}]
        } else {
            set res [expr {$res - $t_k}]
        }
        set sign [expr {-$sign}]
        set term [expr {$term / $x2}]
        incr k
    }
    return $res
}

set start [clock milliseconds]

set a5 [arctan_inv 5]
set a239 [arctan_inv 239]
set pi [expr {16 * $a5 - 4 * $a239}]

set s $pi
set target_len [expr {$D + 10}]
while {[string length $s] < $target_len} { set s "0$s" }
set s [string range $s 0 [expr {$D - 1}]]

set ds 0
for {set i 0} {$i < $D} {incr i} {
    incr ds [string index $s $i]
}
set lt [string range $s end-9 end]

set end [clock milliseconds]
puts "Result: ${ds}_${lt}"
puts "Time: [expr {$end - $start}]ms"
