<?php
function f($x){return$x*$x*$x-2*$x*$x+3;}
$N=2000000;$h=10/$N;$s=f(0)+f(10);$start=hrtime(true);
for($i=1;$i<$N;$i++){$x=$i*$h;$s+=$i%2==0?2*f($x):4*f($x);}
$r=$s*$h/3;$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $r\n";echo"Time: ".round($ms)."ms\n";
