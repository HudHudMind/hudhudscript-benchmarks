import time
G=96;T=100;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
a=[[1 if ri(100)<35 else 0 for _ in range(G)] for _ in range(G)]
b=[[0]*G for _ in range(G)]
start=time.time()*1000
for _ in range(T):
 for i in range(G):
  for j in range(G):
   nbr=0
   for di in(-1,0,1):
    for dj in(-1,0,1):
     if di==0 and dj==0:continue
     nbr+=a[(i+di)%G][(j+dj)%G]
   b[i][j]=1 if(a[i][j]==1 and nbr in(2,3))or(a[i][j]==0 and nbr==3) else 0
 a,b=b,a
alive=0
for i in range(G):
 for j in range(G):
  alive+=a[i][j]
end=time.time()*1000
print(f"Result: {alive}")
print(f"Time: {int(end-start)}ms")