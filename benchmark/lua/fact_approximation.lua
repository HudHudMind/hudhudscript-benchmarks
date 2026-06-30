-- Note: Lua float calculations overflow to inf for factorial(10000)
local start = os.clock()
local result = 1.0
for i = 2, 10000 do result = result * i end
local finish = os.clock()
print("Result: " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))