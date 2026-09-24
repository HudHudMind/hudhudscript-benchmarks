<?php
function fannkuch($n) {
    $p = range(0, $n - 1);
    $q = range(0, $n - 1);
    $s = range(0, $n - 1);
    $sign = 1;
    $maxflips = 0;
    $sumflips = 0;

    while (true) {
        $q1 = $p[0];
        if ($q1 != 0) {
            for ($i = 1; $i < $n; $i++) $q[$i] = $p[$i];
            $flips = 1;
            while (true) {
                $qq = $q[$q1];
                if ($qq == 0) break;
                $q[$q1] = $q1;
                if ($q1 >= 3) {
                    $i = 1; $j = $q1 - 1;
                    while ($i < $j) {
                        $t = $q[$i];
                        $q[$i] = $q[$j];
                        $q[$j] = $t;
                        $i++;
                        $j--;
                    }
                }
                $q1 = $qq;
                $flips++;
            }
            if ($flips > $maxflips) $maxflips = $flips;
            $sumflips += $sign * $flips;
        }

        if ($sign == 1) {
            $t = $p[1];
            $p[1] = $p[0];
            $p[0] = $t;
            $sign = -1;
        } else {
            $t = $p[1];
            $p[1] = $p[2];
            $p[2] = $t;
            $sign = 1;
            for ($k = 2; $k < $n; $k++) {
                $s[$k]--;
                if ($s[$k] != 0) break;
                $s[$k] = $k;
                $t = $p[0];
                for ($m = 0; $m <= $k; $m++) {
                    $p[$m] = $m < $k ? $p[$m + 1] : $t;
                }
            }
            if ($k == $n) break;
        }
    }
    return $sumflips . "_" . $maxflips;
}

$start = microtime(true);
$res = fannkuch(9);
$end = microtime(true);

echo "Result: $res\n";
echo "Time: " . (int)(($end - $start) * 1000) . "ms\n";
