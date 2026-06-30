my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub sieve($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my @prime; for 0..$n { @prime.push(1); }; my $p = 2;
    while $p * $p <= $n { if @prime[$p] { my $i = $p * $p; while $i <= $n { @prime[$i] = 0; $i += $p; }; }; $p++; }; my $c = 0; for 2..$n -> $i { $c++ if @prime[$i]; }; return $c; }; my $start = now * 1000; my $c = 0; for 1..100 { $c = sieve(10000); }; my $end = now * 1000; say "Primes: " ~ $c; say "Time: " ~ ($end - $start).Int ~ "ms";