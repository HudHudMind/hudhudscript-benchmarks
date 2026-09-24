const N=20000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let arr=[];for(let i=0;i<N;i++)arr.push('w'+ri(100000));
function ms(a){if(a.length<=1)return a;let m=Math.floor(a.length/2),L=ms(a.slice(0,m)),R=ms(a.slice(m)),res=[],pi=0,qi=0;
 while(pi<L.length){if(qi>=R.length)break;if(L[pi]<=R[qi])res.push(L[pi++]);else res.push(R[qi++])}
 while(pi<L.length)res.push(L[pi++]);while(qi<R.length)res.push(R[qi++]);return res}
const start=Date.now();let s=ms(arr),acc=0;for(let i=0;i<N;i++)acc=(acc+s[i].length*(i%13))%1000003;
const end=Date.now();console.log("Result: "+acc);console.log("Time: "+Math.floor(end-start)+"ms")
