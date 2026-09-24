import time
seed = 12345
def ri(m):
    global seed
    seed = (seed * 16807) % 2147483647
    return seed % m

def gen(depth):
    if depth == 7: return ri(100000)
    node = {}
    node["a"] = ri(100000) if ri(4) == 0 else gen(depth + 1)
    node["b"] = ri(100000) if ri(4) == 0 else gen(depth + 1)
    node["c"] = ri(100000) if ri(4) == 0 else gen(depth + 1)
    node["s"] = "x" + str(ri(1000))
    return node

def count_nodes(node):
    if isinstance(node, (int, str)): return 0
    return 1 + count_nodes(node["a"]) + count_nodes(node["b"]) + count_nodes(node["c"])

def serialize(node):
    if isinstance(node, int): return str(node)
    parts = ['{"a":', serialize(node["a"]), ',"b":', serialize(node["b"]), ',"c":', serialize(node["c"]), ',"s":"', node["s"], '"}']
    return "".join(parts)

tree = gen(0)
nc = count_nodes(tree)
start = time.time() * 1000
total = sum(len(serialize(tree)) for _ in range(50))
end = time.time() * 1000
print(f"Result: {total % 1000003}_{nc}")
print(f"Time: {int(end - start)}ms")
