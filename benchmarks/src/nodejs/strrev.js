const n=50000,s="a".repeat(n),start=Date.now();
let buf=[];for(let i=n-1;i>=0;i--)buf.push(s[i]);
let r=buf.join('');const end=Date.now();
console.log('Result: '+r[0]+'/'+r.length);console.log('Time: '+Math.floor(end-start)+'ms')