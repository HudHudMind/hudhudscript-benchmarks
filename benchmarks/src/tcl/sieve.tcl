set n 10000; set prime {}; for {set i 0} {$i <= $n} {incr i} {lappend prime true}
lset prime 0 false; lset prime 1 false
set start [clock milliseconds]
for {set i 2} {$i * $i <= $n} {incr i} {if {[lindex $prime $i]} {for {set j [expr {$i * $i}]} {$j <= $n} {incr j $i} {lset prime $j false}}}
set cnt 0; for {set i 2} {$i <= $n} {incr i} {if {[lindex $prime $i]} {incr cnt}}
set end [clock milliseconds]; puts "Result: $cnt"; puts "Time: [expr {$end - $start}]ms"