local n=100000;local total=0;local start=os.clock()
for i=1,n do local x=i
 while x>0 do total=total+(x%2);x=math.floor(x/2) end end
local finish=os.clock();print("Result: "..total);print(string.format("Time: %.0fms",(finish-start)*1000))