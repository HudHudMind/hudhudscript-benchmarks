<?php
$M=500000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$dict=[];for($i=0;$i<2000;$i++)$dict[]="w$i";$counts=[];foreach($dict as$w)$counts[$w]=0;
$start=hrtime(true);
for($i=0;$i<$M;$i++)$counts[$dict[ri(2000)]]++;
$mc=0;$mw="";foreach($dict as$w){$v=$counts[$w];if($mc==0){$mc=$v;$mw=$w;}elseif($v>$mc){$mc=$v;$mw=$w;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$mc}_{$mw}\n";echo"Time: ".round($ms)."ms\n";
