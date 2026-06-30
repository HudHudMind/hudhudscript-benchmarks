def duffs_device(count)
  a = Array.new(count, 0)
  b = Array.new(count, 1)
  
  n = count / 8
  rem = count % 8
  i = 0
  
  while rem > 0
    a[i] = b[i]
    i += 1
    rem -= 1
  end
  
  while n > 0
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    a[i] = b[i]; i += 1
    n -= 1
  end
  a[count - 1]
end

start_time = Time.now.to_f * 1000
res = 0
100.times do
  res = duffs_device(100000)
end
end_time = Time.now.to_f * 1000

puts "Result: #{res}"
puts "Time: #{(end_time - start_time).to_i}ms"
