proc lcs {X Y m n} { array set L {}; for {set i 0} {$i <= $m} {incr i} { for {set j 0} {$j <= $n} {incr j} {
        if {$i == 0 || $j == 0} { set L($i,$j) 0 } elseif {[string index $X [expr {$i-1}]] eq [string index $Y [expr {$j-1}]]} {
        set L($i,$j) [expr {$L([expr {$i-1}],[expr {$j-1}]) + 1}] } else {
        set a $L([expr {$i-1}],$j); set b $L($i,[expr {$j-1}]); if {$a > $b} { set L($i,$j) $a } else { set L($i,$j) $b } } } }; return $L($m,$n) }
set start [clock milliseconds]; set S1 "[string repeat A 50][string repeat B 50]"; set S2 "[string repeat B 50][string repeat C 50]"
set res 0; for {set i 0} {$i < 10} {incr i} { set res [lcs $S1 $S2 100 100] }
set end [clock milliseconds]; puts "LCS Length: $res"; puts "Time: [expr {$end - $start}]ms"