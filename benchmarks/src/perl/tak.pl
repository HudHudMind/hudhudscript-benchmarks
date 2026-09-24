use strict;
use warnings;
use Time::HiRes qw(time);
no warnings 'recursion';

sub tak {
    my ($x, $y, $z) = @_;
    if ($y < $x) {
        return tak(
            tak($x - 1, $y, $z),
            tak($y - 1, $z, $x),
            tak($z - 1, $x, $y)
        );
    }
    return $z;
}

my $start = time() * 1000;
my $res = 0;
for (my $i = 0; $i < 10; $i++) {
    $res = tak(18, 12, 6);
}
my $end = time() * 1000;

print "Result: $res\n";
printf "Time: %.0fms\n", ($end - $start);
