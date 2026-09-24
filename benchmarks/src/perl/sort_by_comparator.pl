use Time::HiRes qw(time);
my $N=20000;my @arr;my $seed=12345;for my $i (1..$N){$seed=($seed*16807)%2147483647;push @arr,$seed%1000000}
sub asc { $_[0] - $_[1] } sub desc { $_[1] - $_[0] }
sub qs { my($a,$l,$h,$cmp)=@_;return if $l>=$h;my @s=($l,$h);while(@s){my $h2=pop @s;my $l2=pop @s;next if $l2>=$h2;my $p=$a->[int(($l2+$h2)/2)];my($i2,$j2)=($l2,$h2);while($i2<=$j2){$i2++ while &$cmp($a->[$i2],$p)<0;$j2-- while &$cmp($a->[$j2],$p)>0;if($i2<=$j2){my $t=$a->[$i2];$a->[$i2]=$a->[$j2];$a->[$j2]=$t;$i2++;$j2--}}push @s,$l2,$j2 if $l2<$j2;push @s,$i2,$h2 if $i2<$h2}}
my $start=time();my @c1=@arr;qs(\@c1,0,$N-1,\&asc);my @c2=@arr;qs(\@c2,0,$N-1,\&desc);my($r1,$r2)=(0,0);
for my $i (0..$N-1){$r1=($r1+$c1[$i]*($i%7))%1000003;$r2=($r2+$c2[$i]*($i%7))%1000003}
my $end=time();my $ms=($end-$start)*1000;print "Result: ${r1}_${r2}\n";printf "Time: %.0fms\n",$ms;
