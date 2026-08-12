R=20000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
parts=[];R.times{|i|id=ri(100000);tag=ri(1000);si=ri(1000);sf=ri(100)
 parts<<'{"id":'+id.to_s+',"tag":"w'+tag.to_s+'","ok":true,"score":'+si.to_s+'.'+sf.to_s+'}';parts<<','if i<R-1}
line='['+parts.join+']';st=ss=num=kw=0;pos=0;l=line.length;start=Time.now.to_f*1000
while pos<l;c=line[pos]
 if'{[}]:,'.include?(c);st+=1;pos+=1
 elsif c=='"';ss+=1;pos+=1;pos+=1 while pos<l&&line[pos]!='"';pos+=1
 elsif'tfn'.include?(c);kw+=1;pos+=4;pos+=1 if'fn'.include?(c)
 else;num+=1;pos+=1 while pos<l&&!',}]'.include?(line[pos]);end;end
finish=Time.now.to_f*1000;puts"Result: #{st}_#{ss}_#{num}_#{kw}";puts"Time: #{(finish-start).round}ms"