local function f(x)return x*x*x-2*x*x+3 end
local N=2000000;local h=10/N;local s=f(0)+f(10)
local start=os.clock()
for i=1,N-1 do local x=i*h;if i%2==0 then s=s+2*f(x)else s=s+4*f(x)end end
local r=s*h/3;local finish=os.clock()
print("Result: "..r);print(string.format("Time: %.0fms",(finish-start)*1000))
