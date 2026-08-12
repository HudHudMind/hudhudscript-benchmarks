use Time::HiRes qw(time);
my$N=4096;my$PI=3.141592653589793;my(@re,@im);
for my$i(0..$N-1){$re[$i]=sin($i*0.017)+0.5*sin($i*0.31);$im[$i]=0}
my@br;for my$i(0..$N-1){my($rev,$p2)=(0,1);for(1..12){$rev=$rev*2+int($i/$p2)%2;$p2*=2}push@br,$rev}
my$R=50;my$fs=0;my$start=time();
for(1..$R){my(@cr,@ci);for my$i(0..$N-1){my$b=$br[$i];$cr[$i]=$re[$b];$ci[$i]=$im[$b]}
 for(my$step=2;$step<=$N;$step*=2){my$half=$step/2;my$ang=(-2*$PI)/$step;my$wr=cos($ang);my$wi=sin($ang);
  for(my$k=0;$k<$N;$k+=$step){my($twr,$twi)=(1,0);
   for my$m(0..$half-1){my$ei=$k+$m;my$oi=$k+$m+$half;my$tr=$twr*$cr[$oi]-$twi*$ci[$oi];my$ti=$twr*$ci[$oi]+$twi*$cr[$oi];
    $cr[$oi]=$cr[$ei]-$tr;$ci[$oi]=$ci[$ei]-$ti;$cr[$ei]+=$tr;$ci[$ei]+=$ti;
    my$nwr=$twr;$twr=$nwr*$wr-$twi*$wi;$twi=$nwr*$wi+$twi*$wr}}}
 my$sm=0;$sm+=$cr[$_]*$cr[$_]+$ci[$_]*$ci[$_]for 0..$N-1;$fs=$sm}
my$end=time();my$ms=($end-$start)*1000;my$r=int($fs+0.5);print"Result: $r\n";printf"Time: %.0fms\n",$ms;