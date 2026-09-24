set N 4096;set PI 3.141592653589793;set re {};set im {}
for {set i 0} {$i<$N} {incr i} {lappend re [expr {sin($i*0.017)+0.5*sin($i*0.31)}];lappend im 0}
set br {};for {set i 0} {$i<$N} {incr i} {set rev 0;set p2 1;for {set j 0} {$j<12} {incr j} {set rev [expr {$rev*2+int($i/$p2)%2}];set p2 [expr {$p2*2}]};lappend br $rev}
set R 50;set fs 0;set start [clock milliseconds]
for {set r 0} {$r<$R} {incr r} {set cr {};set ci {};for {set i 0} {$i<$N} {incr i} {set b [lindex $br $i];lappend cr [lindex $re $b];lappend ci [lindex $im $b]}
 for {set step 2} {$step<=$N} {set step [expr {$step*2}]} {set half [expr {$step/2}];set ang [expr {(-2*$PI)/$step}];set wr [expr {cos($ang)}];set wi [expr {sin($ang)}]
  for {set k 0} {$k<$N} {incr k $step} {set twr 1;set twi 0
   for {set m 0} {$m<$half} {incr m} {set ei [expr {$k+$m}];set oi [expr {$k+$m+$half}];set tr [expr {$twr*[lindex $cr $oi]-$twi*[lindex $ci $oi]}];set ti [expr {$twr*[lindex $ci $oi]+$twi*[lindex $cr $oi]}]
    lset cr $oi [expr {[lindex $cr $ei]-$tr}];lset ci $oi [expr {[lindex $ci $ei]-$ti}];lset cr $ei [expr {[lindex $cr $ei]+$tr}];lset ci $ei [expr {[lindex $ci $ei]+$ti}]
    set nwr $twr;set twr [expr {$nwr*$wr-$twi*$wi}];set twi [expr {$nwr*$wi+$twi*$wr}]}}}
 set sm 0;for {set i 0} {$i<$N} {incr i} {set sm [expr {$sm+[lindex $cr $i]*[lindex $cr $i]+[lindex $ci $i]*[lindex $ci $i]}]};set fs $sm}
set end [clock milliseconds];puts "Result: [expr {round($fs)}]";puts "Time: [expr {$end-$start}]ms"