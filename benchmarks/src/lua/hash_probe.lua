local C=65536;local keys={};local vals={};local state={}
for i=1,C do keys[i]=0;vals[i]=0;state[i]=0 end
local seed=12345;local function ri(n)seed=(seed*16807)%2147483647;return seed%n end
local I,L,D=40000,80000,20000;local fnd,dlt,acc=0,0,0;local start=os.clock()
for j=1,I do local k=ri(1000000)+1;local h=(k*16807)%C+1;while state[h]==1 do h=(h%C)+1 end;keys[h]=k;vals[h]=k%97;state[h]=1 end
for m=1,L do local k=ri(1000000)+1;local h=(k*16807)%C+1;while state[h]~=0 do if state[h]==1 and keys[h]==k then fnd=fnd+1;acc=(acc+vals[h])%1000003;break end;h=(h%C)+1 end end
for n=1,D do local k=ri(1000000)+1;local h=(k*16807)%C+1;while state[h]~=0 do if state[h]==1 and keys[h]==k then state[h]=2;dlt=dlt+1;break end;h=(h%C)+1 end end
local finish=os.clock();print("Result: "..fnd.."_"..dlt.."_"..acc);print(string.format("Time: %.0fms",(finish-start)*1000))
