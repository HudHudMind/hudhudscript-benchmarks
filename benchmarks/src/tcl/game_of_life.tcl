set G 96; set T 100; set seed 12345
proc ri {m} { global seed; set seed [expr {($seed*16807)%2147483647}]; return [expr {$seed%$m}] }
set a {}; for {set i 0} {$i < $G} {incr i} { set r {}; for {set j 0} {$j < $G} {incr j} { lappend r [expr {[ri 100] < 35 ? 1 : 0}] }; lappend a $r }
set b {}; for {set i 0} {$i < $G} {incr i} { set r {}; for {set j 0} {$j < $G} {incr j} { lappend r 0 }; lappend b $r }
set start [clock milliseconds]
for {set t 0} {$t < $T} {incr t} {
    for {set i 0} {$i < $G} {incr i} { for {set j 0} {$j < $G} {incr j} {
        set nbr 0
        foreach di {-1 0 1} { foreach dj {-1 0 1} { if {$di==0&&$dj==0} continue
            set ni [expr {($i+$di)%$G}]; set nj [expr {($j+$dj)%$G}]
            incr nbr [lindex $a $ni $nj] } }
        set av [lindex $a $i $j]
        if {$av==1&&($nbr==2||$nbr==3)||$av==0&&$nbr==3} { lset b $i $j 1 } else { lset b $i $j 0 }
    } }
    set tmp $a; set a $b; set b $tmp
}
set alive 0; for {set i 0} {$i < $G} {incr i} { for {set j 0} {$j < $G} {incr j} { incr alive [lindex $a $i $j] } }
set end [clock milliseconds]
puts "Result: $alive"; puts "Time: [expr {$end-$start}]ms"