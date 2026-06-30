local size = 300
local m = {}
local t = {}
for i = 1, size do
    m[i] = {}
    t[i] = {}
    for j = 1, size do
        m[i][j] = (i - 1) + (j - 1)
        t[i][j] = 0
    end
end

local start = os.clock()
for i = 1, size do
    for j = 1, size do
        t[j][i] = m[i][j]
    end
end
local finish = os.clock()
print("T[0][0]: " .. t[1][1])
print("T[299][299]: " .. t[300][300])
print(string.format("Time: %.0fms", (finish - start) * 1000))

