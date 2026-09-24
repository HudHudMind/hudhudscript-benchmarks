set n 20000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set et {};set ew {};set deg {};set sof {}
for {set i 0} {$i<$n} {incr i} {lappend deg 0;lappend sof 0}
for {set i 0} {$i<$n} {incr i} {lappend et [expr {($i+1)%$n}];lappend ew [expr {1+[ri 9]}];lset deg $i [expr {[lindex $deg $i]+1}]}
for {set i 0} {$i<$n} {incr i} {for {set j 0} {$j<5} {incr j} {set t [ri $n];lappend et $t;lappend ew [expr {1+[ri 99]}];lset deg $i [expr {[lindex $deg $i]+1}]}}
set off 0;for {set i 0} {$i<$n} {incr i} {lset sof $i $off;incr off [lindex $deg $i]}
set hd {};set hn {};set hsz 0
proc hp {d nd} {global hd hn hsz;if {$hsz<[llength $hn]} {lset hn $hsz $nd;lset hd $hsz $d} else {lappend hn $nd;lappend hd $d};set i2 $hsz;incr hsz
 while {$i2>0} {set p [expr {($i2-1)/2}];if {[lindex $hd $p]<=[lindex $hd $i2]} break
  set t [lindex $hd $i2];lset hd $i2 [lindex $hd $p];lset hd $p $t;set t [lindex $hn $i2];lset hn $i2 [lindex $hn $p];lset hn $p $t;set i2 $p}}
proc hpop {} {global hd hn hsz;if {$hsz==0} {return -1};set r [lindex $hn 0];incr hsz -1;lset hn 0 [lindex $hn $hsz];lset hd 0 [lindex $hd $hsz];set i2 0
 while 1 {set l [expr {2*$i2+1}];set r2 [expr {2*$i2+2}];set s $i2;if {$l<$hsz&&[lindex $hd $l]<[lindex $hd $s]} {set s $l};if {$r2<$hsz&&[lindex $hd $r2]<[lindex $hd $s]} {set s $r2};if {$s==$i2} break
  set t [lindex $hd $i2];lset hd $i2 [lindex $hd $s];lset hd $s $t;set t [lindex $hn $i2];lset hn $i2 [lindex $hn $s];lset hn $s $t;set i2 $s};return $r}
set INF 999999999;set dist {};set vis {};for {set i 0} {$i<$n} {incr i} {lappend dist $INF;lappend vis 0};lset dist 0 0;hp 0 0;set start [clock milliseconds]
while {$hsz>0} {set u [hpop];if {$u<0} break;if {[lindex $vis $u]==1} continue;lset vis $u 1;set d [lindex $dist $u];set base [lindex $sof $u]
 for {set k 0} {$k<[lindex $deg $u]} {incr k} {set v [lindex $et [expr {$base+$k}]];set w [lindex $ew [expr {$base+$k}]];set nd [expr {$d+$w}];if {$nd<[lindex $dist $v]} {lset dist $v $nd;hp $nd $v}}}
set sm 0;for {set i 0} {$i<$n} {incr i} {incr sm [lindex $dist $i]};set end [clock milliseconds];puts "Result: [expr {$sm%1000003}]";puts "Time: [expr {$end-$start}]ms"
