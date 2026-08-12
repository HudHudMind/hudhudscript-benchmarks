use Time::HiRes qw(time);
my$I=300000;my($acc,$c)=(0,$I);my$start=time();
while($c>0){my$op=$c%10;
 if($op==0){$acc=($acc*3+$c)%1000003;$c--}elsif($op==1){$acc=($acc*3+$c)%1000003;$c--}elsif($op==2){$acc=($acc*3+$c)%1000003;$c--}elsif($op==3){$acc=($acc*3+$c)%1000003;$c--}elsif($op==4){$acc=($acc*3+$c)%1000003;$c--}elsif($op==5){$acc=($acc*3+$c)%1000003;$c--}elsif($op==6){$acc=($acc*3+$c)%1000003;$c--}elsif($op==7){$acc=($acc*3+$c)%1000003;$c--}elsif($op==8){$acc=($acc*3+$c)%1000003;$c--}else{$acc=($acc*3+$c)%1000003;$c--}}
my$end=time();my$ms=($end-$start)*1000;print"Result: $acc\n";printf"Time: %.0fms\n",$ms;
