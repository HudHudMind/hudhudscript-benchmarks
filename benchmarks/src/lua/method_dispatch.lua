Shape = {}
function Shape:score() return 0 end

A = setmetatable({}, {__index = Shape})
function A:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function A:score() return self.v * 2 end

B = setmetatable({}, {__index = Shape})
function B:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function B:score() return self.v * 3 + 1 end

C = setmetatable({}, {__index = Shape})
function C:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function C:score() return self.v * 5 - 2 end

local shapes = {}
local classes = {A, B, C}
for i = 1, 3000 do
    local r = (i - 1) % 3 + 1
    local obj = classes[r]:new()
    obj.v = (i - 1) % 97
    shapes[i] = obj
end

local P = 300
local acc = 0
local start = os.clock()
for round = 1, P do
    for j = 1, 3000 do
        acc = (acc + shapes[j]:score()) % 1000003
    end
end
local finish = os.clock()
print("Result: " .. acc)
print(string.format("Time: %.0fms", (finish - start) * 1000))
