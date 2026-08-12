<?php
$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
function pm($b,$e,$m){$r=1;while($e>0){if($e&1)$r=($r*$b)%$m;$e>>=1;$b=($b*$b)%$m;}return$r;}
function ip($n){if($n<2)return 0;if($n==2)return 1;if($n%2==0)return 0;
 $d=$n-1;$s=0;while($d%2==0){$d>>=1;$s++;}
 foreach([2,3,5,7]as$a){if($a>=$n)continue;$x=pm($a,$d,$n);if($x==1||$x==$n-1)continue;
  for($r=0;$r<$s-1;$r++){$x=($x*$x)%$n;if($x==$n-1)break;}if($x!=$n-1)return 0;}return 1;}
$K=2000;$cnt=0;$start=hrtime(true);
for($i=0;$i<$K;$i++){$n=1000000001+2*ri(500000000);if(ip($n))$cnt++;}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $cnt\n";echo"Time: ".round($ms)."ms\n";
