import time
import sys

sys.setrecursionlimit(20000)

def bottom_up_tree(depth):
    if depth > 0:
        return (bottom_up_tree(depth - 1), bottom_up_tree(depth - 1))
    else:
        return (None, None)

def item_check(tree):
    if tree[0] is not None:
        return 1 + item_check(tree[0]) + item_check(tree[1])
    else:
        return 1

start = time.time() * 1000
max_depth = 12
min_depth = 4
stretch_depth = max_depth + 1

stretch_tree = bottom_up_tree(stretch_depth)
check = item_check(stretch_tree)

long_lived_tree = bottom_up_tree(max_depth)

for depth in range(min_depth, max_depth + 1, 2):
    iterations = 1 << (max_depth - depth + min_depth)
    check_sum = 0
    for i in range(iterations):
        check_sum += item_check(bottom_up_tree(depth))

long_lived_check = item_check(long_lived_tree)
end = time.time() * 1000

print(f"Result: {check}_{long_lived_check}")
print(f"Time: {end - start:.0f}ms")
