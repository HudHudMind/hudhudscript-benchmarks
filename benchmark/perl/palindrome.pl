use Time::HiRes qw(time);
sub is_pal {
    my $s = shift;
    my $len = length($s);
    for my $i (0..int($len/2)-1) { return 0 if substr($s,$i,1) ne substr($s,$len-1-$i,1); }
    return 1;
}
my $text = ("a" x 50000);
my $start = time();
my $ok = 1;
for (1..1000) { $ok = is_pal($text); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Palindrome: " . ($ok ? "true" : "false") . "
";
printf "Time: %.0fms
", $ms;
