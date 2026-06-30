local board = {}
for i = 0, 7 do board[i] = 0 end
local start = os.clock()
local count = 0
local row = 0
local col = 0

while true do
    if row < 0 then
        break
    end
    if row == 8 then
        count = count + 1
        row = row - 1
        if row >= 0 then
            col = board[row] + 1
        end
    else
        if col >= 8 then
            board[row] = 0
            row = row - 1
            if row >= 0 then
                col = board[row] + 1
            end
        else
            local safe = true
            local i = 0
            while i < row do
                if board[i] == col then
                    safe = false
                    i = row
                else
                    local diff1 = board[i] - col
                    if diff1 < 0 then
                        diff1 = 0 - diff1
                    end
                    local diff2 = i - row
                    if diff2 < 0 then
                        diff2 = 0 - diff2
                    end
                    if diff1 == diff2 then
                        safe = false
                        i = row
                    else
                        i = i + 1
                    end
                end
            end
            if safe then
                board[row] = col
                row = row + 1
                col = 0
            else
                col = col + 1
            end
        end
    end
end
local finish = os.clock()
print("Solutions: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

