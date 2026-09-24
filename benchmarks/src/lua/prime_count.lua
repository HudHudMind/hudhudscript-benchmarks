local start = os.clock()
local function is_prime(n)
  if n < 2 then return false end
  if n == 2 then return true end
  if n % 2 == 0 then return false end
  local i = 3
  while i * i <= n do
    if n % i == 0 then return false end
    i = i + 2
  end
  return true
end

local count = 0
for n = 2, 100000 do
  if is_prime(n) then count = count + 1 end
end
local finish = os.clock()
print("Result: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

