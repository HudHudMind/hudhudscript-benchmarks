import time

class Shape:
    def score(self):
        return 0

class A(Shape):
    def score(self):
        return self.v * 2

class B(Shape):
    def score(self):
        return self.v * 3 + 1

class C(Shape):
    def score(self):
        return self.v * 5 - 2

shapes = []
for i in range(3000):
    r = i % 3
    if r == 0:
        obj = A()
    elif r == 1:
        obj = B()
    else:
        obj = C()
    obj.v = i % 97
    shapes.append(obj)

P = 300
acc = 0
start = time.time() * 1000
for _ in range(P):
    for s in shapes:
        acc = (acc + s.score()) % 1000003
end = time.time() * 1000

print(f"Result: {acc}")
print(f"Time: {int(end - start)}ms")
