set W 20000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set nodes 1;set children {};for {set i 0} {$i<26} {incr i} {lappend children 0};set terminal {0}
proc nc {} {global nodes children terminal;for {set i 0} {$i<26} {incr i} {lappend children 0};lappend terminal 0;incr nodes;return [expr {$nodes-1}]}
set start [clock milliseconds]
for {set w 0} {$w<$W} {incr w} {set l [expr {3+[ri 6]}];set cur 0;for {set j 0} {$j<$l} {incr j} {set c [ri 26];set idx [expr {$cur*26+$c}];if {[lindex $children $idx]==0} {lset children $idx [nc]};set cur [lindex $children $idx]};lset terminal $cur 1}
set hits 0;set seed 12345
for {set w 0} {$w<$W} {incr w} {set l [expr {3+[ri 6]}];set cur 0;for {set j 0} {$j<$l} {incr j} {set c [ri 26];set idx [expr {$cur*26+$c}];if {[lindex $children $idx]==0} {set cur 0;break};set cur [lindex $children $idx]};if {$cur!=0&&[lindex $terminal $cur]==1} {incr hits}}
set seed 54321
for {set w 0} {$w<$W} {incr w} {set l [expr {3+[ri 6]}];set cur 0;for {set j 0} {$j<$l} {incr j} {set c [ri 26];set idx [expr {$cur*26+$c}];if {[lindex $children $idx]==0} {set cur 0;break};set cur [lindex $children $idx]};if {$cur!=0&&[lindex $terminal $cur]==1} {incr hits}}
set end [clock milliseconds];puts "Result: ${nodes}_${hits}";puts "Time: [expr {$end-$start}]ms"
