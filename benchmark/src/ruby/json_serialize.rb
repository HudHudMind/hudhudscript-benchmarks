$seed = 12345
def ri(m)
  $seed = ($seed * 16807) % 2147483647
  return $seed % m
end

def gen(depth)
  return ri(100000) if depth == 7
  node = {}
  node["a"] = ri(4) == 0 ? ri(100000) : gen(depth + 1)
  node["b"] = ri(4) == 0 ? ri(100000) : gen(depth + 1)
  node["c"] = ri(4) == 0 ? ri(100000) : gen(depth + 1)
  node["s"] = "x" + ri(1000).to_s
  node
end

def count_nodes(node)
  return 0 if node.is_a?(Integer) || node.is_a?(String)
  1 + count_nodes(node["a"]) + count_nodes(node["b"]) + count_nodes(node["c"])
end

def serialize(node)
  return node.to_s if node.is_a?(Integer)
  parts = []
  parts << '{"a":'
  parts << serialize(node["a"])
  parts << ',"b":'
  parts << serialize(node["b"])
  parts << ',"c":'
  parts << serialize(node["c"])
  parts << ',"s":"'
  parts << node["s"]
  parts << '"}'
  parts.join
end

tree = gen(0)
nc = count_nodes(tree)
start = Time.now.to_f * 1000
total = 0
50.times { total += serialize(tree).length }
finish = Time.now.to_f * 1000
puts "Result: #{total % 1000003}_#{nc}"
puts "Time: #{(finish - start).round}ms"
