start = Time.now.to_f * 1000
weights = 50.times.map { |i| (i * 7 + 3) % 20 + 1 }
values = 50.times.map { |i| (i * 13 + 5) % 50 + 10 }
capacity = 100
n = weights.length
dp = Array.new(n + 1) { Array.new(capacity + 1, 0) }
(1..n).each do |i|
    (0..capacity).each do |w|
        if weights[i - 1] <= w
            incl = values[i - 1] + dp[i - 1][w - weights[i - 1]]
            dp[i][w] = incl > dp[i - 1][w] ? incl : dp[i - 1][w]
        else
            dp[i][w] = dp[i - 1][w]
        end
    end
end
finish = Time.now.to_f * 1000
puts "Max: #{dp[n][capacity]}"
puts "Time: #{(finish - start).round}ms"

