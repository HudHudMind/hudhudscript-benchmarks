<?php
$N=20000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$arr=[];for($i=0;$i<$N;$i++)$arr[]="w".ri(100000);
function ms($a){if(count($a)<=1)return$a;$m=intdiv(count($a),2);$L=ms(array_slice($a,0,$m));$R=ms(array_slice($a,$m));$res=[];$pi=$qi=0;
 while($pi<count($L)){if($qi>=count($R))break;if($L[$pi]<=$R[$qi])$res[]=$L[$pi++];else$res[]=$R[$qi++];}
 while($pi<count($L))$res[]=$L[$pi++];while($qi<count($R))$res[]=$R[$qi++];return$res;}
$start=hrtime(true);$s=ms($arr);$acc=0;for($i=0;$i<$N;$i++)$acc=($acc+strlen($s[$i])*($i%13))%1000003;
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $acc\n";echo"Time: ".round($ms)."ms\n";
