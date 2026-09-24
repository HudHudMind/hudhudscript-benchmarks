const M=400000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let syms=[],i=0;
while(i<M){if(i>=20&&ri(10)<4){let s=i-20;for(let j=0;j<20;j++)syms.push(syms[s+j]);i+=20}else{syms.push(ri(4));i++}}
let DS=4096,dic=new Array(DS*4).fill(0),nc=5,out=[],cur=syms[0]+1;i=1;
const start=Date.now();
while(i<syms.length){let s=syms[i],cand=dic[cur*4+s];if(cand!=0)cur=cand;else{out.push(cur);if(nc<DS)dic[cur*4+s]=nc++;cur=s+1}i++}
out.push(cur);let oc=out.length,sm=0;for(let j=0;j<oc;j++)sm=(sm+out[j]*j)%1000003;
const end=Date.now();console.log('Result: '+oc+'_'+sm);console.log('Time: '+Math.floor(end-start)+'ms')
