local BASE = 1000000000

local function add_big(a, b)
    local n = #a
    if #b > n then
        n = #b
    end
    local result = {}
    local carry = 0
    for i = 1, n do
        local sum = (a[i] or 0) + (b[i] or 0) + carry
        if sum >= BASE then
            sum = sum - BASE
            carry = 1
        else
            carry = 0
        end
        result[i] = sum
    end
    if carry > 0 then
        result[#result + 1] = carry
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

local function fib(n)
    if n == 0 then
        return {0}
    end
    if n == 1 then
        return {1}
    end
    local a = {0}
    local b = {1}
    for i = 2, n do
        local temp = add_big(a, b)
        a = b
        b = temp
    end
    return b
end

local start = os.clock()
local sum = {0}
for i = 1, 10000 do
    sum = add_big(sum, fib(1000))
end
local finish = os.clock()
print("Sum: " .. big_to_string(sum))
print(string.format("Time: %.0fms", (finish - start) * 1000))
