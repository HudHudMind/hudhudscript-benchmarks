<?php
$n=200000;$U=400000;$parent=range(0,$n-1);$size=array_fill(0,$n,1);
function find($x,&$parent){while($parent[$x]!=$x)$x=$parent[$x];return $x;}
function union($a,$b,&$parent,&$size){$ra=find($a,$parent);$rb=find($b,$parent);if($ra!=$rb){if($size[$ra]<$size[$rb]){$parent[$ra]=$rb;$size[$rb]+=$size[$ra];}else{$parent[$rb]=$ra;$size[$ra]+=$size[$rb];}}}
$seed=12345;function ri($m){global $seed;$seed=($seed*16807)%2147483647;return $seed%$m;}
$start=hrtime(true);
for($i=0;$i<$U;$i++)union(ri($n),ri($n),$parent,$size);
$roots=0;for($i=0;$i<$n;$i++)if($parent[$i]==$i)$roots++;
$end=hrtime(true);$ms=($end-$start)/1e6;
echo"Result: $roots\n";echo"Time: ".round($ms)."ms\n";
