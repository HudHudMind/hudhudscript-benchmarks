use Time::HiRes qw(time);
my $s = "a" x 50000;
my $start = time();
my $rev = "";
for my $j (reverse 0..length($s)-1) { $rev .= substr($s, $j, 1); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Len: " . length($rev) . "
";
printf "Time: %.0fms
", $ms;
