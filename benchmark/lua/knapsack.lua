local start = os.clock()
local weights = {}
local values = {}
for i = 1, 50 do
    weights[i] = ((i - 1) * 7 + 3) % 20 + 1
    values[i] = ((i - 1) * 13 + 5) % 50 + 10
end
local capacity = 100
local n = #weights
local dp = {}
for i = 0, n do
    dp[i] = {}
    for w = 0, capacity do dp[i][w] = 0 end
end
for i = 1, n do
    for w = 0, capacity do
        if weights[i] <= w then
            local incl = values[i] + dp[i - 1][w - weights[i]]
            if incl > dp[i - 1][w] then
                dp[i][w] = incl
            else
                dp[i][w] = dp[i - 1][w]
            end
        else
            dp[i][w] = dp[i - 1][w]
        end
    end
end
local finish = os.clock()
print("Max: " .. dp[n][capacity])
print(string.format("Time: %.0fms", (finish - start) * 1000))

