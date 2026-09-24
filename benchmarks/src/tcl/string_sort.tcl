set N 20000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set arr {};for {set i 0} {$i < $N} {incr i} {lappend arr "w[ri 100000]"}
proc ms {a} {set sz [llength $a];if {$sz <= 1} {return $a};set md [expr {$sz/2}];set L [ms [lrange $a 0 [expr {$md-1}]]];set R [ms [lrange $a $md end]];set res {};set pi 0;set qi 0
 while {$pi < [llength $L]} {if {$qi >= [llength $R]} {break};if {[lindex $L $pi] <= [lindex $R $qi]} {lappend res [lindex $L $pi];incr pi} else {lappend res [lindex $R $qi];incr qi}}
 while {$pi < [llength $L]} {lappend res [lindex $L $pi];incr pi};while {$qi < [llength $R]} {lappend res [lindex $R $qi];incr qi};return $res}
set start [clock milliseconds];set s [ms $arr];set acc 0;for {set i 0} {$i < $N} {incr i} {set acc [expr {($acc+[string length [lindex $s $i]]*($i%13))%1000003}]}
set end [clock milliseconds];puts "Result: $acc";puts "Time: [expr {$end-$start}]ms"
