set n 200; set A {}; for {set i 0} {$i<$n} {incr i} {set row {}; for {set j 0} {$j<$n} {incr j} {lappend row [expr {(($i*31+$j*17)%100+1)+($i==$j?1000:0)}]}; lappend A $row}
set start [clock milliseconds]
for {set k 0} {$k<$n} {incr k} {for {set i [expr {$k+1}]} {$i<$n} {incr i} {set f [expr {double([lindex $A $i $k])/[lindex $A $k $k]}]; for {set j 0} {$j<$n} {incr j} {lset A $i $j [expr {[lindex $A $i $j]-$f*[lindex $A $k $j]}]}; lset A $i $k $f}}
set s 0; for {set i 0} {$i<$n} {incr i} {set s [expr {$s+[lindex $A $i $i]}]}; set r [expr {round($s/$n*1000)}]
set end [clock milliseconds]; puts "Result: $r"; puts "Time: [expr {$end-$start}]ms"