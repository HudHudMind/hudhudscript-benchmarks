local comp = {
    A = "T", C = "G", G = "C", T = "A",
    U = "A", M = "K", R = "Y", W = "W",
    S = "S", Y = "R", K = "M", V = "B",
    H = "D", D = "H", B = "V", N = "N",
    a = "T", c = "G", g = "C", t = "A",
    u = "A", m = "K", r = "Y", w = "W",
    s = "S", y = "R", k = "M", v = "B",
    h = "D", d = "H", b = "V", n = "N"
}

local function reverse_complement(seq)
    local count_A = 0
    for i = string.len(seq), 1, -1 do
        local c = string.sub(seq, i, i)
        local rep = comp[c] or c
        if rep == "A" then
            count_A = count_A + 1
        end
    end
    return count_A
end

local start = os.clock() * 1000

local seq = {}
local seed = 42
local chars = {"A", "C", "G", "T"}
for i = 1, 500000 do
    seed = (seed * 1103515245 + 12345) % 2147483648
    local idx = math.floor(seed / 65536) % 4
    seq[i] = chars[idx + 1]
end
local seq_str = table.concat(seq)

local res = 0
for k = 1, 10 do
    res = reverse_complement(seq_str)
end

local end_time = os.clock() * 1000
print("Result: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
