<?php
$comp = [
    'A' => 'T', 'C' => 'G', 'G' => 'C', 'T' => 'A',
    'U' => 'A', 'M' => 'K', 'R' => 'Y', 'W' => 'W',
    'S' => 'S', 'Y' => 'R', 'K' => 'M', 'V' => 'B',
    'H' => 'D', 'D' => 'H', 'B' => 'V', 'N' => 'N',
    'a' => 'T', 'c' => 'G', 'g' => 'C', 't' => 'A',
    'u' => 'A', 'm' => 'K', 'r' => 'Y', 'w' => 'W',
    's' => 'S', 'y' => 'R', 'k' => 'M', 'v' => 'B',
    'h' => 'D', 'd' => 'H', 'b' => 'V', 'n' => 'N'
];

function reverse_complement($seq) {
    global $comp;
    $count_A = 0;
    for ($i = strlen($seq) - 1; $i >= 0; $i--) {
        $c = $seq[$i];
        $rep = isset($comp[$c]) ? $comp[$c] : $c;
        if ($rep === 'A') {
            $count_A++;
        }
    }
    return $count_A;
}

$start = microtime(true);

$seq = "";
$seed = 42;
$chars = ['A', 'C', 'G', 'T'];
for ($i = 0; $i < 500000; $i++) {
    $seed = ($seed * 1103515245 + 12345) & 0x7fffffff;
    $idx = ($seed >> 16) % 4;
    $seq .= $chars[$idx];
}

$res = 0;
for ($i = 0; $i < 10; $i++) {
    $res = reverse_complement($seq);
}

$end = microtime(true);
echo "Result: $res\n";
echo "Time: " . (int)(($end - $start) * 1000) . "ms\n";
