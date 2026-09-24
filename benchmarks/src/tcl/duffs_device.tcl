proc duffs_device {aName bName count} {
    upvar 1 $aName a $bName b
    
    set n [expr {$count / 8}]
    set rem [expr {$count % 8}]
    set i 0
    
    while {$rem > 0} {
        lset a $i [lindex $b $i]
        incr i
        incr rem -1
    }
    
    while {$n > 0} {
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        lset a $i [lindex $b $i]; incr i
        incr n -1
    }
    return [lindex $a [expr {$count - 1}]]
}

set a {}; set b {}
for {set i 0} {$i < 100000} {incr i} {lappend a 0; lappend b 1}
set start [clock milliseconds]
set res 0
for {set k 0} {$k < 100} {incr k} {
    set res [duffs_device a b 100000]
}
set end [clock milliseconds]

puts "Result: $res"
puts "Time: [expr {$end - $start}]ms"
