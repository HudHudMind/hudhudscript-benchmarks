use Time::HiRes qw(time);
my $n = 200000; my $U = 400000;
my @parent = (0..$n-1); my @size = (1) x $n;
sub find { my $x = shift; while ($parent[$x] != $x) { $x = $parent[$x] } $x }
sub union {
    my ($a, $b) = @_; my $ra = find($a); my $rb = find($b); return if $ra == $rb;
    if ($size[$ra] < $size[$rb]) { $parent[$ra] = $rb; $size[$rb] += $size[$ra] }
    else { $parent[$rb] = $ra; $size[$ra] += $size[$rb] }
}
my $seed = 12345;
sub ri { my $m = shift; $seed = ($seed * 16807) % 2147483647; $seed % $m }
my $start = time();
for (1..$U) { union(ri($n), ri($n)) }
my $roots = 0;
for (0..$n-1) { $roots++ if $parent[$_] == $_ }
my $end = time(); my $ms = ($end - $start) * 1000;
print "Result: $roots\n"; printf "Time: %.0fms\n", $ms;
