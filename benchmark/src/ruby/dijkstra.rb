n=20000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
et=[];ew=[];deg=[0]*n;sof=[0]*n
n.times{|i|et<<(i+1)%n;ew<<1+ri(9);deg[i]+=1}
n.times{|i|5.times{t=ri(n);et<<t;ew<<1+ri(99);deg[i]+=1}}
off=0;n.times{|i|sof[i]=off;off+=deg[i]}
$hd=[];$hn=[];$hsz=0
def hp(d,nd);$hn[$hsz]=nd;$hd[$hsz]=d;i=$hsz;$hsz+=1
 while i>0;p=(i-1)/2;break if $hd[p]<=$hd[i];$hd[i],$hd[p]=$hd[p],$hd[i];$hn[i],$hn[p]=$hn[p],$hn[i];i=p;end;end
def hpop;return -1 if $hsz==0;r=$hn[0];$hsz-=1;$hn[0]=$hn[$hsz];$hd[0]=$hd[$hsz];i=0
 while true;l=2*i+1;r2=2*i+2;s=i;s=l if l<$hsz&&$hd[l]<$hd[s];s=r2 if r2<$hsz&&$hd[r2]<$hd[s];break if s==i
  $hd[i],$hd[s]=$hd[s],$hd[i];$hn[i],$hn[s]=$hn[s],$hn[i];i=s;end;r;end
INF=999999999;dist=[INF]*n;vis=[0]*n;dist[0]=0;hp(0,0)
start=Time.now.to_f*1000
while $hsz>0;u=hpop;break if u<0;next if vis[u]==1;vis[u]=1;d=dist[u];base=sof[u]
 k=0;while k<deg[u];v=et[base+k];w=ew[base+k];nd=d+w
  if nd<dist[v];dist[v]=nd;hp(nd,v);end;k+=1;end;end
sm=0;n.times{|i|sm=(sm+dist[i])%1000003}
finish=Time.now.to_f*1000;puts"Result: #{sm}";puts"Time: #{(finish-start).round}ms"
