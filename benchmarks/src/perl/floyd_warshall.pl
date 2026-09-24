use Time::HiRes qw(time);
my$n=150;my$INF=999999999;my@dist;for my$i(0..$n-1){for my$j(0..$n-1){$dist[$i][$j]=$i==$j?0:$INF}}
my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
for my$i(0..$n-1){for my$j(0..3){my$t=($i*7+$j*13+1)%$n;$dist[$i][$t]=1+(($i+$j)%50)if$t!=$i}}
my$start=time();
for my$k(0..$n-1){for my$i(0..$n-1){my$dik=$dist[$i][$k];if($dik!=$INF){for my$j(0..$n-1){my$nd=$dik+$dist[$k][$j];$dist[$i][$j]=$nd if$nd<$dist[$i][$j]}}}}
my($reach,$sm)=(0,0);for my$i(0..$n-1){for my$j(0..$n-1){if($dist[$i][$j]<$INF){$reach++;$sm+=$dist[$i][$j]}}}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${reach}_".($sm%1000003)."\n";printf"Time: %.0fms\n",$ms;
