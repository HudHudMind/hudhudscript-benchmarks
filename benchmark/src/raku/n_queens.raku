# n_queens: board[row]=col, linear safety scan, iterative backtracking
my $n = 8;
my @board = -1 xx $n;
my $sols = 0;
my $row = 0;
my $start = now * 1000;

while $row >= 0 {
    if $row == $n {
        $sols++;
        $row--;
        next
    }
    # Try next column for current row
    my $col = @board[$row] + 1;
    @board[$row] = -1;
    if $col >= $n {
        $row--;
        next
    }
    # Linear safety scan against placed rows
    my $safe = True;
    for ^$row -> $r {
        if @board[$r] == $col || abs(@board[$r] - $col) == $row - $r {
            $safe = False;
            last
        }
    }
    if $safe {
        @board[$row] = $col;
        $row++;
    } else {
        # Try next column in same row
        @board[$row] = $col;
    }
}

my $end = now * 1000;
say "Result: $sols";
say "Time: " ~ ($end - $start).Int ~ "ms";
