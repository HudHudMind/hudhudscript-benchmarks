import time
n=50000;s="a"*n;start=time.time()*1000
buf=[];i=n-1
while i>=0:buf.append(s[i]);i-=1
r=''.join(buf)
end=time.time()*1000;print(f"Result: {r[0]}/{len(r)}");print(f"Time: {int(end-start)}ms")