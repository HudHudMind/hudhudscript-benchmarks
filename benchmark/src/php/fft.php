<?php
$N=4096;$PI=3.141592653589793;$re=[];$im=[];
for($i=0;$i<$N;$i++){$re[]=sin($i*0.017)+0.5*sin($i*0.31);$im[]=0;}
$br=[];for($i=0;$i<$N;$i++){$rev=0;$p2=1;for($j=0;$j<12;$j++){$rev=$rev*2+intdiv($i,$p2)%2;$p2*=2;}$br[]=$rev;}
$R=50;$fs=0;$start=hrtime(true);
for($r=0;$r<$R;$r++){$cr=[];$ci=[];for($i=0;$i<$N;$i++){$b=$br[$i];$cr[]=$re[$b];$ci[]=$im[$b];}
 for($step=2;$step<=$N;$step*=2){$half=$step/2;$ang=(-2*$PI)/$step;$wr=cos($ang);$wi=sin($ang);
  for($k=0;$k<$N;$k+=$step){$twr=1;$twi=0;
   for($m=0;$m<$half;$m++){$ei=$k+$m;$oi=$k+$m+$half;$tr=$twr*$cr[$oi]-$twi*$ci[$oi];$ti=$twr*$ci[$oi]+$twi*$cr[$oi];
    $cr[$oi]=$cr[$ei]-$tr;$ci[$oi]=$ci[$ei]-$ti;$cr[$ei]+=$tr;$ci[$ei]+=$ti;
    $nwr=$twr;$twr=$nwr*$wr-$twi*$wi;$twi=$nwr*$wi+$twi*$wr;}}}
 $sm=0;for($i=0;$i<$N;$i++)$sm+=$cr[$i]*$cr[$i]+$ci[$i]*$ci[$i];$fs=$sm;}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: ".round($fs)."\n";echo"Time: ".round($ms)."ms\n";