function f(x){return x*x*x-2*x*x+3}
let N=2000000,h=10/N,s=f(0)+f(10);
const start=Date.now();
for(let i=1;i<N;i++){let x=i*h;s+=i%2==0?2*f(x):4*f(x)}
let r=s*h/3;const end=Date.now();
console.log("Result: "+r);console.log("Time: "+Math.floor(end-start)+"ms")
