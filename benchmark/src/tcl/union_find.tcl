set n 200000;set U 400000;set parent {};set size {}
for {set i 0} {$i < $n} {incr i} {lappend parent $i;lappend size 1}
proc find {x parent_name} {upvar $parent_name p;while {[lindex $p $x]!=$x} {set x [lindex $p $x]};return $x}
proc union {a b pn sn} {upvar $pn parent;upvar $sn size;set ra [find $a parent];set rb [find $b parent]
 if {$ra!=$rb} {if {[lindex $size $ra]<[lindex $size $rb]} {lset parent $ra $rb;lset size $rb [expr {[lindex $size $rb]+[lindex $size $ra]}]} else {lset parent $rb $ra;lset size $ra [expr {[lindex $size $ra]+[lindex $size $rb]}]}}}
set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set start [clock milliseconds]
for {set i 0} {$i < $U} {incr i} {union [ri $n] [ri $n] parent size}
set roots 0;for {set i 0} {$i < $n} {incr i} {if {[lindex $parent $i]==$i} {incr roots}}
set end [clock milliseconds];puts "Result: $roots";puts "Time: [expr {$end-$start}]ms"
