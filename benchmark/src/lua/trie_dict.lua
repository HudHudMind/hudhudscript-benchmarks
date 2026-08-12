local W=20000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local nodes=1;local children={};for i=1,26 do children[i]=0 end;local terminal={0}
local function nc()nodes=nodes+1;for i=1,26 do children[#children+1]=0 end;terminal[#terminal+1]=0;return nodes-1 end
local start=os.clock()
for _=1,W do local l=3+ri(6);local cur=0
 for _=1,l do local c=ri(26);local idx=cur*26+c+1
  if children[idx]==0 then children[idx]=nc()end;cur=children[idx]end
 terminal[cur+1]=1 end
local hits=0;seed=12345
for _=1,W do local l=3+ri(6);local cur=0
 for _=1,l do local c=ri(26);local idx=cur*26+c+1
  if children[idx]==0 then cur=0;break end;cur=children[idx]end
 if cur~=0 and terminal[cur+1]==1 then hits=hits+1 end end
seed=54321
for _=1,W do local l=3+ri(6);local cur=0
 for _=1,l do local c=ri(26);local idx=cur*26+c+1
  if children[idx]==0 then cur=0;break end;cur=children[idx]end
 if cur~=0 and terminal[cur+1]==1 then hits=hits+1 end end

local finish=os.clock()
print("Result: "..nodes.."_"..hits)
print(string.format("Time: %.0fms",(finish-start)*1000))