<?php
$n = 200000;
$seed = 12345;
function ri($m) {
    global $seed;
    $seed = ($seed * 16807) % 2147483647;
    return $seed % $m;
}

$arr = [];
for ($i = 0; $i < $n; $i++) $arr[] = ri(1000000);

$start = hrtime(true);

$buckets = array_fill(0, 10, 0);
$output = array_fill(0, $n, 0);

for ($p = 0; $p < 6; $p++) {
    for ($i = 0; $i < 10; $i++) $buckets[$i] = 0;
    $div = 10 ** $p;
    for ($i = 0; $i < $n; $i++) {
        $d = intdiv($arr[$i], $div) % 10;
        $buckets[$d]++;
    }
    for ($i = 1; $i < 10; $i++) $buckets[$i] += $buckets[$i - 1];
    for ($i = $n - 1; $i >= 0; $i--) {
        $d = intdiv($arr[$i], $div) % 10;
        $buckets[$d]--;
        $output[$buckets[$d]] = $arr[$i];
    }
    $tmp = $arr; $arr = $output; $output = $tmp;
}

$c = 0;
for ($i = 0; $i < $n; $i++) $c = ($c + $arr[$i] * ($i % 7)) % 1000003;

$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: {$arr[0]}/{$arr[$n-1]}_{$c}\n";
echo "Time: " . round($ms) . "ms\n";
