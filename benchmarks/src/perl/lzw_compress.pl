use Time::HiRes qw(time);
my$M=400000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my@syms;my$i=0;
while($i<$M){if($i>=20&&$ri->(10)<4){my$s=$i-20;for(1..20){push@syms,$syms[$s+$_-1]};$i+=20}else{push@syms,$ri->(4);$i++}}
my$DS=4096;my@dic=(0)x($DS*4);my$nc=5;my@out;my$cur=$syms[0]+1;$i=1;my$start=time();
while($i<@syms){my$s=$syms[$i];my$cand=$dic[$cur*4+$s];if($cand!=0){$cur=$cand}else{push@out,$cur;
 if($nc<$DS){$dic[$cur*4+$s]=$nc;$nc++}$cur=$s+1}$i++}
push@out,$cur;my$oc=@out;my$sm=0;for my$j(0..$oc-1){$sm=($sm+$out[$j]*$j)%1000003}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${oc}_${sm}\n";printf"Time: %.0fms\n",$ms;