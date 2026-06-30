<?php
$start = hrtime(true);
$max_steps = 0; $max_n = 0;
for ($n = 1; $n <= 10000; $n++) {
    $steps = 0; $c = $n;
    while ($c != 1) {
        if ($c % 2 == 0) { $c = intdiv($c, 2); }
        else { $c = $c * 3 + 1; }
        $steps++;
    }
    if ($steps > $max_steps) { $max_steps = $steps; $max_n = $n; }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Max steps: " . $max_steps . " at n=" . $max_n . "
";
echo "Time: " . round($ms) . "ms
";
