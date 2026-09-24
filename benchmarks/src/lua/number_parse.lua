local n=200000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local strings={};for _=1,n do local s="";if ri(2)==0 then s="-" end;local nd=1+ri(9);s=s..tostring(1+ri(9));for _=2,nd do s=s..tostring(ri(10))end;strings[#strings+1]=s end
local start=os.clock();local total=0;local M=1000003
for _,s in ipairs(strings)do local neg=false;local idx=1;if s:sub(1,1)=="-" then neg=true;idx=2 end;local val=0
while idx<=#s do local c=s:sub(idx,idx);local d;if c=="0"then d=0 elseif c=="1"then d=1 elseif c=="2"then d=2 elseif c=="3"then d=3 elseif c=="4"then d=4 elseif c=="5"then d=5 elseif c=="6"then d=6 elseif c=="7"then d=7 elseif c=="8"then d=8 else d=9 end
val=val*10+d;idx=idx+1 end;if neg then val=-val end;total=total+val end
local r=((total%M)+M)%M;local finish=os.clock();print("Result: "..r);print(string.format("Time: %.0fms",(finish-start)*1000))
