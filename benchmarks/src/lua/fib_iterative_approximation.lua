-- Note: Lua uses float for large numbers
local start = os.clock()
local function fib(n)
    if n <= 1 then return n + 0.0 end
    local a, b = 0.0, 1.0
    for i = 2, n do
        local temp = a + b
        a = b
        b = temp
    end
    return b
end
local s = 0.0
for i = 1, 10000 do s = s + fib(1000) end
local finish = os.clock()
print("Sum: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))