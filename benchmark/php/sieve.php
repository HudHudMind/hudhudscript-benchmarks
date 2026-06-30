<?php
$limit = 10000;
$sieve = array_fill(0, $limit + 1, true);
$sieve[0] = false; $sieve[1] = false;
$start = hrtime(true);
for ($p = 2; $p * $p <= $limit; $p++) {
    if ($sieve[$p]) {
        for ($m = $p * $p; $m <= $limit; $m += $p) {
            $sieve[$m] = false;
        }
    }
}
$count = 0;
for ($i = 2; $i <= $limit; $i++) {
    if ($sieve[$i]) $count++;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Primes up to 10000: " . $count . "
";
echo "Time: " . round($ms) . "ms
";
