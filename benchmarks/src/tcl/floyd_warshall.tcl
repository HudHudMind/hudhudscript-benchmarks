set n 150; set INF 999999999; set dist {}
for {set i 0} {$i < $n} {incr i} {
    set row {}
    for {set j 0} {$j < $n} {incr j} {
        lappend row [expr {$i==$j ? 0 : $INF}]
    }
    lappend dist $row
}
set seed 12345
proc ri {m} { global seed; set seed [expr {($seed*16807)%2147483647}]; return [expr {$seed%$m}] }
for {set i 0} {$i < $n} {incr i} {
    for {set j 0} {$j < 4} {incr j} {
        set t [expr {($i*7+$j*13+1)%$n}]
        if {$t != $i} { lset dist $i $t [expr {1+(($i+$j)%50)}] }
    }
}
set start [clock milliseconds]
for {set k 0} {$k < $n} {incr k} {
    for {set i 0} {$i < $n} {incr i} {
        set dik [lindex $dist $i $k]
        if {$dik != $INF} {
            for {set j 0} {$j < $n} {incr j} {
                set nd [expr {$dik + [lindex $dist $k $j]}]
                if {$nd < [lindex $dist $i $j]} { lset dist $i $j $nd }
            }
        }
    }
}
set reach 0; set sm 0
for {set i 0} {$i < $n} {incr i} {
    for {set j 0} {$j < $n} {incr j} {
        if {[lindex $dist $i $j] < $INF} { incr reach; incr sm [lindex $dist $i $j] }
    }
}
set end [clock milliseconds]
puts "Result: ${reach}_[expr {$sm % 1000003}]"
puts "Time: [expr {$end - $start}]ms"
