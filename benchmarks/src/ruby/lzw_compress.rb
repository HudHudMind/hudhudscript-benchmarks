M=400000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
syms=[];i=0
while i<M;if i>=20&&ri(10)<4;s=i-20;20.times{|j|syms<<syms[s+j]};i+=20;else;syms<<ri(4);i+=1;end;end
DS=4096;dic=[0]*(DS*4);nc=5;out=[];cur=syms[0]+1;i=1;start=Time.now.to_f*1000
while i<syms.length;s=syms[i];cand=dic[cur*4+s];if cand!=0;cur=cand;else;out<<cur
 nc<DS&&(dic[cur*4+s]=nc;nc+=1);cur=s+1;end;i+=1;end
out<<cur;oc=out.length;sm=0;oc.times{|j|sm=(sm+out[j]*j)%1000003}
finish=Time.now.to_f*1000;puts"Result: #{oc}_#{sm}";puts"Time: #{(finish-start).round}ms"