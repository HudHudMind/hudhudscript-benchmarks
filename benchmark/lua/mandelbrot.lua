function mandelbrot(size)
    local sum_iters = 0
    for y = 0, size - 1 do
        for x = 0, size - 1 do
            local zr, zi = 0.0, 0.0
            local cr = (2.0 * x / size) - 1.5
            local ci = (2.0 * y / size) - 1.0
            local escape = 0
            for i = 1, 50 do
                local tr = zr * zr - zi * zi + cr
                local ti = 2.0 * zr * zi + ci
                zr, zi = tr, ti
                if zr * zr + zi * zi > 4.0 then
                    escape = 1
                    break
                end
            end
            sum_iters = sum_iters + escape
        end
    end
    return sum_iters
end

local start = os.clock() * 1000
local res = mandelbrot(500)
local end_time = os.clock() * 1000

print("Sum: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
