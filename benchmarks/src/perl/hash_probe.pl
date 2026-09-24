use Time::HiRes qw(time);
my $C=65536;my @keys=(0)x$C;my @vals=(0)x$C;my @state=(0)x$C;
my $seed=12345;
my $ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my($I,$L,$D)=(40000,80000,20000);my($fnd,$dlt,$acc)=(0,0,0);my $start=time();
for(1..$I){my$k=$ri->(1000000)+1;my$h=($k*16807)%$C;$h=($h+1)%$C while$state[$h]==1;$keys[$h]=$k;$vals[$h]=$k%97;$state[$h]=1}
for(1..$L){my$k=$ri->(1000000)+1;my$h=($k*16807)%$C;while($state[$h]!=0){if($state[$h]==1&&$keys[$h]==$k){$fnd++;$acc=($acc+$vals[$h])%1000003;last}$h=($h+1)%$C}}
for(1..$D){my$k=$ri->(1000000)+1;my$h=($k*16807)%$C;while($state[$h]!=0){if($state[$h]==1&&$keys[$h]==$k){$state[$h]=2;$dlt++;last}$h=($h+1)%$C}}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${fnd}_${dlt}_${acc}\n";printf"Time: %.0fms\n",$ms;
