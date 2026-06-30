local start = os.clock()
local count = 0
for n = 2, 100000 do
    local is_p = true
    if n < 2 then is_p = false
    elseif n == 2 then is_p = true
    elseif n % 2 == 0 then is_p = false
    else
        local i = 3
        while i * i <= n do
            if n % i == 0 then
                is_p = false
                break
            end
            i = i + 2
        end
    end
    if is_p then count = count + 1 end
end
local finish = os.clock()
print("Primes: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

