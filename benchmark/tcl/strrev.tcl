set s [string repeat "a" 50000]
set start [clock milliseconds]
set rev ""
set len [string length $s]
for {set j [expr {$len - 1}]} {$j >= 0} {incr j -1} {
    append rev [string index $s $j]
}
set end [clock milliseconds]
puts "Len: [string length $rev]"
puts "Time: [expr {$end - $start}]ms"
