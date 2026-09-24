import time
n=150;INF=999999999
dist=[[0 if i==j else INF for j in range(n)] for i in range(n)]
seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
for i in range(n):
 for j in range(4):
  t=(i*7+j*13+1)%n
  if t!=i:dist[i][t]=1+((i+j)%50)
start=time.time()*1000
for k in range(n):
 for i in range(n):
  dik=dist[i][k]
  if dik!=INF:
   for j in range(n):
    nd=dik+dist[k][j]
    if nd<dist[i][j]:dist[i][j]=nd
reach=sum(1 for i in range(n) for j in range(n) if dist[i][j]<INF)
sm=sum(dist[i][j] for i in range(n) for j in range(n) if dist[i][j]<INF)
end=time.time()*1000
print(f"Result: {reach}_{sm%1000003}")
print(f"Time: {int(end-start)}ms")