use Time::HiRes qw(time);
my @arr = map { $_ * 2 } 0..99999;
my $start = time();
my $found = 0;
for my $j (0..9999) {
    my $target = $j * 20;
    $found++ if $target >= 0 && $target < 200000 && $target % 2 == 0;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Found: $found
";
printf "Time: %.0fms
", $ms;
