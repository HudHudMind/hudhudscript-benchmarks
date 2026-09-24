-- Note: Lua uses float for large numbers
local start = os.clock()
local function fact(n)
    if n <= 1 then return 1.0 end
    return n * fact(n - 1)
end
local result = fact(150)
local finish = os.clock()
print("fact(150) = " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))