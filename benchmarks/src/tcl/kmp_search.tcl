set seed 42
proc rng {} { global seed; set seed [expr {($seed*1103515245+12345)%2147483648}]; return [expr {(($seed-($seed%65536))/65536)%4}] }
set chars "ACGT"; set ta {}; for {set i 0} {$i<500000} {incr i} {lappend ta [string index $chars [rng]]}; set text [join $ta ""]
set patterns {}; for {set i 0} {$i<15} {incr i} {set sp [expr {($seed*16807)%499000}]; set seed [expr {($seed*16807)%2147483647}]; set pl [expr {5+($seed%11)}]; lappend patterns [string range $text $sp [expr {$sp+$pl-1}]]}
for {set i 0} {$i<5} {incr i} {lappend patterns "QQQQQ[expr {($seed*16807)%10}]"; set seed [expr {($seed*16807)%2147483647}]}
set start [clock milliseconds]; set total 0
foreach pat $patterns { set m [string length $pat]; set fail {}; for {set i 0} {$i<$m} {incr i} {lappend fail 0}; set j 0
 for {set i 1} {$i<$m} {incr i} {while {$j>0&&[string index $pat $i] ne [string index $pat $j]} {set j [lindex $fail [expr {$j-1}]]}; if {[string index $pat $i] eq [string index $pat $j]} {incr j}; lset fail $i $j}
 set j 0; for {set i 0} {$i<[string length $text]} {incr i} {set c [string index $text $i]; while {$j>0&&$c ne [string index $pat $j]} {set j [lindex $fail [expr {$j-1}]]}; if {$c eq [string index $pat $j]} {incr j}; if {$j==$m} {incr total; set j [lindex $fail [expr {$j-1}]]}}}
set end [clock milliseconds]; puts "Result: $total"; puts "Time: [expr {$end-$start}]ms"
