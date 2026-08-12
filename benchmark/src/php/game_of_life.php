<?php
$G=96;$T=100;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$a=array_fill(0,$G,[]);$b=array_fill(0,$G,[]);for($i=0;$i<$G;$i++)for($j=0;$j<$G;$j++){$a[$i][$j]=ri(100)<35?1:0;$b[$i][$j]=0;}
$start=hrtime(true);
for($t=0;$t<$T;$t++){for($i=0;$i<$G;$i++)for($j=0;$j<$G;$j++){$nbr=0;
 for($di=-1;$di<=1;$di++)for($dj=-1;$dj<=1;$dj++){if(!($di==0&&$dj==0))$nbr+=$a[($i+$di+$G)%$G][($j+$dj+$G)%$G];}
 $b[$i][$j]=($a[$i][$j]==1&&($nbr==2||$nbr==3))||($a[$i][$j]==0&&$nbr==3)?1:0;}
 $t2=$a;$a=$b;$b=$t2;}
$alive=0;for($i=0;$i<$G;$i++)for($j=0;$j<$G;$j++)$alive+=$a[$i][$j];
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $alive\n";echo"Time: ".round($ms)."ms\n";
