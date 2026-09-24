local BASE = 1000000000

local function mul_small(a, n)
    local result = {}
    local carry = 0
    for i = 1, #a do
        local prod = a[i] * n + carry
        result[i] = prod % BASE
        carry = prod // BASE
    end
    while carry > 0 do
        result[#result + 1] = carry % BASE
        carry = carry // BASE
    end
    return result
end

local function big_to_string(a)
    local parts = {tostring(a[#a])}
    for i = #a - 1, 1, -1 do
        parts[#parts + 1] = string.format("%09d", a[i])
    end
    return table.concat(parts)
end

local start = os.clock()
local result = {1}
for i = 2, 10000 do
    result = mul_small(result, i)
end
local finish = os.clock()
print("Result: " .. big_to_string(result))
print(string.format("Time: %.0fms", (finish - start) * 1000))
