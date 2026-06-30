function generate_dna(length)
    local chars = {"A", "C", "G", "T"}
    local seq = {}
    local seed = 42
    for i = 1, length do
        seed = (seed * 1103515245 + 12345) % 2147483648
        local idx = math.floor(seed / 65536) % 4
        seq[i] = chars[idx + 1]
    end
    return table.concat(seq)
end

function count_frequencies(dna, k)
    local freqs = {}
    local n = string.len(dna) - k + 1
    for i = 1, n do
        local sub = string.sub(dna, i, i + k - 1)
        freqs[sub] = (freqs[sub] or 0) + 1
    end
    local count = 0
    for _ in pairs(freqs) do
        count = count + 1
    end
    return count
end

local start = os.clock() * 1000
local dna = generate_dna(100000)
local c1 = count_frequencies(dna, 1)
local c2 = count_frequencies(dna, 2)
local c3 = count_frequencies(dna, 3)

local res = c1 + c2 + c3
local end_time = os.clock() * 1000

print("Count: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
