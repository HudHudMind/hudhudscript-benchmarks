import time
n=100000;total=0;start=time.time()*1000
for i in range(1,n+1):
 x=i
 while x>0:total+=x%2;x//=2
end=time.time()*1000
print(f"Result: {total}")
print(f"Time: {int(end-start)}ms")