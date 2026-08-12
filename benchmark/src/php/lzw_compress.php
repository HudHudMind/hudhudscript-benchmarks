<?php
$M=400000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$syms=[];$i=0;
while($i<$M){if($i>=20&&ri(10)<4){$s=$i-20;for($j=0;$j<20;$j++){$syms[]=$syms[$s+$j];}$i+=20;}else{$syms[]=ri(4);$i++;}}
$DS=4096;$dic=array_fill(0,$DS*4,0);$nc=5;$out=[];$cur=$syms[0]+1;$i=1;$start=hrtime(true);
while($i<count($syms)){$s=$syms[$i];$cand=$dic[$cur*4+$s];if($cand!=0)$cur=$cand;else{$out[]=$cur;
 if($nc<$DS){$dic[$cur*4+$s]=$nc;$nc++;}$cur=$s+1;}$i++;}
$out[]=$cur;$oc=count($out);$sm=0;for($j=0;$j<$oc;$j++)$sm=($sm+$out[$j]*$j)%1000003;
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$oc}_{$sm}\n";echo"Time: ".round($ms)."ms\n";
