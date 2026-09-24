<?php
$s = "";
$start = hrtime(true);
for ($i = 0; $i < 50000; $i++) { $s .= "x"; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . strlen($s) . "
";
echo "Time: " . round($ms) . "ms
";
