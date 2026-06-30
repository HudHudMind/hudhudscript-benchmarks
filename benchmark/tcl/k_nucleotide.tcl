proc generate_dna {length} {
    set chars [list A C G T]
    set seq ""
    set seed 42
    for {set i 0} {$i < $length} {incr i} {
        set seed [expr {($seed * 1103515245 + 12345) & 0x7fffffff}]
        set idx [expr {($seed >> 16) % 4}]
        append seq [lindex $chars $idx]
    }
    return $seq
}

proc count_frequencies {dna k} {
    array set freqs {}
    set n [expr {[string length $dna] - $k + 1}]
    for {set i 0} {$i < $n} {incr i} {
        set sub [string range $dna $i [expr {$i + $k - 1}]]
        if {[info exists freqs($sub)]} {
            incr freqs($sub)
        } else {
            set freqs($sub) 1
        }
    }
    return [array size freqs]
}

set start [clock milliseconds]
set dna [generate_dna 100000]
set c1 [count_frequencies $dna 1]
set c2 [count_frequencies $dna 2]
set c3 [count_frequencies $dna 3]

set res [expr {$c1 + $c2 + $c3}]
set end [clock milliseconds]

puts "Count: $res"
puts "Time: [expr {$end - $start}]ms"
