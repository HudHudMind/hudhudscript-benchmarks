import time

n = 100000
seed = 12345
def ri(m):
    global seed
    seed = (seed * 16807) % 2147483647
    return seed % m

sz = n + 10
key = [0] * sz
left = [0] * sz
right = [0] * sz
height = [0] * sz
nodes = 0

def new_node(k):
    global nodes
    nodes += 1
    key[nodes] = k
    left[nodes] = 0
    right[nodes] = 0
    height[nodes] = 1
    return nodes

def get_height(node):
    return height[node] if node != 0 else 0

def update_height(node):
    hl = get_height(left[node])
    hr = get_height(right[node])
    height[node] = (hl if hl > hr else hr) + 1

def balance(node):
    return get_height(left[node]) - get_height(right[node])

def rotate_right(y):
    x = left[y]
    T = right[x]
    right[x] = y
    left[y] = T
    update_height(y)
    update_height(x)
    return x

def rotate_left(x):
    y = right[x]
    T = left[y]
    left[y] = x
    right[x] = T
    update_height(x)
    update_height(y)
    return y

def insert(node, k):
    if node == 0:
        return new_node(k)
    if k < key[node]:
        left[node] = insert(left[node], k)
    elif k > key[node]:
        right[node] = insert(right[node], k)
    else:
        return node
    update_height(node)
    bal = balance(node)
    if bal > 1 and k < key[left[node]]:
        return rotate_right(node)
    if bal < -1 and k > key[right[node]]:
        return rotate_left(node)
    if bal > 1 and k > key[left[node]]:
        left[node] = rotate_left(left[node])
        return rotate_right(node)
    if bal < -1 and k < key[right[node]]:
        right[node] = rotate_right(right[node])
        return rotate_left(node)
    return node

root = 0
for _ in range(n):
    root = insert(root, ri(1000000))

start = time.time() * 1000

c = 0
idx = 0
stack = []
cur = root
while stack or cur != 0:
    while cur != 0:
        stack.append(cur)
        cur = left[cur]
    cur = stack.pop()
    c = (c + key[cur] * (idx % 13)) % 1000003
    idx += 1
    cur = right[cur]

end = time.time() * 1000
print(f"Result: {height[root]}_{c}")
print(f"Time: {int(end - start)}ms")
