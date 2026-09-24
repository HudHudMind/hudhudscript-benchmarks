local seed = 42
local function rng()
    seed = (seed * 1103515245 + 12345) % 2147483648
    return math.floor((seed - (seed % 65536)) / 65536) % 4
end
local chars = "ACGT"
local text_arr = {}
for i = 1, 500000 do local ci = rng(); text_arr[i] = chars:sub(ci + 1, ci + 1) end
local text = table.concat(text_arr)

local patterns = {}
for i = 1, 15 do
    local sp = (seed * 16807) % 499000 + 1
    seed = (seed * 16807) % 2147483647
    local pl = 5 + (seed % 11)
    patterns[#patterns + 1] = text:sub(sp, sp + pl - 1)
end
for i = 1, 5 do
    patterns[#patterns + 1] = "QQQQQ" .. tostring((seed * 16807) % 10)
    seed = (seed * 16807) % 2147483647
end

local start = os.clock()
local total = 0
for _, pat in ipairs(patterns) do
    local m = #pat
    local fail = {}
    for i = 1, m do fail[i] = 0 end
    local j = 0
    for i = 2, m do
        while j > 0 and pat:sub(i, i) ~= pat:sub(j + 1, j + 1) do
            j = fail[j]
        end
        if pat:sub(i, i) == pat:sub(j + 1, j + 1) then
            j = j + 1
        end
        fail[i] = j
    end
    j = 0
    for i = 1, #text do
        local c = text:sub(i, i)
        while j > 0 and c ~= pat:sub(j + 1, j + 1) do
            j = fail[j]
        end
        if c == pat:sub(j + 1, j + 1) then
            j = j + 1
        end
        if j == m then
            total = total + 1
            j = fail[j]
        end
    end
end
local finish = os.clock()
print("Result: " .. total)
print(string.format("Time: %.0fms", (finish - start) * 1000))
