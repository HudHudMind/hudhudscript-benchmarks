let seed=12345n;function ri(m){seed=(seed*16807n)%2147483647n;return Number(seed%BigInt(m))}
function pm(b,e,m){let r=1n;b=BigInt(b);m=BigInt(m);e=BigInt(e);while(e>0n){if(e&1n)r=(r*b)%m;e>>=1n;b=(b*b)%m};return r}
function ip(n){n=BigInt(n);if(n<2n)return 0;if(n===2n)return 1;if(n%2n===0n)return 0;
 let d=n-1n,s=0n;while(d%2n===0n){d>>=1n;s++}
 for(let a of[2n,3n,5n,7n]){if(a>=n)continue;let x=pm(a,d,n);if(x===1n||x===n-1n)continue;let ok=0;
  for(let r=0n;r<s-1n;r++){x=(x*x)%n;if(x===n-1n){ok=1;break}};if(!ok)return 0};return 1}
let K=2000,cnt=0;const start=Date.now();
for(let i=0;i<K;i++){let n=1000000001n+2n*BigInt(ri(500000000));if(ip(n))cnt++}
const end=Date.now();console.log('Result: '+cnt);console.log('Time: '+Math.floor(end-start)+'ms')
