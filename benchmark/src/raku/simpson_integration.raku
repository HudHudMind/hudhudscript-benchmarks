sub f($x){$x*$x*$x-2*$x*$x+3}
my$N=2000000;my$h=10e0/$N;my$s=f(0e0)+f(10e0);my$start=now*1000;
for 1..^$N {my$x=$_*$h;$s+=$_%2==0??2*f($x)!!4*f($x)}
my$r=$s*$h/3;my$end=now*1000;say "Result: $r";say "Time: "~($end-$start).Int~"ms";
