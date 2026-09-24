const N=4096,PI=3.141592653589793;let re=[],im=[];
for(let i=0;i<N;i++){re.push(Math.sin(i*0.017)+0.5*Math.sin(i*0.31));im.push(0)}
let br=[];for(let i=0;i<N;i++){let rev=0,p2=1;for(let j=0;j<12;j++){rev=rev*2+Math.floor(i/p2)%2;p2*=2};br.push(rev)}
let R=50,fs=0;const start=Date.now();
for(let r=0;r<R;r++){let cr=[],ci=[];for(let i=0;i<N;i++){let b=br[i];cr.push(re[b]);ci.push(im[b])}
 for(let step=2;step<=N;step*=2){let half=step/2,ang=(-2*PI)/step,wr=Math.cos(ang),wi=Math.sin(ang);
  for(let k=0;k<N;k+=step){let twr=1,twi=0;
   for(let m=0;m<half;m++){let ei=k+m,oi=k+m+half,tr=twr*cr[oi]-twi*ci[oi],ti=twr*ci[oi]+twi*cr[oi];
    cr[oi]=cr[ei]-tr;ci[oi]=ci[ei]-ti;cr[ei]+=tr;ci[ei]+=ti;
    let nwr=twr;twr=nwr*wr-twi*wi;twi=nwr*wi+twi*wr}}}
 let sm=0;for(let i=0;i<N;i++)sm+=cr[i]*cr[i]+ci[i]*ci[i];fs=sm}
const end=Date.now();console.log('Result: '+Math.round(fs));console.log('Time: '+Math.floor(end-start)+'ms')
