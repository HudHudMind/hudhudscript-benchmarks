proc mandelbrot {size} {
    set sum_iters 0
    for {set y 0} {$y < $size} {incr y} {
        for {set x 0} {$x < $size} {incr x} {
            set zr 0.0
            set zi 0.0
            set cr [expr {(2.0 * $x / $size) - 1.5}]
            set ci [expr {(2.0 * $y / $size) - 1.0}]
            set escape 0
            for {set i 0} {$i < 50} {incr i} {
                set tr [expr {$zr * $zr - $zi * $zi + $cr}]
                set ti [expr {2.0 * $zr * $zi + $ci}]
                set zr $tr
                set zi $ti
                if {[expr {$zr * $zr + $zi * $zi > 4.0}]} {
                    set escape 1
                    break
                }
            }
            set sum_iters [expr {$sum_iters + $escape}]
        }
    }
    return $sum_iters
}

set start [clock milliseconds]
set res [mandelbrot 500]
set end [clock milliseconds]

puts "Sum: $res"
puts "Time: [expr {$end - $start}]ms"
