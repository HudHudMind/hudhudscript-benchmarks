local N=100000;local seed=12345;local acc=0;local start=os.clock()
local head=nil;for i=1,N do seed=(seed*16807)%2147483647;head={value=seed%10000,next=head} end
local prev,cur=nil,head;for i=1,N do local nxt=cur.next;cur.next=prev;prev=cur;cur=nxt end
local pos,walk=0,prev;for i=1,N do acc=(acc+walk.value*pos)%1000003;pos=pos+1;walk=walk.next end
local finish=os.clock();print("Result: "..acc);print(string.format("Time: %.0fms",(finish-start)*1000))
