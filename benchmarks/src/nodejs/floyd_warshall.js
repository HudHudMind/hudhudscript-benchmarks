const n=150,INF=999999999;let dist=Array.from({length:n},(_,i)=>Array.from({length:n},(_,j)=>i==j?0:INF));
let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
for(let i=0;i<n;i++)for(let j=0;j<4;j++){let t=(i*7+j*13+1)%n;if(t!=i)dist[i][t]=1+((i+j)%50)}
const start=Date.now();
for(let k=0;k<n;k++)for(let i=0;i<n;i++){let dik=dist[i][k];if(dik!=INF)for(let j=0;j<n;j++){let nd=dik+dist[k][j];if(nd<dist[i][j])dist[i][j]=nd}}
let reach=0,sum=0;for(let i=0;i<n;i++)for(let j=0;j<n;j++)if(dist[i][j]<INF){reach++;sum+=dist[i][j]}
const end=Date.now();console.log("Result: "+reach+"_"+(sum%1000003));console.log("Time: "+Math.floor(end-start)+"ms")
