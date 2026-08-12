const n=200000,U=400000,parent=[...Array(n).keys()],size=Array(n).fill(1)
function find(x){while(parent[x]!=x)x=parent[x];return x}
function union(a,b){let ra=find(a),rb=find(b);if(ra!=rb){if(size[ra]<size[rb]){parent[ra]=rb;size[rb]+=size[ra]}else{parent[rb]=ra;size[ra]+=size[rb]}}}
let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
const start=Date.now()
for(let i=0;i<U;i++)union(ri(n),ri(n))
let roots=0;for(let i=0;i<n;i++)if(parent[i]===i)roots++
const end=Date.now();console.log("Result: "+roots);console.log("Time: "+Math.floor(end-start)+"ms")
