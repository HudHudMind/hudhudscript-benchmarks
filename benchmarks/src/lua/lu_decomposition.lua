local n=200;local A={}
for i=1,n do A[i]={};for j=1,n do A[i][j]=((i-1)*31+(j-1)*17)%100+1+(i==j and 1000 or 0)end end
local start=os.clock()
for k=1,n do for i=k+1,n do local f=A[i][k]/A[k][k]
  for j=1,n do A[i][j]=A[i][j]-f*A[k][j]end;A[i][k]=f end end
local s=0;for i=1,n do s=s+A[i][i]end;local r=math.floor(s/n*1000+0.5)
local finish=os.clock();print("Result: "..r);print(string.format("Time: %.0fms",(finish-start)*1000))