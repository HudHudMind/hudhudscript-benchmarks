local R=20000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local parts={};for i=1,R do local id=ri(100000);local tag=ri(1000);local si=ri(1000);local sf=ri(100)
 parts[#parts+1]='{"id":'..id..',"tag":"w'..tag..'","ok":true,"score":'..si..'.'..sf..'}'
 if i<R then parts[#parts+1]=',' end end
local line='['..table.concat(parts)..']';local st,ss,num,kw=0,0,0,0;local pos=1;local L=#line;local start=os.clock()
while pos<=L do local c=line:sub(pos,pos)
 if c=='{'or c=='}'or c=='['or c==']'or c==':'or c==','then st=st+1;pos=pos+1
 elseif c=='"'then ss=ss+1;pos=pos+1;while pos<=L and line:sub(pos,pos)~='"'do pos=pos+1 end;pos=pos+1
 elseif c=='t'or c=='f'or c=='n'then kw=kw+1;pos=pos+4;if c=='f'or c=='n'then pos=pos+1 end
 else num=num+1;while pos<=L do local d=line:sub(pos,pos);if d==','or d=='}'or d==']'then break end;pos=pos+1 end end end
local finish=os.clock();print("Result: "..st.."_"..ss.."_"..num.."_"..kw);print(string.format("Time: %.0fms",(finish-start)*1000))