local start = os.clock()
local function mod_exp(base, exp, mod)
    local result = 1
    local b = base % mod
    local e = exp
    while e > 0 do
        if e % 2 == 1 then
            result = (result * b) % mod
        end
        b = (b * b) % mod
        e = math.floor(e / 2)
    end
    return result
end
local s = 0
for _ = 1, 10000 do
    s = s + mod_exp(3, 1000, 1000000007)
end
local finish = os.clock()
print("Sum: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))

