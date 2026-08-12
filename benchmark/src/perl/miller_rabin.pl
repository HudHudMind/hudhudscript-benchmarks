use Time::HiRes qw(time);
my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
sub pm{my($b,$e,$m)=@_;my$r=1;while($e>0){$r=($r*$b)%$m if$e%2==1;$e>>=1;$b=($b*$b)%$m}$r}
sub ip{my$n=shift;return 0 if$n<2;return 1 if$n==2;return 0 if$n%2==0;
 my($d,$s)=($n-1,0);$d>>=1,$s++ while$d%2==0;
 for my$a(2,3,5,7){next if$a>=$n;my$x=pm($a,$d,$n);next if$x==1||$x==$n-1;
  for(1..$s-1){$x=($x*$x)%$n;last if$x==$n-1}return 0 if$x!=$n-1}1}
my$K=2000;my$cnt=0;my$start=time();
for(1..$K){my$n=1000000001+2*$ri->(500000000);$cnt++ if ip($n)}
my$end=time();my$ms=($end-$start)*1000;print"Result: $cnt\n";printf"Time: %.0fms\n",$ms;
