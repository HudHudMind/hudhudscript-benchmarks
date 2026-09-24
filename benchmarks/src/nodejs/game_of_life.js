const G=96,T=100;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let a=[],b=[];for(let i=0;i<G;i++){a[i]=[];b[i]=[];for(let j=0;j<G;j++){a[i][j]=ri(100)<35?1:0;b[i][j]=0}}
const start=Date.now();
for(let t=0;t<T;t++){for(let i=0;i<G;i++)for(let j=0;j<G;j++){let nbr=0;for(let di=-1;di<=1;di++)for(let dj=-1;dj<=1;dj++)if(!(di==0&&dj==0))nbr+=a[(i+di+G)%G][(j+dj+G)%G];b[i][j]=a[i][j]==1?(nbr==2||nbr==3?1:0):(nbr==3?1:0)}let t2=a;a=b;b=t2}
let alive=0;for(let i=0;i<G;i++)for(let j=0;j<G;j++)alive+=a[i][j]
const end=Date.now();console.log("Result: "+alive);console.log("Time: "+Math.floor(end-start)+"ms")
