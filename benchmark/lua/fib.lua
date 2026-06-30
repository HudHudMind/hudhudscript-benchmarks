function fib(n)
    if n < 2 then
        return n
    end
    return fib(n - 1) + fib(n - 2)
end

local start = os.clock()
local result = fib(30)
local finish = os.clock()
print("fib(30) = " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))

