n=200000;U=400000;parent=(0...n).to_a;size=[1]*n
def find(x,parent) while parent[x]!=x;x=parent[x] end;x end
def union(a,b,parent,size) ra=find(a,parent);rb=find(b,parent)
 if ra!=rb;if size[ra]<size[rb];parent[ra]=rb;size[rb]+=size[ra];else;parent[rb]=ra;size[ra]+=size[rb];end;end end
seed=12345;def ri(m) $seed=($seed*16807)%2147483647;$seed%m end;$seed=seed
start=Time.now.to_f*1000
U.times{union(ri(n),ri(n),parent,size)}
roots=parent.each_with_index.count{|p,i|p==i}
finish=Time.now.to_f*1000
puts "Result: #{roots}";puts "Time: #{(finish-start).round}ms"
