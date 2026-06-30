<?php
$arr = [];
for ($i = 1000; $i > 0; $i--) { $arr[] = $i; }
$n = 1000;
$start = hrtime(true);
for ($width = 1; $width < $n; $width *= 2) {
    for ($left = 0; $left < $n; $left += 2 * $width) {
        $mid = $left + $width - 1;
        if ($mid < $n - 1) {
            $right = min($left + 2 * $width - 1, $n - 1);
            $n1 = $mid - $left + 1; $n2 = $right - $mid;
            $L = array_slice($arr, $left, $n1);
            $R = array_slice($arr, $mid + 1, $n2);
            $i = 0; $j = 0; $k = $left;
            while ($i < $n1 && $j < $n2) {
                if ($L[$i] <= $R[$j]) { $arr[$k] = $L[$i]; $i++; }
                else { $arr[$k] = $R[$j]; $j++; }
                $k++;
            }
            while ($i < $n1) { $arr[$k] = $L[$i]; $i++; $k++; }
            while ($j < $n2) { $arr[$k] = $R[$j]; $j++; $k++; }
        }
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "First: " . $arr[0] . "
";
echo "Last: " . $arr[$n - 1] . "
";
echo "Time: " . round($ms) . "ms
";
