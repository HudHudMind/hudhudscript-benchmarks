use Time::HiRes qw(time);
my$W=20000;my$seed=12345;my$ri=sub{my$m=shift;$seed=($seed*16807)%2147483647;$seed%$m};
my$nodes=1;my@children=(0)x26;my@terminal=(0);
sub nc{for(1..26){push@children,0}push@terminal,0;$nodes++;$nodes-1}
my$start=time();
for(1..$W){my$l=3+$ri->(6);my$cur=0;for(1..$l){my$c=$ri->(26);my$idx=$cur*26+$c;$children[$idx]=nc()if!$children[$idx];$cur=$children[$idx]}$terminal[$cur]=1}
my$hits=0;$seed=12345;
for(1..$W){my$l=3+$ri->(6);my$cur=0;for(1..$l){my$c=$ri->(26);my$idx=$cur*26+$c;if(!$children[$idx]){$cur=0;last}$cur=$children[$idx]}$hits++ if$cur&&$terminal[$cur]==1}
$seed=54321;
for(1..$W){my$l=3+$ri->(6);my$cur=0;for(1..$l){my$c=$ri->(26);my$idx=$cur*26+$c;if(!$children[$idx]){$cur=0;last}$cur=$children[$idx]}$hits++ if$cur&&$terminal[$cur]==1}
my$end=time();my$ms=($end-$start)*1000;print"Result: ${nodes}_${hits}\n";printf"Time: %.0fms\n",$ms;
