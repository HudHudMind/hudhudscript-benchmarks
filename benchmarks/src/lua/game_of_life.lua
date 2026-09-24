local G=96;local T=100;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local a,b={},{}
for i=1,G do a[i]={};b[i]={};for j=1,G do a[i][j]=ri(100)<35 and 1 or 0;b[i][j]=0 end end
local start=os.clock()
for t=1,T do for i=1,G do for j=1,G do local nbr=0
 for di=-1,1 do for dj=-1,1 do if not(di==0 and dj==0)then local ni=(i+di-1)%G+1;local nj=(j+dj-1)%G+1;nbr=nbr+a[ni][nj]end end end
 b[i][j]=a[i][j]==1 and(nbr==2 or nbr==3)and 1 or a[i][j]==0 and nbr==3 and 1 or 0
end end;local t2=a;a=b;b=t2 end
local alive=0;for i=1,G do for j=1,G do alive=alive+a[i][j]end end
local finish=os.clock();print("Result: "..alive);print(string.format("Time: %.0fms",(finish-start)*1000))
