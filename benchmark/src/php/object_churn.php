<?php
$N = 500000;
$acc = 0;
$start = hrtime(true);
for ($i = 0; $i < $N; $i++) {
    $p = ["x" => $i, "y" => $i * 2, "z" => 0];
    $p["z"] = $p["x"] + $p["y"];
    $acc = ($acc + $p["z"]) % 1000003;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $acc . "\n";
echo "Time: " . round($ms) . "ms\n";
