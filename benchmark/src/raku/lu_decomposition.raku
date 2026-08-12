my$n=200;my@A;for ^$n -> $i {my@r;for ^$n -> $j {@r.push((($i*31+$j*17)%100+1e0)+($i==$j??1000e0!!0e0))};@A.push(@r)}
my$start=now*1000;
for ^$n -> $k {for $k+1..^$n -> $i {my$f=@A[$i][$k]/@A[$k][$k];for ^$n -> $j {@A[$i][$j]-=$f*@A[$k][$j]};@A[$i][$k]=$f}}
my$s=0e0;$s+=@A[$_][$_]for ^$n;my$r=round($s/$n*1000);my$end=now*1000;say "Result: $r";say "Time: "~($end-$start).Int~"ms"