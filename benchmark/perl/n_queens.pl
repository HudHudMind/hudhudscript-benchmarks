use Time::HiRes qw(time);
sub solve {
    my $n = shift;
    my @board = (0) x $n;
    my ($count, $row, $col) = (0, 0, 0);
    while ($row >= 0) {
        if ($row == $n) { $count++; $row--; $col = $board[$row] + 1 if $row >= 0; }
        else {
            my $found = 0;
            while ($col < $n) {
                my $safe = 1;
                for my $i (0..$row-1) {
                    if ($board[$i] == $col || $board[$i] - $col == $i - $row || $board[$i] - $col == $row - $i) { $safe = 0; last; }
                }
                if ($safe) { $board[$row] = $col; $row++; $col = 0; $found = 1; last; }
                $col++;
            }
            unless ($found) { $row--; $col = $board[$row] + 1 if $row >= 0; }
        }
    }
    return $count;
}
my $start = time();
my $r = solve(8);
my $end = time();
my $ms = ($end - $start) * 1000;
print "Solutions: $r
";
printf "Time: %.0fms
", $ms;
