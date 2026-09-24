set seed 12345; set line ""
for {set j 0} {$j < 40} {incr j} {set seed [expr {($seed*16807)%2147483647}]; set fn [expr {($seed%1000)+100}]; append line "f$fn"; if {$j<39} {append line ","}}
set R 10000; set sp 0; set si 0; set ss 0; set start [clock milliseconds]
for {set r 0} {$r < $R} {incr r} {set parts [split $line ","]; set plen [llength $parts]; foreach p $parts {incr sp $plen; set idx [string first "f" $p]; incr si $idx; if {[string length $p]>=4} {incr ss [string length [string range $p 1 2]]}}}
set acc [expr {($sp%1000003 + $si%1000003 + $ss%1000003) % 1000003}]; set end [clock milliseconds]
puts "Result: $acc"; puts "Time: [expr {$end-$start}]ms"
