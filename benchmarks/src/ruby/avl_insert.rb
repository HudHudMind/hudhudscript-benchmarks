n = 100000
$seed = 12345
def ri(m)
  $seed = ($seed * 16807) % 2147483647
  return $seed % m
end

sz = n + 10
$key = Array.new(sz, 0)
$left = Array.new(sz, 0)
$right = Array.new(sz, 0)
$height = Array.new(sz, 0)
$nodes = 0

def new_node(k)
  $nodes += 1
  $key[$nodes] = k
  $left[$nodes] = 0
  $right[$nodes] = 0
  $height[$nodes] = 1
  return $nodes
end

def get_h(nd)
  return nd == 0 ? 0 : $height[nd]
end

def upd_h(nd)
  hl = get_h($left[nd])
  hr = get_h($right[nd])
  $height[nd] = (hl > hr ? hl : hr) + 1
end

def bal(nd)
  return get_h($left[nd]) - get_h($right[nd])
end

def rot_r(y)
  x = $left[y]
  t = $right[x]
  $right[x] = y
  $left[y] = t
  upd_h(y)
  upd_h(x)
  return x
end

def rot_l(x)
  y = $right[x]
  t = $left[y]
  $left[y] = x
  $right[x] = t
  upd_h(x)
  upd_h(y)
  return y
end

def insert(nd, k)
  return new_node(k) if nd == 0
  if k < $key[nd]
    $left[nd] = insert($left[nd], k)
  elsif k > $key[nd]
    $right[nd] = insert($right[nd], k)
  else
    return nd
  end
  upd_h(nd)
  b = bal(nd)
  return rot_r(nd) if b > 1 && k < $key[$left[nd]]
  return rot_l(nd) if b < -1 && k > $key[$right[nd]]
  if b > 1 && k > $key[$left[nd]]
    $left[nd] = rot_l($left[nd])
    return rot_r(nd)
  end
  if b < -1 && k < $key[$right[nd]]
    $right[nd] = rot_r($right[nd])
    return rot_l(nd)
  end
  return nd
end

root = 0
n.times { root = insert(root, ri(1000000)) }

start = Time.now.to_f * 1000
c = 0
idx = 0
stack = []
cur = root
while !stack.empty? || cur != 0
  while cur != 0
    stack.push(cur)
    cur = $left[cur]
  end
  cur = stack.pop
  c = (c + $key[cur] * (idx % 13)) % 1000003
  idx += 1
  cur = $right[cur]
end
finish = Time.now.to_f * 1000
puts "Result: #{$height[root]}_#{c}"
puts "Time: #{(finish - start).round}ms"
