const n=200000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
const strings=[];for(let i=0;i<n;i++){let s="";if(ri(2)===0)s="-";let nd=1+ri(9);s+=String(1+ri(9));for(let j=1;j<nd;j++)s+=String(ri(10));strings.push(s)}
const start=Date.now();let total=0;const M=1000003
for(let si=0;si<n;si++){let s=strings[si],neg=false,idx=0;if(s[0]==='-'){neg=true;idx=1}let val=0
while(idx<s.length){let c=s[idx],d;if(c==='0')d=0;else if(c==='1')d=1;else if(c==='2')d=2;else if(c==='3')d=3;else if(c==='4')d=4;else if(c==='5')d=5;else if(c==='6')d=6;else if(c==='7')d=7;else if(c==='8')d=8;else d=9
val=val*10+d;idx++}if(neg)val=-val;total+=val}
let r=((total%M)+M)%M;const end=Date.now();console.log(`Result: ${r}`);console.log(`Time: ${end-start}ms`)
