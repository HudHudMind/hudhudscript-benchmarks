set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
proc pm {b e m} {set r 1;while {$e>0} {if {$e%2==1} {set r [expr {($r*$b)%$m}]};set e [expr {$e/2}];set b [expr {($b*$b)%$m}]};return $r}
proc ip {n} {if {$n<2} {return 0};if {$n==2} {return 1};if {$n%2==0} {return 0}
 set d [expr {$n-1}];set s 0;while {$d%2==0} {set d [expr {$d/2}];incr s}
 foreach a {2 3 5 7} {if {$a>=$n} {continue};set x [pm $a $d $n];if {$x==1||$x==$n-1} {continue}
  for {set r 0} {$r<$s-1} {incr r} {set x [expr {($x*$x)%$n}];if {$x==$n-1} break};if {$x!=$n-1} {return 0}};return 1}
set K 2000;set cnt 0;set start [clock milliseconds]
for {set i 0} {$i<$K} {incr i} {set n [expr {1000000001+2*[ri 500000000]}];if {[ip $n]} {incr cnt}}
set end [clock milliseconds];puts "Result: $cnt";puts "Time: [expr {$end-$start}]ms"
