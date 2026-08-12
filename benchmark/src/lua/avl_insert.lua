local n=100000;local seed=12345
local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local sz=n+10;local key,left,right,height={},{},{},{}
for i=1,sz do key[i]=0;left[i]=0;right[i]=0;height[i]=0 end
local nodes=0
local function newNode(k)nodes=nodes+1;key[nodes]=k;left[nodes]=0;right[nodes]=0;height[nodes]=1;return nodes end
local function getH(nd)if nd==0 then return 0 else return height[nd]end end
local function updH(nd)local hl=getH(left[nd]);local hr=getH(right[nd]);height[nd]=(hl>hr and hl or hr)+1 end
local function bal(nd)return getH(left[nd])-getH(right[nd])end
local function rotR(y)local x=left[y];local T=right[x];right[x]=y;left[y]=T;updH(y);updH(x);return x end
local function rotL(x)local y=right[x];local T=left[y];left[y]=x;right[x]=T;updH(x);updH(y);return y end
local function insert(nd,k)
 if nd==0 then return newNode(k)end
 if k<key[nd]then left[nd]=insert(left[nd],k)
 elseif k>key[nd]then right[nd]=insert(right[nd],k)
 else return nd end
 updH(nd);local b=bal(nd)
 if b>1 and k<key[left[nd]]then return rotR(nd)end
 if b<-1 and k>key[right[nd]]then return rotL(nd)end
 if b>1 and k>key[left[nd]]then left[nd]=rotL(left[nd]);return rotR(nd)end
 if b<-1 and k<key[right[nd]]then right[nd]=rotR(right[nd]);return rotL(nd)end
 return nd
end
local root=0;for _=1,n do root=insert(root,ri(1000000))end
local start=os.clock();local c=0;local idx=0;local stack={};local cur=root
while #stack>0 or cur~=0 do while cur~=0 do stack[#stack+1]=cur;cur=left[cur]end;cur=table.remove(stack);c=(c+key[cur]*(idx%13))%1000003;idx=idx+1;cur=right[cur]end
local finish=os.clock();print("Result: "..height[root].."_"..c);print(string.format("Time: %.0fms",(finish-start)*1000))