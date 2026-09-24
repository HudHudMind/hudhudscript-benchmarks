local M=400000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local syms={};local i=0
while i<M do if i>=20 and ri(10)<4 then local s=i-20;for j=1,20 do syms[#syms+1]=syms[s+j]end;i=i+20 else syms[#syms+1]=ri(4);i=i+1 end end
local DS=4096;local dic={};for j=1,DS*4 do dic[j]=0 end
local nc=5;local out={};local cur=syms[1]+1;i=2;local start=os.clock()
while i<=#syms do local s=syms[i];local cand=dic[cur*4+s+1];if cand~=0 then cur=cand else out[#out+1]=cur
 if nc<DS then dic[cur*4+s+1]=nc;nc=nc+1 end;cur=s+1 end;i=i+1 end
out[#out+1]=cur;local oc=#out;local sm=0;for j=1,oc do sm=(sm+out[j]*(j-1))%1000003 end
local finish=os.clock();print("Result: "..oc.."_"..sm);print(string.format("Time: %.0fms",(finish-start)*1000))