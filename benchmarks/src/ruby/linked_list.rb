N=100000;seed=12345;acc=0;start=Time.now.to_f*1000
head=nil;N.times{seed=(seed*16807)%2147483647;head={value:seed%10000,next:head}}
prev=nil;cur=head;N.times{nxt=cur[:next];cur[:next]=prev;prev=cur;cur=nxt}
pos=0;walk=prev;N.times{acc=(acc+walk[:value]*pos)%1000003;pos+=1;walk=walk[:next]}
finish=Time.now.to_f*1000;puts "Result: #{acc}";puts "Time: #{(finish-start).round}ms"
