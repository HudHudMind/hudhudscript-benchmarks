T=300000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
pq=[];qh=0;wq=[];wh=0;sq=[];sh=0;made=acc=sunk=0
start=Time.now.to_f*1000
T.times{made+=1
 if made%3!=0;wq<<made%100;end
 if wh<wq.length;pkt=wq[wh];wh+=1;acc=(acc+pkt*7)%1000003
  if pkt>50;sq<<pkt;end;end
 if sh<sq.length;sh+=1;sunk+=1;end}
finish=Time.now.to_f*1000
puts"Result: #{made}_#{acc}_#{sunk}";puts"Time: #{(finish-start).round}ms"