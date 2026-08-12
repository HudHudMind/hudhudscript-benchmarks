-- Note: Lua uses float for large numbers
local start = os.clock()
local memo = {}
local function fib_memo(n)
    if n <= 1 then return n + 0.0 end
    if memo[n] then return memo[n] end
    memo[n] = fib_memo(n - 1) + fib_memo(n - 2)
    return memo[n]
end
local sum = 0.0
for i = 1, 10000 do
    memo = {}
    sum = sum + fib_memo(500)
end
local finish = os.clock()
print("Sum: " .. sum)
print(string.format("Time: %.0fms", (finish - start) * 1000))