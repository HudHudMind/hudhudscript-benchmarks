<?php
$I=300000;$acc=0;$c=$I;$start=hrtime(true);
while($c>0){$op=$c%10;
 if($op==0){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==1){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==2){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==3){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==4){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==5){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==6){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==7){$acc=($acc*3+$c)%1000003;$c--;}elseif($op==8){$acc=($acc*3+$c)%1000003;$c--;}else{$acc=($acc*3+$c)%1000003;$c--;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $acc\n";echo"Time: ".round($ms)."ms\n";
