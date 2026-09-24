my num $theta = 1e0; my num $omega = 0e0; my num $dt = 1e-3;
my $start = now * 1000;
for ^1000000 {
    my num $k1t = $omega; my num $k1o = -sin($theta);
    my num $k2t = $omega + 0.5e0*$dt*$k1o; my num $k2o = -sin($theta + 0.5e0*$dt*$k1t);
    my num $k3t = $omega + 0.5e0*$dt*$k2o; my num $k3o = -sin($theta + 0.5e0*$dt*$k2t);
    my num $k4t = $omega + $dt*$k3o; my num $k4o = -sin($theta + $dt*$k3t);
    $theta += ($dt/6e0)*($k1t + 2e0*$k2t + 2e0*$k3t + $k4t);
    $omega += ($dt/6e0)*($k1o + 2e0*$k2o + 2e0*$k3o + $k4o);
}
my $end = now * 1000;
printf("Result: %.9f\n", $theta + $omega);
say "Time: " ~ ($end - $start).Int ~ "ms";
