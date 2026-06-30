n = 500
arr = []
n.downto(1) { |i| arr << i }
start = Time.now.to_f * 1000
n.times do |k|
    (n - 1).times do |j|
        if arr[j] > arr[j + 1]
            temp = arr[j]
            arr[j] = arr[j + 1]
            arr[j + 1] = temp
        end
    end
end
finish = Time.now.to_f * 1000
puts "First: #{arr[0]}"
puts "Last: #{arr[n - 1]}"
puts "Time: #{(finish - start).round}ms"

