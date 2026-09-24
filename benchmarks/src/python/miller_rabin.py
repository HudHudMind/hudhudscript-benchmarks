import time
seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
def pm(b,e,m):
 r=1
 while e>0:
  if e&1:r=(r*b)%m
  e>>=1;b=(b*b)%m
 return r
def ip(n):
 if n<2:return 0
 if n==2:return 1
 if n%2==0:return 0
 d=n-1;s=0
 while d%2==0:d>>=1;s+=1
 for a in[2,3,5,7]:
  if a>=n:continue
  x=pm(a,d,n)
  if x==1 or x==n-1:continue
  for _ in range(s-1):
   x=(x*x)%n
   if x==n-1:break
  if x!=n-1:return 0
 return 1
K=2000;cnt=0;start=time.time()*1000
for _ in range(K):
 n=1000000001+2*ri(500000000)
 if ip(n):cnt+=1
end=time.time()*1000
print(f"Result: {cnt}")
print(f"Time: {int(end-start)}ms")