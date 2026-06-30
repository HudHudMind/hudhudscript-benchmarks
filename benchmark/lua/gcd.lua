local start = os.clock()
local function gcd(a, b)
    while b ~= 0 do
        local temp = b
        b = a % b
        a = temp
    end
    return a
end
local result = 0
for i = 1, 10000 do
    result = gcd(i * 12345, i * 6789 + 1)
end
local finish = os.clock()
print("Result: " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))

