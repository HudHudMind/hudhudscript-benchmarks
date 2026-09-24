use Time::HiRes qw(time);
my$M=500000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my@dict;push@dict,"w$_"for 0..1999;my%counts;$counts{$_}=0 for@dict;
my$start=time();
$counts{$dict[$ri->(2000)]}++for 1..$M;
my($mc,$mw)=(0,"");for my$w(@dict){my$v=$counts{$w};if($mc==0){$mc=$v;$mw=$w}elsif($v>$mc){$mc=$v;$mw=$w}}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${mc}_${mw}\n";printf"Time: %.0fms\n",$ms;
