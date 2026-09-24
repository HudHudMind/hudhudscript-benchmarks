-- LuaJIT (Lua 5.1) uyarlaması: b*b çarpımı 2^53'ü aştığı için mulmod (double-and-add)
-- Orijinal: benchmarks/src/lua/modular_exp.lua (dokunulmaz)
local start = os.clock()
local function mulmod(a, b, m)
    local r = 0
    a = a % m
    while b > 0 do
        if b % 2 == 1 then r = (r + a) % m end
        a = (a + a) % m
        b = math.floor(b / 2)
    end
    return r
end
local function mod_exp(base, exp, mod)
    local result = 1
    local b = base % mod
    local e = exp
    while e > 0 do
        if e % 2 == 1 then
            result = mulmod(result, b, mod)
        end
        b = mulmod(b, b, mod)
        e = math.floor(e / 2)
    end
    return result
end
local s = 0
for _ = 1, 10000 do
    s = s + mod_exp(3, 1000, 1000000007)
end
local finish = os.clock()
print("Result: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))
