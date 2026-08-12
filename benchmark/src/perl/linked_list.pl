use Time::HiRes qw(time);
my $N=100000;my $seed=12345;my $acc=0;my $start=time();
my $head=undef;for my $i (1..$N){$seed=($seed*16807)%2147483647;$head={value=>$seed%10000,next=>$head}}
my($prev,$cur)=(undef,$head);for my $i (1..$N){my $nxt=$cur->{next};$cur->{next}=$prev;$prev=$cur;$cur=$nxt}
my($pos,$walk)=(0,$prev);for my $i (1..$N){$acc=($acc+$walk->{value}*$pos)%1000003;$pos++;$walk=$walk->{next}}
my $end=time();my $ms=($end-$start)*1000;print "Result: $acc\n";printf "Time: %.0fms\n",$ms;
