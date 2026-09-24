set theta 1.0; set omega 0.0; set dt 0.001
set start [clock milliseconds]
for {set i 0} {$i < 1000000} {incr i} {
    set k1t $omega; set k1o [expr {-sin($theta)}]
    set k2t [expr {$omega + 0.5*$dt*$k1o}]; set k2o [expr {-sin($theta + 0.5*$dt*$k1t)}]
    set k3t [expr {$omega + 0.5*$dt*$k2o}]; set k3o [expr {-sin($theta + 0.5*$dt*$k2t)}]
    set k4t [expr {$omega + $dt*$k3o}]; set k4o [expr {-sin($theta + $dt*$k3t)}]
    set theta [expr {$theta + ($dt/6.0)*($k1t + 2*$k2t + 2*$k3t + $k4t)}]
    set omega [expr {$omega + ($dt/6.0)*($k1o + 2*$k2o + 2*$k3o + $k4o)}]
}
set end [clock milliseconds]
puts [format "Result: %.9f" [expr {$theta+$omega}]]
puts "Time: [expr {$end-$start}]ms"
