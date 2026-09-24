import time
def f(x):return x*x*x-2.0*x*x+3.0
N=2000000;h=10.0/N;s=f(0)+f(10)
start=time.time()*1000
for i in range(1,N):
 x=i*h
 if i%2==0:s+=2*f(x)
 else:s+=4*f(x)
r=s*h/3
end=time.time()*1000
print(f"Result: {r}")
print(f"Time: {int(end-start)}ms")