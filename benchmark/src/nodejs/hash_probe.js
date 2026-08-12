const C=65536,keys=new Array(C).fill(0),vals=new Array(C).fill(0),state=new Array(C).fill(0);
let seed=12345;function ri(n){seed=(seed*16807)%2147483647;return seed%n}
const I=40000,L=80000,D=20000;let fnd=0,dlt=0,acc=0;
const start=Date.now();
for(let j=0;j<I;j++){let k=ri(1000000)+1,h=(k*16807)%C;while(state[h]==1)h=(h+1)%C;keys[h]=k;vals[h]=k%97;state[h]=1}
for(let m=0;m<L;m++){let k=ri(1000000)+1,h=(k*16807)%C;while(state[h]!==0){if(state[h]==1&&keys[h]===k){fnd++;acc=(acc+vals[h])%1000003;break}h=(h+1)%C}}
for(let n=0;n<D;n++){let k=ri(1000000)+1,h=(k*16807)%C;while(state[h]!==0){if(state[h]==1&&keys[h]===k){state[h]=2;dlt++;break}h=(h+1)%C}}
const end=Date.now();console.log("Result: "+fnd+"_"+dlt+"_"+acc);console.log("Time: "+Math.floor(end-start)+"ms")
