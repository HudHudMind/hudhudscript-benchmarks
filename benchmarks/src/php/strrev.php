<?php
$n=50000;$s=str_repeat("a",$n);$start=hrtime(true);
$buf=[];for($i=$n-1;$i>=0;$i--)$buf[]=$s[$i];$r=implode("",$buf);
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: ".$r[0]."/".strlen($r)."\n";echo"Time: ".round($ms)."ms\n";