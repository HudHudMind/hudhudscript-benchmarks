start = Time.now.to_f * 1000
s1 = "abcdefghij" * 10
s2 = "acegikmoqs" * 10
m, n = s1.length, s2.length
dp = Array.new(m + 1) { Array.new(n + 1, 0) }
(1..m).each do |i|
    (1..n).each do |j|
        if s1[i - 1] == s2[j - 1]
            dp[i][j] = dp[i - 1][j - 1] + 1
        else
            a = dp[i - 1][j]
            b = dp[i][j - 1]
            dp[i][j] = a > b ? a : b
        end
    end
end
finish = Time.now.to_f * 1000
puts "LCS: #{dp[m][n]}"
puts "Time: #{(finish - start).round}ms"

