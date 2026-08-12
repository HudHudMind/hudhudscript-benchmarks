import time
R=20000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
parts=[]
for i in range(R):
 id=ri(100000);tag=ri(1000);si=ri(1000);sf=ri(100)
 parts.append('{"id":'+str(id)+',"tag":"w'+str(tag)+'","ok":true,"score":'+str(si)+'.'+str(sf)+'}')
 if i<R-1:parts.append(',')
line='['+''.join(parts)+']'
st=ss=num=kw=0;pos=0;L=len(line)
start=time.time()*1000
while pos<L:
 c=line[pos]
 if c in'{[}]:,':st+=1;pos+=1
 elif c=='"':
  ss+=1;pos+=1
  while pos<L and line[pos]!='"':pos+=1
  pos+=1
 elif c in'tfn':
  kw+=1;pos+=4
  if c in'fn':pos+=1
 else:
  num+=1
  while pos<L and line[pos]not in',}]':pos+=1
end=time.time()*1000
print(f"Result: {st}_{ss}_{num}_{kw}")
print(f"Time: {int(end-start)}ms")