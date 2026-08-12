use Time::HiRes qw(time);
my$N=20000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my@arr;push@arr,"w".$ri->(100000)for 1..$N;
sub ms{my@a=@_;return@a if@a<=1;my$m=int(@a/2);my@L=ms(@a[0..$m-1]);my@R=ms(@a[$m..$#a]);my@res;my$pi=0;my$qi=0;
 while($pi<@L){last if$qi>=@R;if($L[$pi]le$R[$qi]){push@res,$L[$pi++]}else{push@res,$R[$qi++]}}
 push@res,@L[$pi..$#L];push@res,@R[$qi..$#R];return@res}
my$start=time();my@s=ms(@arr);my$acc=0;for my$i(0..$N-1){$acc=($acc+length($s[$i])*($i%13))%1000003}
my$end=time();my$ms=($end-$start)*1000;print"Result: $acc\n";printf"Time: %.0fms\n",$ms;
