set PI 3.141592653589793
set SOLAR_MASS [expr {4.0 * $PI * $PI}]
set DAYS_PER_YEAR 365.24

proc advance {bodies_var dt} {
    upvar 1 $bodies_var bodies
    set n [llength $bodies]
    for {set i 0} {$i < $n} {incr i} {
        set bi [lindex $bodies $i]
        for {set j [expr {$i + 1}]} {$j < $n} {incr j} {
            set bj [lindex $bodies $j]
            set dx [expr {[lindex $bi 0] - [lindex $bj 0]}]
            set dy [expr {[lindex $bi 1] - [lindex $bj 1]}]
            set dz [expr {[lindex $bi 2] - [lindex $bj 2]}]
            
            set dsq [expr {$dx*$dx + $dy*$dy + $dz*$dz}]
            set mag [expr {$dt / ($dsq * sqrt($dsq))}]
            
            lset bi 3 [expr {[lindex $bi 3] - $dx * [lindex $bj 6] * $mag}]
            lset bi 4 [expr {[lindex $bi 4] - $dy * [lindex $bj 6] * $mag}]
            lset bi 5 [expr {[lindex $bi 5] - $dz * [lindex $bj 6] * $mag}]
            
            lset bj 3 [expr {[lindex $bj 3] + $dx * [lindex $bi 6] * $mag}]
            lset bj 4 [expr {[lindex $bj 4] + $dy * [lindex $bi 6] * $mag}]
            lset bj 5 [expr {[lindex $bj 5] + $dz * [lindex $bi 6] * $mag}]
            lset bodies $j $bj
        }
        lset bodies $i $bi
    }
    for {set i 0} {$i < $n} {incr i} {
        set bi [lindex $bodies $i]
        lset bi 0 [expr {[lindex $bi 0] + $dt * [lindex $bi 3]}]
        lset bi 1 [expr {[lindex $bi 1] + $dt * [lindex $bi 4]}]
        lset bi 2 [expr {[lindex $bi 2] + $dt * [lindex $bi 5]}]
        lset bodies $i $bi
    }
}

proc energy {bodies} {
    set e 0.0
    set n [llength $bodies]
    for {set i 0} {$i < $n} {incr i} {
        set bi [lindex $bodies $i]
        set e [expr {$e + 0.5 * [lindex $bi 6] * ([lindex $bi 3]*[lindex $bi 3] + [lindex $bi 4]*[lindex $bi 4] + [lindex $bi 5]*[lindex $bi 5])}]
        for {set j [expr {$i + 1}]} {$j < $n} {incr j} {
            set bj [lindex $bodies $j]
            set dx [expr {[lindex $bi 0] - [lindex $bj 0]}]
            set dy [expr {[lindex $bi 1] - [lindex $bj 1]}]
            set dz [expr {[lindex $bi 2] - [lindex $bj 2]}]
            set e [expr {$e - ([lindex $bi 6] * [lindex $bj 6]) / sqrt($dx*$dx + $dy*$dy + $dz*$dz)}]
        }
    }
    return $e
}

set bodies [list \
    [list 0.0 0.0 0.0 0.0 0.0 0.0 $SOLAR_MASS] \
    [list 4.84143144246472090 -1.16032004402742839 -0.103622044471123109 \
     [expr {1.66007664274403694e-03 * $DAYS_PER_YEAR}] [expr {7.69901118419740425e-03 * $DAYS_PER_YEAR}] [expr {-6.90460016972063023e-05 * $DAYS_PER_YEAR}] \
     [expr {9.54791938424326609e-04 * $SOLAR_MASS}]] \
    [list 8.34336671824457987 4.12479856412430479 -0.403523417114321381 \
     [expr {-2.76742510726862411e-03 * $DAYS_PER_YEAR}] [expr {4.99852801234917238e-03 * $DAYS_PER_YEAR}] [expr {2.30417297573763929e-05 * $DAYS_PER_YEAR}] \
     [expr {2.85885980666130812e-04 * $SOLAR_MASS}]] \
    [list 12.8943695621391310 -15.1111514016986312 -0.223307578892655734 \
     [expr {2.96460137564761618e-03 * $DAYS_PER_YEAR}] [expr {2.37847173959480950e-03 * $DAYS_PER_YEAR}] [expr {-2.96589568540237556e-05 * $DAYS_PER_YEAR}] \
     [expr {4.36624404335156298e-05 * $SOLAR_MASS}]] \
    [list 15.3796971148509165 -25.9193146099879641 0.179258772950371181 \
     [expr {2.68067772490389322e-03 * $DAYS_PER_YEAR}] [expr {1.62824170038242295e-03 * $DAYS_PER_YEAR}] [expr {-9.51592254519715870e-05 * $DAYS_PER_YEAR}] \
     [expr {5.15138902046611451e-05 * $SOLAR_MASS}]] \
]

set px 0.0
set py 0.0
set pz 0.0
foreach b $bodies {
    set px [expr {$px + [lindex $b 3] * [lindex $b 6]}]
    set py [expr {$py + [lindex $b 4] * [lindex $b 6]}]
    set pz [expr {$pz + [lindex $b 5] * [lindex $b 6]}]
}
set b0 [lindex $bodies 0]
lset b0 3 [expr {-$px / $SOLAR_MASS}]
lset b0 4 [expr {-$py / $SOLAR_MASS}]
lset b0 5 [expr {-$pz / $SOLAR_MASS}]
lset bodies 0 $b0

set start [clock milliseconds]
set e1 [energy $bodies]
for {set i 0} {$i < 10000} {incr i} {
    advance bodies 0.01
}
set e2 [energy $bodies]
set end [clock milliseconds]

puts [format "Result: %.9f_%.9f" $e1 $e2]
puts "Time: [expr {$end - $start}]ms"
