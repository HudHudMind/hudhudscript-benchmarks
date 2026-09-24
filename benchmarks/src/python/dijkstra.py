import time
n=20000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
et=[];ew=[];deg=[0]*n;sof=[0]*n
for i in range(n):et.append((i+1)%n);ew.append(1+ri(9));deg[i]+=1
for i in range(n):
 for j in range(5):t=ri(n);et.append(t);ew.append(1+ri(99));deg[i]+=1
off=0
for i in range(n):sof[i]=off;off+=deg[i]
hd=[];hn=[];hsz=0
def hp(d,nd):
 global hsz
 if hsz<len(hn):hn[hsz]=nd;hd[hsz]=d
 else:hn.append(nd);hd.append(d)
 i2=hsz;hsz+=1
 while i2>0:
  p=(i2-1)//2
  if hd[p]<=hd[i2]:break
  hd[i2],hd[p]=hd[p],hd[i2];hn[i2],hn[p]=hn[p],hn[i2];i2=p
def hpop():
 global hsz
 if hsz==0:return -1
 r=hn[0];hsz-=1;hn[0]=hn[hsz];hd[0]=hd[hsz];i2=0
 while 1:
  l=2*i2+1;r2=2*i2+2;s=i2
  if l<hsz and hd[l]<hd[s]:s=l
  if r2<hsz and hd[r2]<hd[s]:s=r2
  if s==i2:break
  hd[i2],hd[s]=hd[s],hd[i2];hn[i2],hn[s]=hn[s],hn[i2];i2=s
 return r
INF=999999999;dist=[INF]*n;vis=[0]*n;dist[0]=0;hp(0,0)
start=time.time()*1000
while hsz>0:
 u=hpop()
 if u<0:break
 if vis[u]==1:continue
 vis[u]=1;d=dist[u];base=sof[u];k=0
 while k<deg[u]:
  v=et[base+k];w=ew[base+k];nd=d+w
  if nd<dist[v]:dist[v]=nd;hp(nd,v)
  k+=1
sm=sum(dist)%1000003
end=time.time()*1000
print(f"Result: {sm}")
print(f"Time: {int(end-start)}ms")