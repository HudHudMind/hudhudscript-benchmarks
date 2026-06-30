<?php
function is_pal($s) {
    $len = strlen($s);
    for ($i = 0; $i < $len / 2; $i++) { if ($s[$i] != $s[$len-1-$i]) return false; }
    return true;
}
$text = str_repeat("a", 50000);
$start = hrtime(true);
$ok = true;
for ($k = 0; $k < 1000; $k++) { $ok = is_pal($text); }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Palindrome: " . ($ok ? "true" : "false") . "
";
echo "Time: " . round($ms) . "ms
";
