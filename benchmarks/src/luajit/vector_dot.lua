-- LuaJIT (Lua 5.1) uyarlaması: toplam 2^53'ü aştığı için 10^9'luk kelimelerle kesin toplama
-- Orijinal: benchmarks/src/lua/vector_dot.lua (dokunulmaz)
local a = {}
local b = {}
for i = 1, 500000 do
    a[i] = i
    b[i] = i + 1
end
local w0, w1, w2 = 0, 0, 0  -- değer = w2*10^18 + w1*10^9 + w0
local start = os.clock()
for i = 1, 500000 do
    w0 = w0 + a[i] * b[i]
    local c = math.floor(w0 / 1000000000)
    w0 = w0 - c * 1000000000
    w1 = w1 + c
    c = math.floor(w1 / 1000000000)
    w1 = w1 - c * 1000000000
    w2 = w2 + c
end
local finish = os.clock()
local result
if w2 > 0 then
    result = w2 .. string.format("%09d%09d", w1, w0)
elseif w1 > 0 then
    result = w1 .. string.format("%09d", w0)
else
    result = w0
end
print("Result: " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))
