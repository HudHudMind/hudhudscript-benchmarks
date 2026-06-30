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

local memo = {}

local function fib_memo(n)
    if memo[n] then
        return memo[n]
    end
    memo[n] = add_big(fib_memo(n - 1), fib_memo(n - 2))
    return memo[n]
end

local start = os.clock()
local sum = {0}
for i = 1, 10000 do
    memo = {[0] = {0}, [1] = {1}}
    sum = add_big(sum, fib_memo(500))
end
local finish = os.clock()
print("Sum: " .. big_to_string(sum))
print(string.format("Time: %.0fms", (finish - start) * 1000))
