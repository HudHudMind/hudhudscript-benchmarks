use Time::HiRes qw(time);
my$N=100000;my$Q=10000;my@arr;for my$i(0..$N-1){$arr[$i]=2*$i}
my$start=time();my$found=0;
for my$j(0..$Q-1){my$target=20*$j;my($left,$right)=(0,$N-1);
 while($left<=$right){my$mid=int(($left+$right)/2);
  if($arr[$mid]==$target){$found++;last}
  elsif($arr[$mid]<$target){$left=$mid+1}else{$right=$mid-1}}}
my$end=time();my$ms=($end-$start)*1000;print"Result: $found\n";printf"Time: %.0fms\n",$ms;