<?php
$s = str_repeat("a", 50000);
$start = hrtime(true);
$rev = "";
for ($j = strlen($s) - 1; $j >= 0; $j--) { $rev .= $s[$j]; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Len: " . strlen($rev) . "
";
echo "Time: " . round($ms) . "ms
";
