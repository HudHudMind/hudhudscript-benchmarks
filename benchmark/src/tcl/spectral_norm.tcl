proc eval_A {i j} {
    return [expr {1.0 / ((($i + $j) * ($i + $j + 1) / 2) + $i + 1)}]
}

proc eval_A_times_u {u v_var n} {
    upvar 1 $v_var v
    for {set i 0} {$i < $n} {incr i} {
        lset v $i 0.0
        for {set j 0} {$j < $n} {incr j} {
            lset v $i [expr {[lindex $v $i] + [eval_A $i $j] * [lindex $u $j]}]
        }
    }
}

proc eval_At_times_u {u v_var n} {
    upvar 1 $v_var v
    for {set i 0} {$i < $n} {incr i} {
        lset v $i 0.0
        for {set j 0} {$j < $n} {incr j} {
            lset v $i [expr {[lindex $v $i] + [eval_A $j $i] * [lindex $u $j]}]
        }
    }
}

proc eval_AtA_times_u {u v_var w_var n} {
    upvar 1 $v_var v
    upvar 1 $w_var w
    eval_A_times_u $u w $n
    eval_At_times_u $w v $n
}

set start [clock milliseconds]
set n 150
set u {}
set v {}
set w {}
for {set i 0} {$i < $n} {incr i} {
    lappend u 1.0
    lappend v 0.0
    lappend w 0.0
}

for {set i 0} {$i < 10} {incr i} {
    eval_AtA_times_u $u v w $n
    eval_AtA_times_u $v u w $n
}

set vBv 0.0
set vv 0.0
for {set i 0} {$i < $n} {incr i} {
    set vBv [expr {$vBv + [lindex $u $i] * [lindex $v $i]}]
    set vv [expr {$vv + [lindex $v $i] * [lindex $v $i]}]
}

set res [expr {sqrt($vBv / $vv)}]
set end [clock milliseconds]

puts [format "Result: %.9f" $res]
puts "Time: [expr {$end - $start}]ms"
