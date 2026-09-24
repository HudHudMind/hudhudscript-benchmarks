const n=100000;let total=0;const start=Date.now();
for(let i=1;i<=n;i++){let x=i;while(x>0){total+=x%2;x=Math.floor(x/2)}}
const end=Date.now();console.log('Result: '+total);console.log('Time: '+Math.floor(end-start)+'ms')