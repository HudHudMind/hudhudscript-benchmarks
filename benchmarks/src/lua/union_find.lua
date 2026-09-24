local n=200000;local U=400000;local parent={};local size={}
for i=1,n do parent[i]=i;size[i]=1 end
local function find(x) while parent[x]~=x do x=parent[x] end;return x end
local function union(a,b) local ra=find(a);local rb=find(b)
 if ra~=rb then if size[ra]<size[rb] then parent[ra]=rb;size[rb]=size[rb]+size[ra] else parent[rb]=ra;size[ra]=size[ra]+size[rb] end end end
local seed=12345;local function ri(m) seed=(seed*16807)%2147483647;return seed%m end
local start=os.clock()
for i=1,U do union(ri(n)+1,ri(n)+1) end
local roots=0;for i=1,n do if parent[i]==i then roots=roots+1 end end
local finish=os.clock()
print("Result: "..roots);print(string.format("Time: %.0fms",(finish-start)*1000))
