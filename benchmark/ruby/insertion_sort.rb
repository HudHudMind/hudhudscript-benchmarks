start = Time.now.to_f * 1000
arr = (1..1000).to_a.reverse
(1...arr.length).each do |j|
    key = arr[j]
    k = j - 1
    while k >= 0 && arr[k] > key
        arr[k + 1] = arr[k]
        k -= 1
    end
    arr[k + 1] = key
end
finish = Time.now.to_f * 1000
puts "First: #{arr[0]}"
puts "Last: #{arr[-1]}"
puts "Time: #{(finish - start).round}ms"

