def hanoi(n)
  return 1 if n == 1
  hanoi(n - 1) + 1 + hanoi(n - 1)
end
start = Time.now.to_f * 1000
moves = hanoi(20)
finish = Time.now.to_f * 1000
puts "Moves: #{moves}"
puts "Time: #{(finish - start).round}ms"

