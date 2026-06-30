use strict;
use warnings;
use Time::HiRes qw(time);

sub duffs_device {
    my $count = shift;
    my @a = (0) x $count;
    my @b = (1) x $count;
    
    my $n = int($count / 8);
    my $rem = $count % 8;
    my $i = 0;
    
    while ($rem > 0) {
        $a[$i] = $b[$i];
        $i++;
        $rem--;
    }
    
    while ($n > 0) {
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $n--;
    }
    return $a[$count - 1];
}

my $start = time() * 1000;
my $res = 0;
for (my $k = 0; $k < 100; $k++) {
    $res = duffs_device(100000);
}
my $end = time() * 1000;

print "Result: $res\n";
printf "Time: %.0fms\n", ($end - $start);
