<?php
function solve($n) {
    $board = []; $count = 0; $row = 0; $col = 0;
    while (true) {
        if ($row == $n) { $count++; $col = array_pop($board) + 1; $row--; }
        else {
            $found = false;
            while ($col < $n) {
                $safe = true;
                for ($i = 0; $i < $row; $i++) {
                    if ($board[$i] == $col || $board[$i] - $col == $i - $row || $board[$i] - $col == $row - $i) { $safe = false; break; }
                }
                if ($safe) { $board[] = $col; $row++; $col = 0; $found = true; break; }
                $col++;
            }
            if (!$found) {
                if (count($board) == 0) break;
                $col = array_pop($board) + 1;
                $row--;
            }
        }
    }
    return $count;
}
$start = hrtime(true);
$r = solve(8);
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Solutions: " . $r . "
";
echo "Time: " . round($ms) . "ms
";
