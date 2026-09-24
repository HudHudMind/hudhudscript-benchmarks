<?php
$seed=42;function rng(){global$seed;$seed=($seed*1103515245+12345)%2147483648;return intdiv($seed-($seed%65536),65536)%4;}
$chars="ACGT";$ta=[];for($i=0;$i<500000;$i++)$ta[]=$chars[rng()];$text=implode("",$ta);
$patterns=[];for($i=0;$i<15;$i++){$sp=($seed*16807)%499000;$seed=($seed*16807)%2147483647;$pl=5+($seed%11);$patterns[]=substr($text,$sp,$pl);}
for($i=0;$i<5;$i++){$patterns[]="QQQQQ".(($seed*16807)%10);$seed=($seed*16807)%2147483647;}
$start=hrtime(true);$total=0;
foreach($patterns as $pat){$m=strlen($pat);$fail=array_fill(0,$m,0);$j=0;
for($i=1;$i<$m;$i++){while($j>0&&$pat[$i]!=$pat[$j])$j=$fail[$j-1];if($pat[$i]==$pat[$j])$j++;$fail[$i]=$j;}
$j=0;for($i=0;$i<strlen($text);$i++){$c=$text[$i];while($j>0&&$c!=$pat[$j])$j=$fail[$j-1];if($c==$pat[$j])$j++;if($j==$m){$total++;$j=$fail[$j-1];}}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: $total
";echo"Time: ".round($ms)."ms
";