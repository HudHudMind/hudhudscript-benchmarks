import time
n=200000;U=400000;parent=list(range(n));size=[1]*n
def find(x):
 while parent[x]!=x:x=parent[x]
 return x
def union(a,b):
 ra=find(a);rb=find(b)
 if ra!=rb:
  if size[ra]<size[rb]:parent[ra]=rb;size[rb]+=size[ra]
  else:parent[rb]=ra;size[ra]+=size[rb]
seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
start=time.time()*1000
for _ in range(U):union(ri(n),ri(n))
roots=sum(1 for i in range(n) if parent[i]==i)
end=time.time()*1000
print(f"Result: {roots}")
print(f"Time: {int(end-start)}ms")
