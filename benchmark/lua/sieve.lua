local limit = 10000
local sieve = {}
for i = 0, limit do sieve[i] = true end
sieve[0] = false
sieve[1] = false
local start = os.clock()
for p = 2, math.floor(math.sqrt(limit)) do
    if sieve[p] then
        for multiple = p * p, limit, p do
            sieve[multiple] = false
        end
    end
end
local count = 0
for i = 2, limit do
    if sieve[i] then count = count + 1 end
end
local finish = os.clock()
print("Primes up to 10000: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

