use Time::HiRes qw(time);
sub f3 {my$i=shift;die"boom" if$i%7==0;$i*2}
sub f2 {f3(@_)}
sub f1 {f2(@_)}
my$N=200000;my($acc,$caught)=(0,0);my$start=time();
for my$i(1..$N){eval{$acc=($acc+f1($i))%1000003};$caught++ if$@}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${acc}_${caught}\n";printf"Time: %.0fms\n",$ms;
