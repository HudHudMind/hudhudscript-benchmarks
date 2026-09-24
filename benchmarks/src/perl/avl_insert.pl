use Time::HiRes qw(time);
my$n=100000;my$seed=12345;sub ri{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m}
my$sz=$n+10;my@key=(0)x$sz;my@left=(0)x$sz;my@right=(0)x$sz;my@height=(0)x$sz;my$nodes=0;
sub newNode{my$k=shift;$nodes++;$key[$nodes]=$k;$left[$nodes]=0;$right[$nodes]=0;$height[$nodes]=1;$nodes}
sub getH{my$nd=shift;$nd==0?0:$height[$nd]}
sub updH{my$nd=shift;my$hl=getH($left[$nd]);my$hr=getH($right[$nd]);$height[$nd]=($hl>$hr?$hl:$hr)+1}
sub bal{my$nd=shift;getH($left[$nd])-getH($right[$nd])}
sub rotR{my$y=shift;my$x=$left[$y];my$T=$right[$x];$right[$x]=$y;$left[$y]=$T;updH($y);updH($x);$x}
sub rotL{my$x=shift;my$y=$right[$x];my$T=$left[$y];$left[$y]=$x;$right[$x]=$T;updH($x);updH($y);$y}
sub insert{my($nd,$k)=@_;return newNode($k)if$nd==0;
if($k<$key[$nd]){$left[$nd]=insert($left[$nd],$k)}elsif($k>$key[$nd]){$right[$nd]=insert($right[$nd],$k)}else{return$nd}
updH($nd);my$b=bal($nd);
return rotR($nd)if$b>1&&$k<$key[$left[$nd]];return rotL($nd)if$b<-1&&$k>$key[$right[$nd]];
if($b>1&&$k>$key[$left[$nd]]){$left[$nd]=rotL($left[$nd]);return rotR($nd)}
if($b<-1&&$k<$key[$right[$nd]]){$right[$nd]=rotR($right[$nd]);return rotL($nd)}
$nd}
my$root=0;for(1..$n){$root=insert($root,ri(1000000))}
my$start=time();my$c=0;my$idx=0;my@stack;my$cur=$root;
while(@stack||$cur!=0){while($cur!=0){push@stack,$cur;$cur=$left[$cur]}$cur=pop@stack;$c=($c+$key[$cur]*($idx%13))%1000003;$idx++;$cur=$right[$cur]}
my$end=time();my$ms=($end-$start)*1000;print"Result: $height[$root]_$c\n";printf"Time: %.0fms\n",$ms;
