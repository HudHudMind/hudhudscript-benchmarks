<?php
$text = str_repeat("abcdefghij", 1000);
$pattern = "defg";
$start = hrtime(true);
$count = 0; $tlen = strlen($text); $plen = strlen($pattern);
for ($i = 0; $i <= $tlen - $plen; $i++) {
    $match = true;
    for ($j = 0; $j < $plen; $j++) { if ($text[$i+$j] != $pattern[$j]) { $match = false; break; } }
    if ($match) $count++;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Count: " . $count . "
";
echo "Time: " . round($ms) . "ms
";
