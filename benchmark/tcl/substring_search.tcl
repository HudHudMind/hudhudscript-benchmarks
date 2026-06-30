set s "[string repeat a 50000]b"; set start [clock milliseconds]; set c 0
for {set i 0} {$i < 1000} {incr i} { set idx [string first "b" $s]; if {$idx != -1} { incr c } }
set end [clock milliseconds]; puts "Found: $c"; puts "Time: [expr {$end - $start}]ms"