local start = os.clock()
local s1 = string.rep("abcdefghij", 10)
local s2 = string.rep("acegikmoqs", 10)
local m, n = #s1, #s2
local dp = {}
for i = 0, m do
    dp[i] = {}
    for j = 0, n do dp[i][j] = 0 end
end
for i = 1, m do
    for j = 1, n do
        if s1:sub(i, i) == s2:sub(j, j) then
            dp[i][j] = dp[i - 1][j - 1] + 1
        else
            local a = dp[i - 1][j]
            local b = dp[i][j - 1]
            dp[i][j] = a > b and a or b
        end
    end
end
local finish = os.clock()
print("LCS: " .. dp[m][n])
print(string.format("Time: %.0fms", (finish - start) * 1000))

