use Time::HiRes qw(time);
my$T=300000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my(@pq,$qh,@wq,$wh,@sq,$sh,$made,$acc,$sunk)=(0,0,0,0,0,0,0,0,0);my$start=time();
for(1..$T){$made++;push@wq,$made%100 if$made%3!=0;
 if($wh<@wq){my$pkt=$wq[$wh];$wh++;$acc=($acc+$pkt*7)%1000003;push@sq,$pkt if$pkt>50}
 $sh++,$sunk++ if$sh<@sq}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${made}_${acc}_${sunk}\n";printf"Time: %.0fms\n",$ms;
