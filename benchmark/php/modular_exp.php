<?php
function mod_exp($base, $exp, $mod) {
    $result = 1; $base = $base % $mod;
    while ($exp > 0) {
        if ($exp % 2 == 1) $result = ($result * $base) % $mod;
        $exp = intdiv($exp, 2); $base = ($base * $base) % $mod;
    }
    return $result;
}
$start = hrtime(true);
$sum = 0;
for ($i = 0; $i < 10000; $i++) { $sum += mod_exp(3, 1000, 1000000007); }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
