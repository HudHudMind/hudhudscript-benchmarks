-- LuaJIT (Lua 5.1) uyarlaması: a // b → math.floor(a / b)
-- Orijinal: benchmarks/src/lua/collatz.lua (dokunulmaz)
local start = os.clock()
local max_steps = 0
local max_n = 0
for n = 1, 10000 do
    local steps = 0
    local current = n
    while current ~= 1 do
        if current % 2 == 0 then
            current = math.floor(current / 2)
        else
            current = current * 3 + 1
        end
        steps = steps + 1
    end
    if steps > max_steps then
        max_steps = steps
        max_n = n
    end
end
local finish = os.clock()
print("Result: " .. max_steps) 
print(string.format("Time: %.0fms", (finish - start) * 1000))

