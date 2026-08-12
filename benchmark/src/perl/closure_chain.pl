use Time::HiRes qw(time);

sub make_counter {
    my $start = shift;
    my $c = $start;
    return sub { $c = $c + 1; return $c; };
}

my $N = 150000;
my $acc = 0;
my $start = time();
for (my $i = 0; $i < $N; $i++) {
    my $ctr = make_counter($i % 1000);
    $acc = ($acc + $ctr->() + $ctr->() + $ctr->()) % 1000003;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $acc\n";
printf "Time: %.0fms\n", $ms;
