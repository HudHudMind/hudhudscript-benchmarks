import time
M=500000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
d=['w'+str(i) for i in range(2000)]
c={w:0 for w in d}
start=time.time()*1000
for _ in range(M):c[d[ri(2000)]]+=1
mc=0;mw=''
for w in d:
 v=c[w]
 if mc==0:mc=v;mw=w
 elif v>mc:mc=v;mw=w
end=time.time()*1000
print(f"Result: {mc}_{mw}")
print(f"Time: {int(end-start)}ms")