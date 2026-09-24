proc power {base exp} {
    set r 1; for {set i 0} {$i < $exp} {incr i} {set r [expr {$r * $base}]}; return $r
}
set R 10000; set sum 0; set start [clock milliseconds]
for {set j 0} {$j < $R} {incr j} {set sum [expr {$sum + [power 2 1000]}]}
set end [clock milliseconds]; puts "Result: $sum"; puts "Time: [expr {$end - $start}]ms"