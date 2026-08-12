set n 50000; set s [string repeat "a" $n]; set start [clock milliseconds]
set buf {}; for {set i [expr {$n-1}]} {$i >= 0} {incr i -1} {lappend buf [string index $s $i]}
set r [join $buf ""]; set end [clock milliseconds]
puts "Result: [string index $r 0]/[string length $r]"; puts "Time: [expr {$end-$start}]ms"