C=65536;keys=[0]*C;vals=[0]*C;state=[0]*C
seed=12345;def ri(n);$seed=($seed*16807)%2147483647;$seed%n;end;$seed=12345
I,L,D=40000,80000,20000;fnd=dlt=acc=0;start=Time.now.to_f*1000
I.times{k=ri(1000000)+1;h=(k*16807)%C;h=(h+1)%C while state[h]==1;keys[h]=k;vals[h]=k%97;state[h]=1}
L.times{k=ri(1000000)+1;h=(k*16807)%C;while state[h]!=0;if state[h]==1&&keys[h]==k;fnd+=1;acc=(acc+vals[h])%1000003;break;end;h=(h+1)%C;end}
D.times{k=ri(1000000)+1;h=(k*16807)%C;while state[h]!=0;if state[h]==1&&keys[h]==k;state[h]=2;dlt+=1;break;end;h=(h+1)%C;end}
finish=Time.now.to_f*1000;puts "Result: #{fnd}_#{dlt}_#{acc}";puts "Time: #{(finish-start).round}ms"
