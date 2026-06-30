local a = {}
local b = {}
for i = 1, 500000 do
    a[i] = i
    b[i] = i + 1
end
local sum = 0
local start = os.clock()
for i = 1, 500000 do
    sum = sum + a[i] * b[i]
end
local finish = os.clock()
print("Dot: " .. sum)
print(string.format("Time: %.0fms", (finish - start) * 1000))
