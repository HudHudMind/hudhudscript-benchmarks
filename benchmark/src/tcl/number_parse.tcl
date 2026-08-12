set n 200000; set seed 12345
proc ri {m} { global seed; set seed [expr {($seed*16807)%2147483647}]; return [expr {$seed%$m}] }
set strings {}
for {set i 0} {$i < $n} {incr i} {
    set s ""; if {[ri 2] == 0} { set s "-" }
    set nd [expr {1+[ri 9]}]; append s [expr {1+[ri 9]}]
    for {set j 1} {$j < $nd} {incr j} { append s [ri 10] }
    lappend strings $s
}
set start [clock milliseconds]; set total 0; set M 1000003
foreach s $strings {
    set neg 0; set idx 0
    if {[string index $s 0] eq "-"} { set neg 1; set idx 1 }
    set val 0
    while {$idx < [string length $s]} {
        set c [string index $s $idx]; set d 0
        if {$c eq "0"} {set d 0} elseif {$c eq "1"} {set d 1} elseif {$c eq "2"} {set d 2} elseif {$c eq "3"} {set d 3} elseif {$c eq "4"} {set d 4} elseif {$c eq "5"} {set d 5} elseif {$c eq "6"} {set d 6} elseif {$c eq "7"} {set d 7} elseif {$c eq "8"} {set d 8} else {set d 9}
        set val [expr {$val*10+$d}]; incr idx
    }
    if {$neg} { set val [expr {-$val}] }
    set total [expr {$total+$val}]
}
set r [expr {(($total%$M)+$M)%$M}]
set end [clock milliseconds]
puts "Result: $r"; puts "Time: [expr {$end-$start}]ms"
