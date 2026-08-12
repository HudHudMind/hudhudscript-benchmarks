local M=500000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local dict={};for i=1,2000 do dict[i]="w"..(i-1) end
local counts={};for i=1,2000 do counts[dict[i]]=0 end
local start=os.clock()
for i=1,M do local w=dict[ri(2000)+1];counts[w]=counts[w]+1 end
local mc=0;local mw=""
for i=1,2000 do local w=dict[i];local v=counts[w]
 if mc==0 then mc=v;mw=w elseif v>mc then mc=v;mw=w end end
local finish=os.clock()
print("Result: "..mc.."_"..mw);print(string.format("Time: %.0fms",(finish-start)*1000))
