<?php
$n=100000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$sz=$n+10;$key=array_fill(0,$sz,0);$left=array_fill(0,$sz,0);$right=array_fill(0,$sz,0);$height=array_fill(0,$sz,0);$nodes=0;
function newNode($k){global$nodes,$key,$left,$right,$height;$nodes++;$key[$nodes]=$k;$left[$nodes]=0;$right[$nodes]=0;$height[$nodes]=1;return$nodes;}
function getH($nd){global$height;return$nd==0?0:$height[$nd];}
function updH($nd){global$left,$right,$height;$hl=getH($left[$nd]);$hr=getH($right[$nd]);$height[$nd]=($hl>$hr?$hl:$hr)+1;}
function bal($nd){global$left,$right;return getH($left[$nd])-getH($right[$nd]);}
function rotR($y){global$left,$right;$x=$left[$y];$T=$right[$x];$right[$x]=$y;$left[$y]=$T;updH($y);updH($x);return$x;}
function rotL($x){global$left,$right;$y=$right[$x];$T=$left[$y];$left[$y]=$x;$right[$x]=$T;updH($x);updH($y);return$y;}
function insert($nd,$k){global$key,$left,$right;if($nd==0)return newNode($k);
if($k<$key[$nd])$left[$nd]=insert($left[$nd],$k);elseif($k>$key[$nd])$right[$nd]=insert($right[$nd],$k);else return$nd;
updH($nd);$b=bal($nd);
if($b>1&&$k<$key[$left[$nd]])return rotR($nd);if($b<-1&&$k>$key[$right[$nd]])return rotL($nd);
if($b>1&&$k>$key[$left[$nd]]){$left[$nd]=rotL($left[$nd]);return rotR($nd);}
if($b<-1&&$k<$key[$right[$nd]]){$right[$nd]=rotR($right[$nd]);return rotL($nd);}
return$nd;}
$root=0;for($i=0;$i<$n;$i++)$root=insert($root,ri(1000000));
$start=hrtime(true);$c=0;$idx=0;$stack=[];$cur=$root;
while(count($stack)>0||$cur!=0){while($cur!=0){$stack[]=$cur;$cur=$left[$cur];}$cur=array_pop($stack);$c=($c+$key[$cur]*($idx%13))%1000003;$idx++;$cur=$right[$cur];}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$height[$root]}_{$c}
";echo"Time: ".round($ms)."ms
";