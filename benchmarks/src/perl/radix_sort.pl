use Time::HiRes qw(time);
my $n = 200000;
my $seed = 12345;
sub ri {
    my $m = shift;
    $seed = ($seed * 16807) % 2147483647;
    return $seed % $m;
}

my @arr;
for (1..$n) { push @arr, ri(1000000); }

my $start = time();

my @buckets = (0) x 10;
my @output = (0) x $n;

for my $p (0..5) {
    @buckets = (0) x 10;
    my $div = 10 ** $p;
    for my $i (0..$n-1) {
        my $d = int($arr[$i] / $div) % 10;
        $buckets[$d]++;
    }
    for my $i (1..9) { $buckets[$i] += $buckets[$i - 1]; }
    for (my $i = $n - 1; $i >= 0; $i--) {
        my $d = int($arr[$i] / $div) % 10;
        $buckets[$d]--;
        $output[$buckets[$d]] = $arr[$i];
    }
    my @tmp = @arr; @arr = @output; @output = @tmp;
}

my $c = 0;
for my $i (0..$n-1) { $c = ($c + $arr[$i] * ($i % 7)) % 1000003; }

my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $arr[0]/$arr[$n-1]_$c\n";
printf "Time: %.0fms\n", $ms;
