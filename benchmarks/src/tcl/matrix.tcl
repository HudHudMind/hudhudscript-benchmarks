set n 150; set A {}; set B {}; set C {}
for {set i 0} {$i < $n} {incr i} { set ra {}; set rb {}; set rc {}
 for {set j 0} {$j < $n} {incr j} { lappend ra [expr {$i+$j}]; lappend rb [expr {$i-$j}]; lappend rc 0 }
 lappend A $ra; lappend B $rb; lappend C $rc }
set start [clock milliseconds]
for {set i 0} {$i < $n} {incr i} { for {set j 0} {$j < $n} {incr j} { for {set k 0} {$k < $n} {incr k} {
 lset C $i $j [expr {[lindex $C $i $j] + [lindex $A $i $k] * [lindex $B $k $j]}] } } }
set end [clock milliseconds]
puts "Result: [lindex $C 0 0]/[lindex $C [expr {$n-1}] [expr {$n-1}]]"
puts "Time: [expr {$end-$start}]ms"
