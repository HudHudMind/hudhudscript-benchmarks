local start = os.clock()
local coeffs = {}
for i = 1, 1001 do coeffs[i] = i end
local function horner(c, x)
    local result = c[#c]
    for i = #c - 1, 1, -1 do
        result = result * x + c[i]
    end
    return result
end
local s = 0
for _ = 1, 100000 do
    s = s + horner(coeffs, 1.5)
end
local finish = os.clock()
print("Sum: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))

