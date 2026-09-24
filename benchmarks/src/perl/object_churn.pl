use Time::HiRes qw(time);
my $N = 500000;
my $acc = 0;
my $start = time();
for (my $i = 0; $i < $N; $i++) {
    my $p = { x => $i, y => $i * 2, z => 0 };
    $p->{z} = $p->{x} + $p->{y};
    $acc = ($acc + $p->{z}) % 1000003;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $acc\n";
printf "Time: %.0fms\n", $ms;
