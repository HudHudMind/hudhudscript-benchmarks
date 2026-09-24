<?php
$n=200;$A=[];for($i=0;$i<$n;$i++){$A[$i]=[];for($j=0;$j<$n;$j++)$A[$i][$j]=(($i*31+$j*17)%100+1)+($i==$j?1000:0);}
$start=hrtime(true);
for($k=0;$k<$n;$k++)for($i=$k+1;$i<$n;$i++){$f=$A[$i][$k]/$A[$k][$k];for($j=0;$j<$n;$j++)$A[$i][$j]-=$f*$A[$k][$j];$A[$i][$k]=$f;}
$s=0;for($i=0;$i<$n;$i++)$s+=$A[$i][$i];$r=round($s/$n*1000);$end=hrtime(true);$ms=($end-$start)/1e6;
echo"Result: $r\n";echo"Time: ".round($ms)."ms\n";