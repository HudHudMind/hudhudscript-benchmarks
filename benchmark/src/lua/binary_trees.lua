function bottom_up_tree(depth)
    if depth > 0 then
        return {bottom_up_tree(depth - 1), bottom_up_tree(depth - 1)}
    else
        return {}
    end
end

function item_check(tree)
    if tree[1] then
        return 1 + item_check(tree[1]) + item_check(tree[2])
    else
        return 1
    end
end

local start = os.clock() * 1000
local max_depth = 12
local min_depth = 4
local stretch_depth = max_depth + 1

local stretch_tree = bottom_up_tree(stretch_depth)
local check = item_check(stretch_tree)

local long_lived_tree = bottom_up_tree(max_depth)

for depth = min_depth, max_depth, 2 do
    local iterations = math.floor(2 ^ (max_depth - depth + min_depth))
    local check_sum = 0
    for i = 1, iterations do
        check_sum = check_sum + item_check(bottom_up_tree(depth))
    end
end

local long_lived_check = item_check(long_lived_tree)
local end_time = os.clock() * 1000

print("Result: " .. check .. "_" .. long_lived_check)
print("Time: " .. math.floor(end_time - start) .. "ms")
