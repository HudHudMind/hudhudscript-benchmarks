<?php
$N=100000;$Q=10000;$arr=[];for($i=0;$i<$N;$i++)$arr[$i]=2*$i;
$start=hrtime(true);$found=0;
for($j=0;$j<$Q;$j++){$target=20*$j;$left=0;$right=$N-1;
 while($left<=$right){$mid=intdiv($left+$right,2);
  if($arr[$mid]==$target){$found++;break;}
  elseif($arr[$mid]<$target)$left=$mid+1;else $right=$mid-1;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $found\n";echo"Time: ".round($ms)."ms\n";