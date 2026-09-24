<?php
$start = microtime(true);

$seed = 42;
function rand_val($max_val) {
    global $seed;
    $seed = ($seed * 3877 + 29573) % 139968;
    return $max_val * $seed / 139968.0;
}

$alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

$iub = [
    ['a', 0.27], ['c', 0.12], ['g', 0.12], ['t', 0.27],
    ['B', 0.02], ['D', 0.02], ['H', 0.02], ['K', 0.02],
    ['M', 0.02], ['N', 0.02], ['R', 0.02], ['S', 0.02],
    ['V', 0.02], ['W', 0.02], ['Y', 0.02]
];

$cp = 0.0;
for ($i = 0; $i < count($iub); $i++) {
    $cp += $iub[$i][1];
    $iub[$i][1] = $cp;
}

$res = 0;
$n = 50000;

$total = $n * 2;
while ($total > 0) {
    $chunk = min(60, $total);
    $res += $chunk;
    $total -= $chunk;
}

$total = $n * 3;
while ($total > 0) {
    $chunk = min(60, $total);
    for ($c = 0; $c < $chunk; $c++) {
        $r = rand_val(1.0);
        for ($j = 0; $j < count($iub); $j++) {
            if ($r < $iub[$j][1]) {
                $res++;
                break;
            }
        }
    }
    $total -= $chunk;
}

$end = microtime(true);
echo "Result: $res\n";
echo "Time: " . (int)(($end - $start) * 1000) . "ms\n";
