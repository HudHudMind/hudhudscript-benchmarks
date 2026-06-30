local n = 100000
local arr = {}
for i = 1, n do
    arr[i] = i
end
local start = os.clock()
local cum = {}
local s = 0
for i = 1, n do
    s = s + arr[i]
    cum[i] = s
end
local finish = os.clock()
print("Last: " .. cum[n])
print(string.format("Time: %.0fms", (finish - start) * 1000))

