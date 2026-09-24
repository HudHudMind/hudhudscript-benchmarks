-- Note: Lua uses float for large numbers
local start = os.clock()
local function power(base, exp)
    local result = 1.0
    for i = 1, exp do result = result * base end
    return result
end
local sum = 0.0
for i = 1, 10000 do sum = sum + power(2.0, 1000) end
local finish = os.clock()
print("Sum: " .. sum)
print(string.format("Time: %.0fms", (finish - start) * 1000))