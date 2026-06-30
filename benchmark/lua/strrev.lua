local start = os.clock()
local s = string.rep("a", 50000)
local rev = ""
for j = #s, 1, -1 do
    rev = rev .. string.sub(s, j, j)
end
local finish = os.clock()
print("Len: " .. #rev)
print(string.format("Time: %.0fms", (finish - start) * 1000))

