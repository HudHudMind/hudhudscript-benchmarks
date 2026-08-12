<?php
$C=65536;$keys=array_fill(0,$C,0);$vals=array_fill(0,$C,0);$state=array_fill(0,$C,0);
$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$I=40000;$L=80000;$D=20000;$fnd=$dlt=$acc=0;$start=hrtime(true);
for($j=0;$j<$I;$j++){$k=ri(1000000)+1;$h=($k*16807)%$C;while($state[$h]==1)$h=($h+1)%$C;$keys[$h]=$k;$vals[$h]=$k%97;$state[$h]=1;}
for($m=0;$m<$L;$m++){$k=ri(1000000)+1;$h=($k*16807)%$C;while($state[$h]!=0){if($state[$h]==1&&$keys[$h]==$k){$fnd++;$acc=($acc+$vals[$h])%1000003;break;}$h=($h+1)%$C;}}
for($n=0;$n<$D;$n++){$k=ri(1000000)+1;$h=($k*16807)%$C;while($state[$h]!=0){if($state[$h]==1&&$keys[$h]==$k){$state[$h]=2;$dlt++;break;}$h=($h+1)%$C;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$fnd}_{$dlt}_{$acc}\n";echo"Time: ".round($ms)."ms\n";
