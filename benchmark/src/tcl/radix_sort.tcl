set n 200000
set seed 12345
proc ri {m} {
    global seed
    set seed [expr {($seed * 16807) % 2147483647}]
    return [expr {$seed % $m}]
}

set arr {}
for {set i 0} {$i < $n} {incr i} { lappend arr [ri 1000000] }

set start [clock milliseconds]

set buckets {}
for {set i 0} {$i < 10} {incr i} { lappend buckets 0 }
set output {}
for {set i 0} {$i < $n} {incr i} { lappend output 0 }

for {set p 0} {$p < 6} {incr p} {
    for {set i 0} {$i < 10} {incr i} { lset buckets $i 0 }
    set div [expr {int(pow(10, $p))}]
    for {set i 0} {$i < $n} {incr i} {
        set d [expr {([lindex $arr $i] / $div) % 10}]
        lset buckets $d [expr {[lindex $buckets $d] + 1}]
    }
    for {set i 1} {$i < 10} {incr i} {
        lset buckets $i [expr {[lindex $buckets $i] + [lindex $buckets [expr {$i - 1}]]}]
    }
    for {set i [expr {$n - 1}]} {$i >= 0} {incr i -1} {
        set d [expr {([lindex $arr $i] / $div) % 10}]
        lset buckets $d [expr {[lindex $buckets $d] - 1}]
        lset output [lindex $buckets $d] [lindex $arr $i]
    }
    set tmp $arr; set arr $output; set output $tmp
}

set c 0
for {set i 0} {$i < $n} {incr i} {
    set c [expr {($c + [lindex $arr $i] * ($i % 7)) % 1000003}]
}

set end [clock milliseconds]
puts "Result: [lindex $arr 0]/[lindex $arr [expr {$n-1}]]_${c}"
puts "Time: [expr {$end - $start}]ms"
