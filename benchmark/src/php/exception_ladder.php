<?php
function f3($i){if($i%7==0)throw new Exception("boom");return$i*2;}
function f2($i){return f3($i);}
function f1($i){return f2($i);}
$N=200000;$acc=$caught=0;$start=hrtime(true);
for($i=1;$i<=$N;$i++){try{$acc=($acc+f1($i))%1000003;}catch(Exception$e){$caught++;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$acc}_{$caught}\n";echo"Time: ".round($ms)."ms\n";
