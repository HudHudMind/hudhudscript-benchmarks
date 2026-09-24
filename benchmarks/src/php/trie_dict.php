<?php
$W=20000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$nodes=1;$children=array_fill(0,26,0);$terminal=[0];
function nc(){global$nodes,$children,$terminal;for($i=0;$i<26;$i++)$children[]=0;$terminal[]=0;return$nodes++;}
$start=hrtime(true);
for($w=0;$w<$W;$w++){$l=3+ri(6);$cur=0;for($j=0;$j<$l;$j++){$c=ri(26);$idx=$cur*26+$c;if($children[$idx]==0)$children[$idx]=nc();$cur=$children[$idx];}$terminal[$cur]=1;}
$hits=0;$seed=12345;
for($w=0;$w<$W;$w++){$l=3+ri(6);$cur=0;for($j=0;$j<$l;$j++){$c=ri(26);$idx=$cur*26+$c;if($children[$idx]==0){$cur=0;break;}$cur=$children[$idx];}if($cur!=0&&$terminal[$cur]==1)$hits++;}
$seed=54321;
for($w=0;$w<$W;$w++){$l=3+ri(6);$cur=0;for($j=0;$j<$l;$j++){$c=ri(26);$idx=$cur*26+$c;if($children[$idx]==0){$cur=0;break;}$cur=$children[$idx];}if($cur!=0&&$terminal[$cur]==1)$hits++;}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$nodes}_{$hits}\n";echo"Time: ".round($ms)."ms\n";
