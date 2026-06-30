proc mod_exp {base exp mod} {
    set result 1
    set b [expr {$base % $mod}]
    set e $exp
    set m $mod
    while {$e > 0} {
        if {[expr {$e % 2}] == 1} {
            set result [expr {($result * $b) % $m}]
        }
        set b [expr {($b * $b) % $m}]
        set e [expr {$e / 2}]
    }
    return $result
}

set start [clock milliseconds]
set sum 0
for {set i 0} {$i < 10000} {incr i} {
    set sum [expr {$sum + [mod_exp 3 1000 1000000007]}]
}
set end [clock milliseconds]
puts "Sum: $sum"
puts "Time: [expr {$end - $start}]ms"
