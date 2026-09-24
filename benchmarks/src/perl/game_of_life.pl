use Time::HiRes qw(time);
my$G=96;my$T=100;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my@a;my@b;for my$i(0..$G-1){for my$j(0..$G-1){$a[$i][$j]=$ri->(100)<35?1:0;$b[$i][$j]=0}}
my$start=time();
for my$t(1..$T){for my$i(0..$G-1){for my$j(0..$G-1){my$nbr=0;
 for my$di(-1..1){for my$dj(-1..1){next if$di==0&&$dj==0;$nbr+=$a[($i+$di)%$G][($j+$dj)%$G]}}
 $b[$i][$j]=($a[$i][$j]==1&&($nbr==2||$nbr==3))||($a[$i][$j]==0&&$nbr==3)?1:0}}
 my@t=@a;@a=@b;@b=@t}
my$alive=0;for my$i(0..$G-1){for my$j(0..$G-1){$alive+=$a[$i][$j]}}
my$end=time();my$ms=($end-$start)*1000;print"Result: $alive\n";printf"Time: %.0fms\n",$ms;
