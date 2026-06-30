use Time::HiRes qw(time);
my $text = ("abcdefghij" x 1000);
my $pattern = "defg";
my $start = time();
my ($count, $tlen, $plen) = (0, length($text), length($pattern));
for my $i (0..$tlen-$plen) {
    my $match = 1;
    for my $j (0..$plen-1) { if (substr($text,$i+$j,1) ne substr($pattern,$j,1)) { $match = 0; last; } }
    $count++ if $match;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Count: $count
";
printf "Time: %.0fms
", $ms;
