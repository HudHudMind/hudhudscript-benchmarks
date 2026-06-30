<?php
$start = hrtime(true);
$total = 0;
for ($n = 1; $n <= 100000; $n++) {
    $x = $n;
    while ($x > 0) { if ($x % 2 == 1) $total++; $x = intdiv($x, 2); }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Total: " . $total . "
";
echo "Time: " . round($ms) . "ms
";
