set n 1000; set a {}; for {set i $n} {$i >= 1} {incr i -1} {lappend a $i}
set start [clock milliseconds]
set width 1
while {$width < $n} {
    set i 0
    while {$i < $n} {
        set mid [expr {$i + $width}]
        if {$mid >= $n} {incr i [expr {2 * $width}]; continue}
        set end [expr {$i + 2 * $width < $n ? $i + 2 * $width : $n}]
        set L {}; for {set x $i} {$x < $mid} {incr x} {lappend L [lindex $a $x]}
        set R {}; for {set x $mid} {$x < $end} {incr x} {lappend R [lindex $a $x]}
        set li 0; set ri 0; set ai $i
        while {$li < [llength $L] && $ri < [llength $R]} {
            if {[lindex $L $li] <= [lindex $R $ri]} {lset a $ai [lindex $L $li]; incr li} else {lset a $ai [lindex $R $ri]; incr ri}
            incr ai
        }
        while {$li < [llength $L]} {lset a $ai [lindex $L $li]; incr li; incr ai}
        while {$ri < [llength $R]} {lset a $ai [lindex $R $ri]; incr ri; incr ai}
        incr i [expr {2 * $width}]
    }
    set width [expr {$width * 2}]
}
set end [clock milliseconds]
puts "Result: [lindex $a 0]/$n"
puts "Time: [expr {$end - $start}]ms"