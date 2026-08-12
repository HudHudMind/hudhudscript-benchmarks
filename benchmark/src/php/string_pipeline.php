<?php
$seed=12345;$line="";for($j=0;$j<40;$j++){$seed=($seed*16807)%2147483647;$fn=($seed%1000)+100;$line.="f$fn";if($j<39)$line.=",";}
$R=10000;$sp=$si=$ss=0;$start=hrtime(true);
for($r=0;$r<$R;$r++){$parts=explode(",",$line);foreach($parts as $p){$sp+=count($parts);$idx=strpos($p,"f");$si+=$idx!==false?$idx:0;if(strlen($p)>=4)$ss+=strlen(substr($p,1,2));}}
$acc=(($sp%1000003)+($si%1000003)+($ss%1000003))%1000003;$end=hrtime(true);$ms=($end-$start)/1e6;
echo"Result: $acc\n";echo"Time: ".round($ms)."ms\n";
