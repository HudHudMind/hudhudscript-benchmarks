<?php
$n=20000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$et=[];$ew=[];$deg=array_fill(0,$n,0);$sof=array_fill(0,$n,0);
for($i=0;$i<$n;$i++){$et[]=($i+1)%$n;$ew[]=1+ri(9);$deg[$i]++;}
for($i=0;$i<$n;$i++)for($j=0;$j<5;$j++){$t=ri($n);$et[]=$t;$ew[]=1+ri(99);$deg[$i]++;}
$off=0;for($i=0;$i<$n;$i++){$sof[$i]=$off;$off+=$deg[$i];}
$hd=[];$hn=[];$hsz=0;
function hp($d,$nd){global$hd,$hn,$hsz;$hn[$hsz]=$nd;$hd[$hsz]=$d;$i2=$hsz;$hsz++;
 while($i2>0){$p=intdiv($i2-1,2);if($hd[$p]<=$hd[$i2])break;list($hd[$i2],$hd[$p])=[$hd[$p],$hd[$i2]];list($hn[$i2],$hn[$p])=[$hn[$p],$hn[$i2]];$i2=$p;}}
function hpop(){global$hd,$hn,$hsz;if($hsz==0)return -1;$r=$hn[0];$hsz--;$hn[0]=$hn[$hsz];$hd[0]=$hd[$hsz];$i2=0;
 while(1){$l=2*$i2+1;$r2=2*$i2+2;$s=$i2;if($l<$hsz&&$hd[$l]<$hd[$s])$s=$l;if($r2<$hsz&&$hd[$r2]<$hd[$s])$s=$r2;if($s==$i2)break;
  list($hd[$i2],$hd[$s])=[$hd[$s],$hd[$i2]];list($hn[$i2],$hn[$s])=[$hn[$s],$hn[$i2]];$i2=$s;}return$r;}
$INF=999999999;$dist=array_fill(0,$n,$INF);$vis=array_fill(0,$n,0);$dist[0]=0;hp(0,0);$start=hrtime(true);
while($hsz>0){$u=hpop();if($u<0)break;if($vis[$u]==1)continue;$vis[$u]=1;$d=$dist[$u];$base=$sof[$u];
 for($k=0;$k<$deg[$u];$k++){$v=$et[$base+$k];$w=$ew[$base+$k];$nd=$d+$w;if($nd<$dist[$v]){$dist[$v]=$nd;hp($nd,$v);}}}
$sm=0;for($i=0;$i<$n;$i++)$sm+=$dist[$i];$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: ".($sm%1000003)."\n";echo"Time: ".round($ms)."ms\n";
