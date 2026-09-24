import time,math
N=4096;PI=3.141592653589793
re=[math.sin(i*0.017)+0.5*math.sin(i*0.31) for i in range(N)]
im=[0.0]*N
bit_rev=[0]*N;bits=12
for i in range(N):
 rev=0;pow2=1
 for j in range(bits):rev=(rev*2)+((i//pow2)%2);pow2*=2
 bit_rev[i]=rev
R=50;final_sum=0.0;start=time.time()*1000
for _ in range(R):
 cre=[0.0]*N;cim=[0.0]*N
 for i in range(N):br=bit_rev[i];cre[i]=re[br];cim[i]=im[br]
 step=2
 while step<=N:
  half=step//2;angle=(-2*PI)/step;wr=math.cos(angle);wi=math.sin(angle)
  k=0
  while k<N:
   twr=1.0;twi=0.0;m=0
   while m<half:
    ei=k+m;oi=k+m+half
    tr=twr*cre[oi]-twi*cim[oi];ti=twr*cim[oi]+twi*cre[oi]
    cre[oi]=cre[ei]-tr;cim[oi]=cim[ei]-ti
    cre[ei]=cre[ei]+tr;cim[ei]=cim[ei]+ti
    nwr=twr;twr=nwr*wr-twi*wi;twi=nwr*wi+twi*wr;m+=1
   k+=step
  step*=2
 sm=0.0
 for i in range(N):sm+=cre[i]*cre[i]+cim[i]*cim[i]
 final_sum=sm
r=round(final_sum)
end=time.time()*1000
print(f"Result: {r}")
print(f"Time: {int(end-start)}ms")