<?php
function is_prime($n) {
    if ($n < 2) return false;
    if ($n == 2) return true;
    if ($n % 2 == 0) return false;
    for ($i = 3; $i * $i <= $n; $i += 2) {
        if ($n % $i == 0) return false;
    }
    return true;
}
$start = hrtime(true);
$count = 0;
for ($n = 2; $n <= 100000; $n++) {
    if (is_prime($n)) $count++;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Primes: " . $count . "
";
echo "Time: " . round($ms) . "ms
";
