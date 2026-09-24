$nodes=1;$children=[0]*26;$terminal=[0]
W=20000;$seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end
def nc;$nodes+=1;26.times{$children<<0};$terminal<<0;$nodes-1;end
start=Time.now.to_f*1000;W.times{l=3+ri(6);cur=0
 l.times{c=ri(26);idx=cur*26+c
  if $children[idx]==0;$children[idx]=nc;end
  cur=$children[idx]}
 $terminal[cur]=1}
hits=0;$seed=12345
W.times{l=3+ri(6);cur=0
 l.times{c=ri(26);idx=cur*26+c
  if $children[idx]==0;cur=0;break;end;cur=$children[idx]}
 hits+=1 if cur!=0&&$terminal[cur]==1}
$seed=54321
W.times{l=3+ri(6);cur=0
 l.times{c=ri(26);idx=cur*26+c
  if $children[idx]==0;cur=0;break;end;cur=$children[idx]}
 hits+=1 if cur!=0&&$terminal[cur]==1}
finish=Time.now.to_f*1000;puts"Result: #{$nodes}_#{hits}";puts"Time: #{(finish-start).round}ms"
