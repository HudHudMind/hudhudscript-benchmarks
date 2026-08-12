def bottom_up_tree(depth)
  if depth > 0
    [bottom_up_tree(depth - 1), bottom_up_tree(depth - 1)]
  else
    []
  end
end

def item_check(tree)
  if tree.length > 0
    1 + item_check(tree[0]) + item_check(tree[1])
  else
    1
  end
end

start_time = Time.now.to_f * 1000
max_depth = 12
min_depth = 4
stretch_depth = max_depth + 1

stretch_tree = bottom_up_tree(stretch_depth)
check = item_check(stretch_tree)

long_lived_tree = bottom_up_tree(max_depth)

(min_depth..max_depth).step(2).each do |depth|
  iterations = 1 << (max_depth - depth + min_depth)
  check_sum = 0
  iterations.times do
    check_sum += item_check(bottom_up_tree(depth))
  end
end

long_lived_check = item_check(long_lived_tree)
end_time = Time.now.to_f * 1000

puts "Result: #{check}_#{long_lived_check}"
puts "Time: #{(end_time - start_time).to_i}ms"
