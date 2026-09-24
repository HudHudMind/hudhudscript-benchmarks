proc my_map {lst body} { set r {}; foreach x $lst { lappend r [apply $body $x] }; return $r }
proc my_filter {lst body} { set r {}; foreach x $lst { if {[apply $body $x]} { lappend r $x } }; return $r }
proc my_reduce {lst body init} { set a $init; foreach x $lst { set a [apply $body $a $x] }; return $a }
set base {}; for {set i 0} {$i < 1000} {incr i} { lappend base $i }
set R 2000; set acc 0; set start [clock milliseconds]
for {set r 0} {$r < $R} {incr r} { set d [my_map $base {{x} {expr {$x * 2 + 1}}}]; set f [my_filter $d {{x} {expr {$x % 3 != 0}}}]; set s [my_reduce $f {{a x} {expr {$a + $x}}} 0]; set acc [expr {($acc + $s + [llength $f]) % 1000003}] }
set end [clock milliseconds]; puts "Result: $acc"; puts "Time: [expr {$end-$start}]ms"
