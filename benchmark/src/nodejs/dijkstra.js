const n=20000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let et=[],ew=[],deg=new Array(n).fill(0),sof=new Array(n).fill(0);
for(let i=0;i<n;i++){et.push((i+1)%n);ew.push(1+ri(9));deg[i]++}
for(let i=0;i<n;i++)for(let j=0;j<5;j++){let t=ri(n);et.push(t);ew.push(1+ri(99));deg[i]++}
let off=0;for(let i=0;i<n;i++){sof[i]=off;off+=deg[i]}
let hd=[],hn=[],hsz=0;
function hp(d,nd){hn[hsz]=nd;hd[hsz]=d;let i2=hsz;hsz++;
 while(i2>0){let p=Math.floor((i2-1)/2);if(hd[p]<=hd[i2])break;
  [hd[i2],hd[p]]=[hd[p],hd[i2]];[hn[i2],hn[p]]=[hn[p],hn[i2]];i2=p}}
function hpop(){if(hsz==0)return -1;let r=hn[0];hsz--;hn[0]=hn[hsz];hd[0]=hd[hsz];let i2=0;
 while(1){let l=2*i2+1,r2=2*i2+2,s=i2;if(l<hsz&&hd[l]<hd[s])s=l;if(r2<hsz&&hd[r2]<hd[s])s=r2;
  if(s==i2)break;[hd[i2],hd[s]]=[hd[s],hd[i2]];[hn[i2],hn[s]]=[hn[s],hn[i2]];i2=s}return r}
let INF=999999999,dist=new Array(n).fill(INF),vis=new Array(n).fill(0);dist[0]=0;hp(0,0);
const start=Date.now();
while(hsz>0){let u=hpop();if(u<0)break;if(vis[u]==1)continue;vis[u]=1;let d=dist[u],base=sof[u];
 for(let k=0;k<deg[u];k++){let v=et[base+k],w=ew[base+k],nd=d+w;if(nd<dist[v]){dist[v]=nd;hp(nd,v)}}}
let sm=0;for(let i=0;i<n;i++)sm+=dist[i];const end=Date.now();
console.log('Result: '+(sm%1000003));console.log('Time: '+Math.floor(end-start)+'ms')
