import time
M=400000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
syms=[];i=0
while i<M:
 if i>=20 and ri(10)<4:
  start=i-20
  for j in range(20):syms.append(syms[start+j])
  i+=20
 else:syms.append(ri(4));i+=1
DS=4096;dic=[0]*(DS*4);nc=5;out=[];cur=syms[0]+1;i=1
start=time.time()*1000
while i<len(syms):
 s=syms[i];cand=dic[cur*4+s]
 if cand!=0:cur=cand
 else:
  out.append(cur)
  if nc<DS:dic[cur*4+s]=nc;nc+=1
  cur=s+1
 i+=1
out.append(cur);oc=len(out);sm=0
for j in range(oc):sm=(sm+out[j]*j)%1000003
end=time.time()*1000
print(f"Result: {oc}_{sm}")
print(f"Time: {int(end-start)}ms")