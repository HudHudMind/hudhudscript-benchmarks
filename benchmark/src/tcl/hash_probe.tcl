set C 65536;set keys {};set vals {};set state {}
for {set i 0} {$i < $C} {incr i} {lappend keys 0;lappend vals 0;lappend state 0}
set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set I 40000;set L 80000;set D 20000;set fnd 0;set dlt 0;set acc 0;set start [clock milliseconds]
for {set j 0} {$j < $I} {incr j} {set k [expr {[ri 1000000]+1}];set h [expr {($k*16807)%$C}];while {[lindex $state $h]==1} {set h [expr {($h+1)%$C}]};lset keys $h $k;lset vals $h [expr {$k%97}];lset state $h 1}
for {set m 0} {$m < $L} {incr m} {set k [expr {[ri 1000000]+1}];set h [expr {($k*16807)%$C}];while {[lindex $state $h]!=0} {if {[lindex $state $h]==1 && [lindex $keys $h]==$k} {incr fnd;set acc [expr {($acc+[lindex $vals $h])%1000003}];break};set h [expr {($h+1)%$C}]}}
for {set n 0} {$n < $D} {incr n} {set k [expr {[ri 1000000]+1}];set h [expr {($k*16807)%$C}];while {[lindex $state $h]!=0} {if {[lindex $state $h]==1 && [lindex $keys $h]==$k} {lset state $h 2;incr dlt;break};set h [expr {($h+1)%$C}]}}
set end [clock milliseconds];puts "Result: ${fnd}_${dlt}_${acc}";puts "Time: [expr {$end-$start}]ms"
