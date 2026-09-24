set n 1000; set a {}; for {set i $n} {$i >= 1} {incr i -1} {lappend a $i}
set start [clock milliseconds]
set stack {}; lappend stack 0; lappend stack [expr {$n-1}]
while {[llength $stack] > 0} {set h [lindex $stack end]; set stack [lrange $stack 0 end-1]; set l [lindex $stack end]; set stack [lrange $stack 0 end-1]
 if {$l < $h} {set pivot [lindex $a $h]; set i [expr {$l-1}]
  for {set j $l} {$j < $h} {incr j} {if {[lindex $a $j] <= $pivot} {incr i; set t [lindex $a $i]; lset a $i [lindex $a $j]; lset a $j $t}}
  incr i; set t [lindex $a $i]; lset a $i [lindex $a $h]; lset a $h $t
  if {[expr {$i-1}] > $l} {lappend stack $l; lappend stack [expr {$i-1}]}
  if {[expr {$i+1}] < $h} {lappend stack [expr {$i+1}]; lappend stack $h}}}
set end [clock milliseconds]; puts "Result: [lindex $a 0]/[lindex $a [expr {$n-1}]]"; puts "Time: [expr {$end-$start}]ms"
