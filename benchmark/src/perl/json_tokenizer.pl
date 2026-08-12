use Time::HiRes qw(time);
my$R=20000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my@parts;for my$i(0..$R-1){my$id=$ri->(100000);my$tag=$ri->(1000);my$si=$ri->(1000);my$sf=$ri->(100);
 push@parts,'{"id":'.$id.',"tag":"w'.$tag.'","ok":true,"score":'.$si.'.'.$sf.'}';push@parts,','if$i<$R-1}
my$line='['.join('',@parts).']';my($st,$ss,$num,$kw,$pos,$L)=(0,0,0,0,0,length$line);my$start=time();
while($pos<$L){my$c=substr($line,$pos,1);
 if($c=~/[{[}\]:,]/){$st++;$pos++}
 elsif($c eq'"'){$ss++;$pos++;$pos++ while$pos<$L&&substr($line,$pos,1)ne'"';$pos++}
 elsif($c=~/[tfn]/){$kw++;$pos+=4;$pos++ if$c=~/[fn]/}
 else{$num++;$pos++ while$pos<$L&&substr($line,$pos,1)!~/[,}\]]/}}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${st}_${ss}_${num}_${kw}\n";printf"Time: %.0fms\n",$ms;