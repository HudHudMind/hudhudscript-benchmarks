use Time::HiRes qw(time);
my($theta,$omega,$dt)=(1.0,0.0,0.001);my$start=time();
for(1..1000000){my$k1t=$omega;my$k1o=-sin($theta);my$k2t=$omega+0.5*$dt*$k1o;my$k2o=-sin($theta+0.5*$dt*$k1t);my$k3t=$omega+0.5*$dt*$k2o;my$k3o=-sin($theta+0.5*$dt*$k2t);my$k4t=$omega+$dt*$k3o;my$k4o=-sin($theta+$dt*$k3t);$theta+=($dt/6.0)*($k1t+2*$k2t+2*$k3t+$k4t);$omega+=($dt/6.0)*($k1o+2*$k2o+2*$k3o+$k4o)}
my$end=time();my$ms=($end-$start)*1000;printf"Result: %.9f\n",$theta+$omega;printf"Time: %.0fms\n",$ms;
