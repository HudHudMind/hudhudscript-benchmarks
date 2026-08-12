<?php
$theta=1.0;$omega=0.0;$dt=0.001;$start=hrtime(true);
for($i=0;$i<1000000;$i++){$k1t=$omega;$k1o=-sin($theta);$k2t=$omega+0.5*$dt*$k1o;$k2o=-sin($theta+0.5*$dt*$k1t);$k3t=$omega+0.5*$dt*$k2o;$k3o=-sin($theta+0.5*$dt*$k2t);$k4t=$omega+$dt*$k3o;$k4o=-sin($theta+$dt*$k3t);$theta+=($dt/6.0)*($k1t+2*$k2t+2*$k3t+$k4t);$omega+=($dt/6.0)*($k1o+2*$k2o+2*$k3o+$k4o);}
$end=hrtime(true);$ms=($end-$start)/1e6;printf("Result: %.9f\n",$theta+$omega);echo"Time: ".round($ms)."ms\n";
