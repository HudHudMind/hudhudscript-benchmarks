set R 20000;set seed 12345;proc ri {m} {global seed;set seed [expr {($seed*16807)%2147483647}];return [expr {$seed%$m}]}
set parts {};for {set i 0} {$i<$R} {incr i} {set id [ri 100000];set tag [ri 1000];set si [ri 1000];set sf [ri 100]
 lappend parts "\{"id\":$id,\"tag\":\"w$tag\",\"ok\":true,\"score\":$si.$sf\}";if {$i<$R-1} {lappend parts ,}}
set line "\[";foreach p $parts {append line $p};append line "\]"
set st 0;set ss 0;set num 0;set kw 0;set pos 0;set L [string length $line];set start [clock milliseconds]
while {$pos<$L} {set c [string index $line $pos]
 if {[string first $c "\{\}\[\]:,"]>=0} {incr st;incr pos
 } elseif {$c eq "\""} {incr ss;incr pos;while {$pos<$L&&[string index $line $pos] ne "\""} {incr pos};incr pos
 } elseif {[string first $c "tfn"]>=0} {incr kw;incr pos 4;if {$c in "fn"} {incr pos}
 } else {incr num;while {$pos<$L&&[string first [string index $line $pos] ",}\"]"]<0} {incr pos}}}
set end [clock milliseconds];puts "Result: ${st}_${ss}_${num}_${kw}";puts "Time: [expr {$end-$start}]ms"