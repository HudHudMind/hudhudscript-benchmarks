set T 300000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set pq {};set qh 0;set wq {};set wh 0;set sq {};set sh 0;set made 0;set acc 0;set sunk 0;set start [clock milliseconds]
for {set t 0} {$t<$T} {incr t} {incr made;if {$made%3!=0} {lappend wq [expr {$made%100}]}
 if {$wh<[llength $wq]} {set pkt [lindex $wq $wh];incr wh;set acc [expr {($acc+$pkt*7)%1000003}];if {$pkt>50} {lappend sq $pkt}}
 if {$sh<[llength $sq]} {incr sh;incr sunk}}
set end [clock milliseconds];puts "Result: ${made}_${acc}_${sunk}";puts "Time: [expr {$end-$start}]ms"
