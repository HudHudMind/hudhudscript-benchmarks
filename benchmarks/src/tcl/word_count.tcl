set M 500000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set dict {};for {set i 0} {$i < 2000} {incr i} {lappend dict "w$i"}
array set counts {};foreach w $dict {set counts($w) 0}
set start [clock milliseconds]
for {set i 0} {$i < $M} {incr i} {set w [lindex $dict [ri 2000]];incr counts($w)}
set mc 0;set mw "";foreach w $dict {set v $counts($w);if {$mc==0} {set mc $v;set mw $w} elseif {$v>$mc} {set mc $v;set mw $w}}
set end [clock milliseconds];puts "Result: ${mc}_${mw}";puts "Time: [expr {$end-$start}]ms"
