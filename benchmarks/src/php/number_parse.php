<?php
$n = 200000;
$seed = 12345;
function ri($m) { global $seed; $seed = ($seed * 16807) % 2147483647; return $seed % $m; }
$strings = [];
for ($i = 0; $i < $n; $i++) {
    $s = "";
    if (ri(2) == 0) $s = "-";
    $nd = 1 + ri(9);
    $s .= (string)(1 + ri(9));
    for ($j = 1; $j < $nd; $j++) $s .= (string)ri(10);
    $strings[] = $s;
}
$start = hrtime(true); $total = 0; $M = 1000003;
foreach ($strings as $s) {
    $neg = false; $idx = 0;
    if ($s[0] == '-') { $neg = true; $idx = 1; }
    $val = 0;
    while ($idx < strlen($s)) {
        $c = $s[$idx];
        if ($c == '0') $d = 0;
        elseif ($c == '1') $d = 1;
        elseif ($c == '2') $d = 2;
        elseif ($c == '3') $d = 3;
        elseif ($c == '4') $d = 4;
        elseif ($c == '5') $d = 5;
        elseif ($c == '6') $d = 6;
        elseif ($c == '7') $d = 7;
        elseif ($c == '8') $d = 8;
        else $d = 9;
        $val = $val * 10 + $d; $idx++;
    }
    if ($neg) $val = -$val;
    $total += $val;
}
$r = (($total % $M) + $M) % $M;
$end = hrtime(true); $ms = ($end - $start) / 1e6;
echo "Result: $r\n"; echo "Time: " . round($ms) . "ms\n";
