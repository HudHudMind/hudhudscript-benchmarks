proc asc {a b} {expr {$a - $b}}
proc desc {a b} {expr {$b - $a}}

proc quicksort {a_name low high cmp} {
    upvar $a_name a
    if {$low >= $high} {return}
    set stack [list $low $high]
    while {[llength $stack] > 0} {
        set h [lindex $stack end]; set stack [lrange $stack 0 end-1]
        set l [lindex $stack end]; set stack [lrange $stack 0 end-1]
        if {$l >= $h} {continue}
        set pivot [lindex $a [expr {($l+$h)/2}]]
        set i2 $l; set j2 $h
        while {$i2 <= $j2} {
            while {[$cmp [lindex $a $i2] $pivot] < 0} {incr i2}
            while {[$cmp [lindex $a $j2] $pivot] > 0} {incr j2 -1}
            if {$i2 <= $j2} {
                set t [lindex $a $i2]; lset a $i2 [lindex $a $j2]; lset a $j2 $t
                incr i2; incr j2 -1
            }
        }
        if {$l < $j2} {lappend stack $l $j2}
        if {$i2 < $h} {lappend stack $i2 $h}
    }
}

set N 20000; set arr {}; set seed 12345
for {set i 0} {$i < $N} {incr i} {set seed [expr {($seed*16807)%2147483647}]; lappend arr [expr {$seed%1000000}]}
set start [clock milliseconds]
set copy1 $arr; quicksort copy1 0 [expr {$N-1}] asc
set copy2 $arr; quicksort copy2 0 [expr {$N-1}] desc
set c1 0; set c2 0
for {set i 0} {$i < $N} {incr i} {set c1 [expr {($c1 + [lindex $copy1 $i] * ($i%7)) % 1000003}]; set c2 [expr {($c2 + [lindex $copy2 $i] * ($i%7)) % 1000003}]}
set end [clock milliseconds]
puts "Result: ${c1}_${c2}"; puts "Time: [expr {$end-$start}]ms"
