local n=50000;local s=string.rep("a",n);local start=os.clock()
local buf={};for i=#s,1,-1 do buf[#buf+1]=s:sub(i,i)end;local r=table.concat(buf)
local finish=os.clock();print("Result: "..r:sub(1,1).."/"..#r);print(string.format("Time: %.0fms",(finish-start)*1000))