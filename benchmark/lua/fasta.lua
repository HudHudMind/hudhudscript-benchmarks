local start = os.clock() * 1000

local seed = 42
local function rand(max_val)
    seed = (seed * 3877 + 29573) % 139968
    return max_val * seed / 139968.0
end

local alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

local iub = {
    {"a", 0.27}, {"c", 0.12}, {"g", 0.12}, {"t", 0.27},
    {"B", 0.02}, {"D", 0.02}, {"H", 0.02}, {"K", 0.02},
    {"M", 0.02}, {"N", 0.02}, {"R", 0.02}, {"S", 0.02},
    {"V", 0.02}, {"W", 0.02}, {"Y", 0.02}
}

local cp = 0.0
for i = 1, #iub do
    cp = cp + iub[i][2]
    iub[i][2] = cp
end

local res = 0
local n = 50000

local alu_idx = 0
local total = n * 2
while total > 0 do
    local chunk = math.min(60, total)
    res = res + chunk
    total = total - chunk
    alu_idx = (alu_idx + chunk) % string.len(alu)
end

total = n * 3
while total > 0 do
    local chunk = math.min(60, total)
    for c = 1, chunk do
        local r = rand(1.0)
        for j = 1, #iub do
            if r < iub[j][2] then
                res = res + 1
                break
            end
        end
    end
    total = total - chunk
end

local end_time = os.clock() * 1000
print("Result: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
