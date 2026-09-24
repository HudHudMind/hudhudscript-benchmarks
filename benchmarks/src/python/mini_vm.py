import time
I=300000;acc=0;c=I
start=time.time()*1000
while c>0:
 op=c%10
 if op==0:acc=(acc*3+c)%1000003;c-=1
 elif op==1:acc=(acc*3+c)%1000003;c-=1
 elif op==2:acc=(acc*3+c)%1000003;c-=1
 elif op==3:acc=(acc*3+c)%1000003;c-=1
 elif op==4:acc=(acc*3+c)%1000003;c-=1
 elif op==5:acc=(acc*3+c)%1000003;c-=1
 elif op==6:acc=(acc*3+c)%1000003;c-=1
 elif op==7:acc=(acc*3+c)%1000003;c-=1
 elif op==8:acc=(acc*3+c)%1000003;c-=1
 else:acc=(acc*3+c)%1000003;c-=1
end=time.time()*1000
print(f"Result: {acc}")
print(f"Time: {int(end-start)}ms")