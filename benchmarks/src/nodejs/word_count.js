const M=500000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let d=[];for(let i=0;i<2000;i++)d.push('w'+i);
let c={};for(let w of d)c[w]=0;
const start=Date.now();
for(let i=0;i<M;i++)c[d[ri(2000)]]++;
let mc=0,mw='';for(let w of d){let v=c[w];if(mc==0){mc=v;mw=w}else if(v>mc){mc=v;mw=w}}
const end=Date.now();console.log('Result: '+mc+'_'+mw);console.log('Time: '+Math.floor(end-start)+'ms')
