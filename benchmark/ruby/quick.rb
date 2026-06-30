start = Time.now.to_f * 1000
arr = (1..1000).to_a.reverse
stack = [0, arr.length - 1]
while !stack.empty?
    high = stack.pop
    low = stack.pop
    if low < high
        pivot = arr[high]
        pi = low - 1
        (low...high).each do |j|
            if arr[j] <= pivot
                pi += 1
                arr[pi], arr[j] = arr[j], arr[pi]
            end
        end
        pi += 1
        arr[pi], arr[high] = arr[high], arr[pi]
        if pi - 1 > low
            stack.push(low)
            stack.push(pi - 1)
        end
        if pi + 1 < high
            stack.push(pi + 1)
            stack.push(high)
        end
    end
end
finish = Time.now.to_f * 1000
puts "First: #{arr[0]}"
puts "Last: #{arr[-1]}"
puts "Time: #{(finish - start).round}ms"

