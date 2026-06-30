local function sqrt_newton(n)
    if n == 0 then
        return 0
    end
    local x = n / 2.0
    for _ = 1, 20 do
        x = (x + n / x) / 2.0
    end
    return x
end

local start = os.clock()
local s = 0.0
for i = 1, 10000 do
    s = s + sqrt_newton(i)
end
local finish = os.clock()
print("Sum: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))

