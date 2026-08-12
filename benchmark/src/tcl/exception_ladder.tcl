proc f3 {i} {if {$i%7==0} {error "boom"};return [expr {$i*2}]}
proc f2 {i} {return [f3 $i]}
proc f1 {i} {return [f2 $i]}
set N 200000;set acc 0;set caught 0;set start [clock milliseconds]
for {set i 1} {$i <= $N} {incr i} {if {[catch {set res [f1 $i]}]} {incr caught} {set acc [expr {($acc+$res)%1000003}]}}
set end [clock milliseconds];puts "Result: ${acc}_${caught}";puts "Time: [expr {$end-$start}]ms"
