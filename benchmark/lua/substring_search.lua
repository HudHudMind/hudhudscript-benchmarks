local text = ""
for i = 1, 1000 do
    text = text .. "abcdefghij"
end
local pattern = "defg"
local text_len = #text
local pat_len = #pattern
local count = 0
local start = os.clock()
for t = 1, text_len - pat_len + 1 do
    local match = true
    for p = 1, pat_len do
        if string.sub(text, t + p - 1, t + p - 1) ~= string.sub(pattern, p, p) then
            match = false
            break
        end
    end
    if match then
        count = count + 1
    end
end
local finish = os.clock()
print("Count: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))
