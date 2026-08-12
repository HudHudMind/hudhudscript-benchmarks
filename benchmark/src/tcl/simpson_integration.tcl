proc f {x} {return [expr {$x*$x*$x-2*$x*$x+3}]}
set N 2000000;set h [expr {10.0/$N}];set s [expr {[f 0]+[f 10]}];set start [clock milliseconds]
for {set i 1} {$i < $N} {incr i} {set x [expr {$i*$h}];if {$i%2==0} {set s [expr {$s+2*[f $x]}]} else {set s [expr {$s+4*[f $x]}]}}
set r [expr {$s*$h/3}];set end [clock milliseconds];puts "Result: $r";puts "Time: [expr {$end-$start}]ms"
