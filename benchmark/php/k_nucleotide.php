<?php
function generate_dna($length) {
    $chars = "ACGT";
    $seq = "";
    $seed = 42;
    for ($i = 0; $i < $length; $i++) {
        $seed = ($seed * 1103515245 + 12345) & 0x7fffffff;
        $idx = ($seed >> 16) % 4;
        $seq .= $chars[$idx];
    }
    return $seq;
}

function count_frequencies($dna, $k) {
    $freqs = [];
    $n = strlen($dna) - $k + 1;
    for ($i = 0; $i < $n; $i++) {
        $sub = substr($dna, $i, $k);
        if (!isset($freqs[$sub])) {
            $freqs[$sub] = 1;
        } else {
            $freqs[$sub]++;
        }
    }
    return count($freqs);
}

$start = microtime(true) * 1000;
$dna = generate_dna(100000);
$c1 = count_frequencies($dna, 1);
$c2 = count_frequencies($dna, 2);
$c3 = count_frequencies($dna, 3);
$res = $c1 + $c2 + $c3;
$end = microtime(true) * 1000;

echo "Count: " . $res . "\n";
echo "Time: " . round($end - $start) . "ms\n";
?>
