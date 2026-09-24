const T=300000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let pq=[],qh=0,wq=[],wh=0,sq=[],sh=0,made=0,acc=0,sunk=0;
const start=Date.now();
for(let t=0;t<T;t++){made++;if(made%3!=0)wq.push(made%100)
 if(wh<wq.length){let pkt=wq[wh];wh++;acc=(acc+pkt*7)%1000003;if(pkt>50)sq.push(pkt)}
 if(sh<sq.length){sh++;sunk++}}
const end=Date.now();console.log('Result: '+made+'_'+acc+'_'+sunk);console.log('Time: '+Math.floor(end-start)+'ms')
