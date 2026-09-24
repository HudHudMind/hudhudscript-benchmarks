import time
N=20000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
arr=['w'+str(ri(100000)) for _ in range(N)]
def ms(a):
 if len(a)<=1:return a
 m=len(a)//2;L=ms(a[:m]);R=ms(a[m:]);res=[];pi=qi=0
 while pi<len(L):
  if qi>=len(R):break
  if L[pi]<=R[qi]:res.append(L[pi]);pi+=1
  else:res.append(R[qi]);qi+=1
 res.extend(L[pi:]);res.extend(R[qi:]);return res
start=time.time()*1000
s=ms(arr)
acc=sum(len(s[i])*(i%13) for i in range(N))%1000003
end=time.time()*1000
print(f"Result: {acc}")
print(f"Time: {int(end-start)}ms")