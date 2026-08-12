import time
C=65536;keys=[0]*C;vals=[0]*C;state=[0]*C
seed=12345
def ri(n):
 global seed;seed=(seed*16807)%2147483647;return seed%n
I,L,D=40000,80000,20000
fnd=dlt=acc=0;start=time.time()*1000
for _ in range(I):
 k=ri(1000000)+1;h=(k*16807)%C
 while state[h]==1:h=(h+1)%C
 keys[h]=k;vals[h]=k%97;state[h]=1
for _ in range(L):
 k=ri(1000000)+1;h=(k*16807)%C
 while state[h]!=0:
  if state[h]==1 and keys[h]==k:fnd+=1;acc=(acc+vals[h])%1000003;break
  h=(h+1)%C
for _ in range(D):
 k=ri(1000000)+1;h=(k*16807)%C
 while state[h]!=0:
  if state[h]==1 and keys[h]==k:state[h]=2;dlt+=1;break
  h=(h+1)%C
end=time.time()*1000
print(f"Result: {fnd}_{dlt}_{acc}")
print(f"Time: {int(end-start)}ms")