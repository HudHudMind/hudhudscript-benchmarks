import time
W=20000;seed=12345
def ri(m):
 global seed;seed=(seed*16807)%2147483647;return seed%m
nodes=1;children=[0]*26;terminal=[0]
def nc():
 global nodes,children,terminal
 for _ in range(26):children.append(0)
 terminal.append(0);nodes+=1;return nodes-1
start=time.time()*1000
for _ in range(W):
 l=3+ri(6);cur=0
 for _ in range(l):
  c=ri(26);idx=cur*26+c
  if children[idx]==0:children[idx]=nc()
  cur=children[idx]
 terminal[cur]=1
hits=0;seed=12345
for _ in range(W):
 l=3+ri(6);cur=0
 for _ in range(l):
  c=ri(26);idx=cur*26+c
  if children[idx]==0:cur=0;break
  cur=children[idx]
 if cur!=0 and terminal[cur]==1:hits+=1
seed=54321
for _ in range(W):
 l=3+ri(6);cur=0
 for _ in range(l):
  c=ri(26);idx=cur*26+c
  if children[idx]==0:cur=0;break
  cur=children[idx]
 if cur!=0 and terminal[cur]==1:hits+=1
end=time.time()*1000
print(f"Result: {nodes}_{hits}")
print(f"Time: {int(end-start)}ms")