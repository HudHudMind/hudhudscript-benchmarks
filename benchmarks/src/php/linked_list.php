<?php
$N=100000;$seed=12345;$acc=0;$start=hrtime(true);
$head=null;for($i=0;$i<$N;$i++){$seed=($seed*16807)%2147483647;$head=["value"=>$seed%10000,"next"=>$head];}
$prev=null;$cur=$head;for($i=0;$i<$N;$i++){$nxt=$cur["next"];$cur["next"]=$prev;$prev=$cur;$cur=$nxt;}
$pos=0;$walk=$prev;for($i=0;$i<$N;$i++){$acc=($acc+$walk["value"]*$pos)%1000003;$pos++;$walk=$walk["next"];}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $acc\n";echo"Time: ".round($ms)."ms\n";
