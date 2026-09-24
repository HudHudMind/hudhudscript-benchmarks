import time
n=200;A=[[((i*31+j*17)%100+1)*1.0+(1000 if i==j else 0) for j in range(n)] for i in range(n)]
start=time.time()*1000
for k in range(n):
 for i in range(k+1,n):
  f=A[i][k]/A[k][k]
  for j in range(n):A[i][j]-=f*A[k][j]
  A[i][k]=f
s=sum(A[i][i] for i in range(n))
r=round(s/n*1000)
end=time.time()*1000
print(f"Result: {r}")
print(f"Time: {int(end-start)}ms")