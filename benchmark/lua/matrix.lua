local size = 150
local a = {}
local b = {}
local c = {}
for i = 1, size do
    a[i] = {}
    b[i] = {}
    c[i] = {}
    for j = 1, size do
        a[i][j] = (i - 1) + (j - 1)
        b[i][j] = (i - 1) - (j - 1)
        c[i][j] = 0
    end
end

local start = os.clock()
for i = 1, size do
    for j = 1, size do
        for k = 1, size do
            c[i][j] = c[i][j] + a[i][k] * b[k][j]
        end
    end
end
local finish = os.clock()
print("Result[0][0]: " .. c[1][1])
print("Result[149][149]: " .. c[150][150])
print(string.format("Time: %.0fms", (finish - start) * 1000))

