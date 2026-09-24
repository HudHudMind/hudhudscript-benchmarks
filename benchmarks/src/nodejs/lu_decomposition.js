const n=200;let A=[];for(let i=0;i<n;i++){A[i]=[];for(let j=0;j<n;j++)A[i][j]=((i*31+j*17)%100+1)*1.0+(i==j?1000:0)}
const start=Date.now();
for(let k=0;k<n;k++)for(let i=k+1;i<n;i++){let f=A[i][k]/A[k][k];for(let j=0;j<n;j++)A[i][j]-=f*A[k][j];A[i][k]=f}
let s=0;for(let i=0;i<n;i++)s+=A[i][i];const r=Math.round(s/n*1000);
const end=Date.now();console.log('Result: '+r);console.log('Time: '+Math.floor(end-start)+'ms')
