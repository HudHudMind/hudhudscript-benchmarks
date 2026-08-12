use Time::HiRes qw(time);
my$seed=42;sub rng{$seed=($seed*1103515245+12345)%2147483648;int(($seed-($seed%65536))/65536)%4}
my$chars="ACGT";my@ta;for(1..500000){push@ta,substr($chars,rng(),1)}my$text=join"",@ta;
my@patterns;for(1..15){my$sp=($seed*16807)%499000;$seed=($seed*16807)%2147483647;my$pl=5+($seed%11);push@patterns,substr($text,$sp,$pl)}
for(1..5){push@patterns,"QQQQQ".(($seed*16807)%10);$seed=($seed*16807)%2147483647}
my$start=time();my$total=0;
for my$pat(@patterns){my$m=length($pat);my@fail=(0)x$m;my$j=0;
for my$i(1..$m-1){while($j>0&&substr($pat,$i,1)ne substr($pat,$j,1)){$j=$fail[$j-1]}if(substr($pat,$i,1)eq substr($pat,$j,1)){$j++}$fail[$i]=$j}
$j=0;for my$i(0..length($text)-1){my$c=substr($text,$i,1);while($j>0&&$c ne substr($pat,$j,1)){$j=$fail[$j-1]}if($c eq substr($pat,$j,1)){$j++}if($j==$m){$total++;$j=$fail[$j-1]}}}
my$end=time();my$ms=($end-$start)*1000;print"Result: $total
";printf"Time: %.0fms
",$ms;