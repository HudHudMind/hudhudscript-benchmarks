local s = ""
local start = os.clock()
for i = 1, 50000 do
    s = s .. "x"
end
local finish = os.clock()
print("Result: " .. #s)
print(string.format("Time: %.0fms", (finish - start) * 1000))
