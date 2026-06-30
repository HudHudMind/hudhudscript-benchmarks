start = Time.now.to_f * 1000
arr = (0...100000).map { |i| i * 2 }
found = 0
(0...10000).each do |j|
  target = j * 20
  left = 0
  right = 99999
  while left <= right
    mid = (left + right) / 2
    if arr[mid] == target
      found += 1
      break
    end
    if arr[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end
end
finish = Time.now.to_f * 1000
puts "Found: #{found}"
puts "Time: #{(finish - start).round}ms"

