use Time::HiRes qw(time);
my $s = "";
my $start = time();
$s .= "x" for 1..50000;
my $end = time();
my $ms = ($end - $start) * 1000;
print "Length: " . length($s) . "
";
printf "Time: %.0fms
", $ms;
