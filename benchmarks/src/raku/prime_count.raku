sub isPrime($n) {
    return 0 if $n < 2; return 1 if $n == 2; return 0 if $n % 2 == 0;
    my $i = 3; while $i * $i <= $n { return 0 if $n % $i == 0; $i += 2; }; return 1; }; my $start = now * 1000; my $c = 0; for 1..100000 { $c++ if isPrime($_); }; my $end = now * 1000; say "Result: " ~ $c; say "Time: " ~ ($end - $start).Int ~ "ms";