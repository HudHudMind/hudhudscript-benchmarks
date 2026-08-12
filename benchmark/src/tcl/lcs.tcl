set a "[string repeat abcdefghij 10]"; set b "[string repeat acegikmoqs 10]"
set m [string length $a]; set n [string length $b]; set start [clock milliseconds]
set dp {}; for {set i 0} {$i <= $m} {incr i} {set r {}; for {set j 0} {$j <= $n} {incr j} {lappend r 0}; lappend dp $r}
for {set i 0} {$i < $m} {incr i} {for {set j 0} {$j < $n} {incr j} {
 if {[string index $a $i] eq [string index $b $j]} {lset dp [expr {$i+1}] [expr {$j+1}] [expr {[lindex $dp $i $j]+1}]} else {set v1 [lindex $dp $i [expr {$j+1}]]; set v2 [lindex $dp [expr {$i+1}] $j]; lset dp [expr {$i+1}] [expr {$j+1}] [expr {$v1>$v2?$v1:$v2}]}}
}
set end [clock milliseconds]; puts "Result: [lindex $dp $m $n]"; puts "Time: [expr {$end-$start}]ms"