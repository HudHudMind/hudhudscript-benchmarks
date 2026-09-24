import time
T=300000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
pq=[];qh=0;wq=[];wh=0;sq=[];sh=0;made=acc=sunk=0
start=time.time()*1000
for t in range(T):
 made+=1
 if made%3!=0:wq.append(made%100)
 if wh<len(wq):
  pkt=wq[wh];wh+=1;acc=(acc+pkt*7)%1000003
  if pkt>50:sq.append(pkt)
 if sh<len(sq):sh+=1;sunk+=1
end=time.time()*1000
print(f"Result: {made}_{acc}_{sunk}")
print(f"Time: {int(end-start)}ms")