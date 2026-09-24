local T=300000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local pq,qh,wq,wh,sq,sh={},0,{},0,{},0;local made,acc,sunk=0,0,0;local start=os.clock()
for t=1,T do made=made+1;if made%3~=0 then wq[#wq+1]=made%100 end
 if wh<#wq then wh=wh+1;local pkt=wq[wh];acc=(acc+pkt*7)%1000003;if pkt>50 then sq[#sq+1]=pkt end end
 if sh<#sq then sh=sh+1;sunk=sunk+1 end end
local finish=os.clock();print("Result: "..made.."_"..acc.."_"..sunk);print(string.format("Time: %.0fms",(finish-start)*1000))
