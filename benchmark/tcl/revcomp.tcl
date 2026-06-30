array set comp {
    A T C G G C T A
    U A M K R Y W W
    S S Y R K M V B
    H D D H B V N N
    a T c G g C t A
    u A m K r Y w W
    s S y R k M v B
    h D d H b V n N
}

proc reverse_complement {seq} {
    global comp
    set count_A 0
    set len [string length $seq]
    for {set i [expr {$len - 1}]} {$i >= 0} {incr i -1} {
        set c [string index $seq $i]
        if {[info exists comp($c)]} {
            set rep $comp($c)
        } else {
            set rep $c
        }
        if {$rep eq "A"} {
            incr count_A
        }
    }
    return $count_A
}

set start [clock milliseconds]

set seq ""
set seed 42
set chars {A C G T}
for {set i 0} {$i < 500000} {incr i} {
    set seed [expr {($seed * 1103515245 + 12345) & 0x7fffffff}]
    set idx [expr {($seed >> 16) % 4}]
    append seq [lindex $chars $idx]
}

set res 0
for {set i 0} {$i < 10} {incr i} {
    set res [reverse_complement $seq]
}

set end [clock milliseconds]
puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
