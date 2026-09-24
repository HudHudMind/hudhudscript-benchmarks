set hay [string repeat "abcdefghij" 1000]; set needle "defg"
set found 0; set start [clock milliseconds]; set hl [string length $hay]; set nl [string length $needle]
for {set i 0} {$i <= $hl-$nl} {incr i} {set match 1
 for {set j 0} {$j < $nl} {incr j} {if {[string index $hay [expr {$i+$j}]] ne [string index $needle $j]} {set match 0; break}}
 if {$match} {incr found}}
set end [clock milliseconds]; puts "Result: $found"; puts "Time: [expr {$end-$start}]ms"