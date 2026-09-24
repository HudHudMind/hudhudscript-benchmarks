proc fannkuch {n} {
    set p {}
    set q {}
    set s {}
    for {set i 0} {$i < $n} {incr i} {
        lappend p $i
        lappend q $i
        lappend s $i
    }
    set sign 1
    set maxflips 0
    set sumflips 0

    while {1} {
        set q1 [lindex $p 0]
        if {$q1 != 0} {
            for {set i 1} {$i < $n} {incr i} {
                lset q $i [lindex $p $i]
            }
            set flips 1
            while {1} {
                set qq [lindex $q $q1]
                if {$qq == 0} {break}
                lset q $q1 $q1
                if {$q1 >= 3} {
                    set i 1
                    set j [expr {$q1 - 1}]
                    while {$i < $j} {
                        set t [lindex $q $i]
                        lset q $i [lindex $q $j]
                        lset q $j $t
                        incr i
                        incr j -1
                    }
                }
                set q1 $qq
                incr flips
            }
            if {$flips > $maxflips} {set maxflips $flips}
            set sumflips [expr {$sumflips + $sign * $flips}]
        }

        if {$sign == 1} {
            set t [lindex $p 1]
            lset p 1 [lindex $p 0]
            lset p 0 $t
            set sign -1
        } else {
            set t [lindex $p 1]
            lset p 1 [lindex $p 2]
            lset p 2 $t
            set sign 1
            set k 2
            while {$k < $n} {
                set sk [expr {[lindex $s $k] - 1}]
                lset s $k $sk
                if {$sk != 0} {break}
                lset s $k $k
                set t0 [lindex $p 0]
                for {set m 0} {$m <= $k} {incr m} {
                    lset p $m [expr {$m < $k ? [lindex $p [expr {$m + 1}]] : $t0}]
                }
                incr k
            }
            if {$k == $n} {break}
        }
    }
    return "${sumflips}_${maxflips}"
}

set start [clock milliseconds]
set res [fannkuch 9]
set end [clock milliseconds]

puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
