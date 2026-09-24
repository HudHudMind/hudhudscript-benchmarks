<?php
$T=300000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$pq=[];$qh=0;$wq=[];$wh=0;$sq=[];$sh=0;$made=$acc=$sunk=0;$start=hrtime(true);
for($t=0;$t<$T;$t++){$made++;if($made%3!=0)$wq[]=$made%100;
 if($wh<count($wq)){$pkt=$wq[$wh];$wh++;$acc=($acc+$pkt*7)%1000003;if($pkt>50)$sq[]=$pkt;}
 if($sh<count($sq)){$sh++;$sunk++;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$made}_{$acc}_{$sunk}\n";echo"Time: ".round($ms)."ms\n";
