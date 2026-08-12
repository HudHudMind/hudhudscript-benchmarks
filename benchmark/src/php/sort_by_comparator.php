<?php
$N=20000;$arr=[];$seed=12345;for($i=0;$i<$N;$i++){$seed=($seed*16807)%2147483647;$arr[]=$seed%1000000;}
function qs(&$a,$l,$h,$cmp){if($l>=$h)return;$s=[$l,$h];while($s){$h2=array_pop($s);$l2=array_pop($s);if($l2>=$h2)continue;$p=$a[(int)(($l2+$h2)/2)];$i2=$l2;$j2=$h2;while($i2<=$j2){while($cmp($a[$i2],$p)<0)$i2++;while($cmp($a[$j2],$p)>0)$j2--;if($i2<=$j2){$t=$a[$i2];$a[$i2]=$a[$j2];$a[$j2]=$t;$i2++;$j2--;}}if($l2<$j2){$s[]=$l2;$s[]=$j2;}if($i2<$h2){$s[]=$i2;$s[]=$h2;}}}
$asc=fn($a,$b)=>$a-$b;$desc=fn($a,$b)=>$b-$a;
$start=hrtime(true);$c1=$arr;qs($c1,0,$N-1,$asc);$c2=$arr;qs($c2,0,$N-1,$desc);$r1=$r2=0;
for($i=0;$i<$N;$i++){$r1=($r1+$c1[$i]*($i%7))%1000003;$r2=($r2+$c2[$i]*($i%7))%1000003;}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$r1}_{$r2}\n";echo"Time: ".round($ms)."ms\n";
