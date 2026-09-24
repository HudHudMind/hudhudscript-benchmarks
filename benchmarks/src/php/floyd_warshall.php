<?php
$n=150;$INF=999999999;$dist=array_fill(0,$n,array_fill(0,$n,$INF));for($i=0;$i<$n;$i++)$dist[$i][$i]=0;
$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
for($i=0;$i<$n;$i++)for($j=0;$j<4;$j++){$t=($i*7+$j*13+1)%$n;if($t!=$i)$dist[$i][$t]=1+(($i+$j)%50);}
$start=hrtime(true);
for($k=0;$k<$n;$k++)for($i=0;$i<$n;$i++){$dik=$dist[$i][$k];if($dik!=$INF)for($j=0;$j<$n;$j++){$nd=$dik+$dist[$k][$j];if($nd<$dist[$i][$j])$dist[$i][$j]=$nd;}}
$reach=$sm=0;for($i=0;$i<$n;$i++)for($j=0;$j<$n;$j++)if($dist[$i][$j]<$INF){$reach++;$sm+=$dist[$i][$j];}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$reach}_".($sm%1000003)."\n";echo"Time: ".round($ms)."ms\n";
