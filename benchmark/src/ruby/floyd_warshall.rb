n=150;INF=999999999;dist=Array.new(n){|i|Array.new(n){|j|i==j ?0:INF}}
seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
n.times{|i|4.times{|j|t=((i*7+j*13+1)%n);dist[i][t]=1+((i+j)%50)if t!=i}}
start=Time.now.to_f*1000
n.times{|k|n.times{|i|dik=dist[i][k];if dik!=INF;n.times{|j|nd=dik+dist[k][j];dist[i][j]=nd if nd<dist[i][j]};end}}
reach=sm=0;n.times{|i|n.times{|j|if dist[i][j]<INF;reach+=1;sm+=dist[i][j];end}}
finish=Time.now.to_f*1000;puts"Result: #{reach}_#{sm%1000003}";puts"Time: #{(finish-start).round}ms"
