<?php
$s1 = str_repeat("abcdefghij", 10);
$s2 = str_repeat("acegikmoqs", 10);
$start = hrtime(true);
$m = strlen($s1); $n = strlen($s2);
$dp = array_fill(0, $m + 1, array_fill(0, $n + 1, 0));
for ($i = 1; $i <= $m; $i++) {
    for ($j = 1; $j <= $n; $j++) {
        if ($s1[$i-1] == $s2[$j-1]) { $dp[$i][$j] = $dp[$i-1][$j-1] + 1; }
        else { $dp[$i][$j] = max($dp[$i-1][$j], $dp[$i][$j-1]); }
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "LCS: " . $dp[$m][$n] . "
";
echo "Time: " . round($ms) . "ms
";
