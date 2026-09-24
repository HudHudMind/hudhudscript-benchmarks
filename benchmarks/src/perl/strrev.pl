use Time::HiRes qw(time);
my$n=50000;my$s="a"x$n;my$start=time();
my@buf;for(my$i=$n-1;$i>=0;$i--){push@buf,substr($s,$i,1)}my$r=join"",@buf;
my$end=time();my$ms=($end-$start)*1000;print"Result: ".substr($r,0,1)."/".length($r)."\n";printf"Time: %.0fms\n",$ms;