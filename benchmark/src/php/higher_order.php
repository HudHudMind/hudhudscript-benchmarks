<?php
$base = range(0, 999);
$R = 2000;
$acc = 0;
$start = hrtime(true);
for ($r = 0; $r < $R; $r++) {
    $d = array_map(function($x) { return $x * 2 + 1; }, $base);
    $f = array_filter($d, function($x) { return $x % 3 != 0; });
    $s = array_reduce($f, function($a, $x) { return $a + $x; }, 0);
    $acc = ($acc + $s + count($f)) % 1000003;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $acc . "\n";
echo "Time: " . round($ms) . "ms\n";
