use Time::HiRes qw(time);
sub f{my$x=shift;$x*$x*$x-2*$x*$x+3}
my$N=2000000;my$h=10/$N;my$s=f(0)+f(10);my$start=time();
for my$i(1..$N-1){my$x=$i*$h;if($i%2==0){$s+=2*f($x)}else{$s+=4*f($x)}}
my$r=$s*$h/3;my$end=time();my$ms=($end-$start)*1000;
print"Result: $r\n";printf"Time: %.0fms\n",$ms;
