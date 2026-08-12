local function f3(i) if i%7==0 then error("boom") end;return i*2 end
local function f2(i) return f3(i) end
local function f1(i) return f2(i) end
local N=200000;local acc,caught=0,0;local start=os.clock()
for i=1,N do local ok,res=pcall(f1,i);if ok then acc=(acc+res)%1000003 else caught=caught+1 end end
local finish=os.clock();print("Result: "..acc.."_"..caught);print(string.format("Time: %.0fms",(finish-start)*1000))
