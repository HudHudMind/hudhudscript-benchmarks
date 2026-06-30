local function hanoi(n)
    if n == 1 then
        return 1
    end
    return hanoi(n - 1) + 1 + hanoi(n - 1)
end
local start = os.clock()
local moves = hanoi(20)
local finish = os.clock()
print("Moves: " .. moves)
print(string.format("Time: %.0fms", (finish - start) * 1000))

