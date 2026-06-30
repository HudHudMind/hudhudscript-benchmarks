local start = os.clock()
local r = 0.999
local s = 0.0
local term = 1.0
for _ = 1, 1000000 do
    s = s + term
    term = term * r
end
local finish = os.clock()
print("Sum: " .. s)
print(string.format("Time: %.0fms", (finish - start) * 1000))

