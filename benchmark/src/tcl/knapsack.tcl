set n 50; set W 100
set w {}; set v {}; for {set i 0} {$i < $n} {incr i} {lappend w [expr {($i*7+3)%20+1}]; lappend v [expr {($i*13+5)%50+10}]}
set start [clock milliseconds]
set dp {}; for {set i 0} {$i <= $n} {incr i} {set r {}; for {set j 0} {$j <= $W} {incr j} {lappend r 0}; lappend dp $r}
for {set i 0} {$i < $n} {incr i} {for {set j 0} {$j <= $W} {incr j} {
 set wi [lindex $w $i]
 if {$wi <= $j} {set v1 [lindex $dp $i $j]; set v2 [expr {[lindex $dp $i [expr {$j-$wi}]]+[lindex $v $i]}]; lset dp [expr {$i+1}] $j [expr {$v1>$v2?$v1:$v2}]} else {lset dp [expr {$i+1}] $j [lindex $dp $i $j]}
}}
set end [clock milliseconds]; puts "Result: [lindex $dp $n $W]"; puts "Time: [expr {$end-$start}]ms"