const PI = 3.141592653589793;
const SOLAR_MASS = 4 * PI * PI;
const DAYS_PER_YEAR = 365.24;

function advance(bodies, dt) {
    const n = bodies.length;
    for (let i = 0; i < n; i++) {
        const bi = bodies[i];
        for (let j = i + 1; j < n; j++) {
            const bj = bodies[j];
            const dx = bi[0] - bj[0];
            const dy = bi[1] - bj[1];
            const dz = bi[2] - bj[2];
            
            const dsq = dx*dx + dy*dy + dz*dz;
            const distance = Math.sqrt(dsq);
            const mag = dt / (dsq * distance);
            
            bi[3] -= dx * bj[6] * mag;
            bi[4] -= dy * bj[6] * mag;
            bi[5] -= dz * bj[6] * mag;
            
            bj[3] += dx * bi[6] * mag;
            bj[4] += dy * bi[6] * mag;
            bj[5] += dz * bi[6] * mag;
        }
    }
    for (let i = 0; i < n; i++) {
        const bi = bodies[i];
        bi[0] += dt * bi[3];
        bi[1] += dt * bi[4];
        bi[2] += dt * bi[5];
    }
}

function energy(bodies) {
    let e = 0.0;
    const n = bodies.length;
    for (let i = 0; i < n; i++) {
        const bi = bodies[i];
        e += 0.5 * bi[6] * (bi[3]*bi[3] + bi[4]*bi[4] + bi[5]*bi[5]);
        for (let j = i + 1; j < n; j++) {
            const bj = bodies[j];
            const dx = bi[0] - bj[0];
            const dy = bi[1] - bj[1];
            const dz = bi[2] - bj[2];
            const distance = Math.sqrt(dx*dx + dy*dy + dz*dz);
            e -= (bi[6] * bj[6]) / distance;
        }
    }
    return e;
}

const bodies = [
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
    [4.84143144246472090, -1.16032004402742839, -0.103622044471123109,
     1.66007664274403694 * 1e-3 * DAYS_PER_YEAR, 7.69901118419740425 * 1e-3 * DAYS_PER_YEAR, -6.90460016972063023 * 1e-5 * DAYS_PER_YEAR,
     9.54791938424326609 * 1e-4 * SOLAR_MASS],
    [8.34336671824457987, 4.12479856412430479, -0.403523417114321381,
     -2.76742510726862411 * 1e-3 * DAYS_PER_YEAR, 4.99852801234917238 * 1e-3 * DAYS_PER_YEAR, 2.30417297573763929 * 1e-5 * DAYS_PER_YEAR,
     2.85885980666130812 * 1e-4 * SOLAR_MASS],
    [12.8943695621391310, -15.1111514016986312, -0.223307578892655734,
     2.96460137564761618 * 1e-3 * DAYS_PER_YEAR, 2.37847173959480950 * 1e-3 * DAYS_PER_YEAR, -2.96589568540237556 * 1e-5 * DAYS_PER_YEAR,
     4.36624404335156298 * 1e-5 * SOLAR_MASS],
    [15.3796971148509165, -25.9193146099879641, 0.179258772950371181,
     2.68067772490389322 * 1e-3 * DAYS_PER_YEAR, 1.62824170038242295 * 1e-3 * DAYS_PER_YEAR, -9.51592254519715870 * 1e-5 * DAYS_PER_YEAR,
     5.15138902046611451 * 1e-5 * SOLAR_MASS]
];

let px = 0.0, py = 0.0, pz = 0.0;
for (let i = 0; i < bodies.length; i++) {
    px += bodies[i][3] * bodies[i][6];
    py += bodies[i][4] * bodies[i][6];
    pz += bodies[i][5] * bodies[i][6];
}
bodies[0][3] = -px / SOLAR_MASS;
bodies[0][4] = -py / SOLAR_MASS;
bodies[0][5] = -pz / SOLAR_MASS;

const start = Date.now();
const e1 = energy(bodies);
for (let i = 0; i < 10000; i++) {
    advance(bodies, 0.01);
}
const e2 = energy(bodies);
const end = Date.now();

console.log(`Result: ${e1.toFixed(9)}_${e2.toFixed(9)}`);
console.log(`Time: ${end - start}ms`);
