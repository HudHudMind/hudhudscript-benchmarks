set M 400000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set syms {};set i 0
while {$i<$M} {if {$i>=20&&[ri 10]<4} {set s [expr {$i-20}];for {set j 0} {$j<20} {incr j} {lappend syms [lindex $syms [expr {$s+$j}]]};incr i 20} else {lappend syms [ri 4];incr i}}
set DS 4096;set dic {};for {set j 0} {$j<[expr {$DS*4}]} {incr j} {lappend dic 0}
set nc 5;set out {};set cur [expr {[lindex $syms 0]+1}];set i 1;set start [clock milliseconds]
while {$i<[llength $syms]} {set s [lindex $syms $i];set cand [lindex $dic [expr {$cur*4+$s}]]
 if {$cand!=0} {set cur $cand} else {lappend out $cur
  if {$nc<$DS} {lset dic [expr {$cur*4+$s}] $nc;incr nc};set cur [expr {$s+1}]};incr i}
lappend out $cur;set oc [llength $out];set sm 0;for {set j 0} {$j<$oc} {incr j} {set sm [expr {($sm+[lindex $out $j]*$j)%1000003}]}
set end [clock milliseconds];puts "Result: ${oc}_${sm}";puts "Time: [expr {$end-$start}]ms"