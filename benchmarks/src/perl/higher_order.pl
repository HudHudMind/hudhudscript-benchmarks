use Time::HiRes qw(time);
use List::Util qw(reduce);

my @base = (0..999);
my $R = 2000;
my $acc = 0;
my $start = time();
for (my $r = 0; $r < $R; $r++) {
    my @d = map { $_ * 2 + 1 } @base;
    my @f = grep { $_ % 3 != 0 } @d;
    my $s = reduce { $a + $b } 0, @f;
    $acc = ($acc + $s + scalar(@f)) % 1000003;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $acc\n";
printf "Time: %.0fms\n", $ms;
