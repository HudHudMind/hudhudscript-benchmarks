use Time::HiRes qw(time);
my $seed=12345;my $line="";
for my $j (0..39){$seed=($seed*16807)%2147483647;my $fn=($seed%1000)+100;$line.="f$fn";$line.="," if $j<39}
my $R=10000;my($sp,$si,$ss)=(0,0,0);my $start=time();
for my $r (1..$R){my @parts=split/,/,$line;for my $p (@parts){$sp+=scalar@parts;my $idx=index($p,"f");$si+=$idx>=0?$idx:0;$ss+=length(substr($p,1,2)) if length($p)>=4}}
my $acc=(($sp%1000003)+($si%1000003)+($ss%1000003))%1000003;my $end=time();my $ms=($end-$start)*1000;
print "Result: $acc\n";printf "Time: %.0fms\n",$ms;
