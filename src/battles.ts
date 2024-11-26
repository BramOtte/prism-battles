export function dice() {
    const sides = 6;
    return 0| Math.random() * sides;
}

function decide(label: string) {
    return Math.random() > 0.5;
}
function decide_range(min: number, max: number) {
    return 0| Math.random() * (max - min) + min;
}

export async function battles_sim() {
    // a. Effective value calculation
    const player1 = {
        offence: 10,
        defence: 1,
    };
    
    const player2: typeof player1 = {
        offence: 2,
        defence: 6,
    };
    
    const attacker = player1;
    const defender = player2;

    const dashboard: number[] = [];

    function wounds() {
        for (const die of dies1) {
            if (die >= defender.defence) {
                dashboard.push(die)
            }
        }
        dies1 = dies1.filter(v => v > 0 && v < defender.defence);
        console.log("dies", dies1.join(" "));
        console.log("dash", dashboard.join(" "));
    }
    
    // b. First assault
    // .1 The attacker rolls a number of dice equal to their effective offence.
    let dies1 = Array.from({length: attacker.offence}, dice);
    dies1.sort((a, b) => a - b);
    console.log(dies1.join(" "));
    // .2 Any blank results are immediately removed. For each step, once a die has been removed, it is set aside and takes no further part in this attack.
    dies1 = dies1.filter(v => v > 0);
    wounds();

    
    
    // .3 Among the remaining dice, the attacker can discard as many dice as they want to get bonuses for the other dice. Each discarded die adds +1 to the result of another die. The new value of the remaining dice is equal to their result increased by the number of dice discarded to give them bonuses.
    // decision: (false,true)[numdie]
    const discard = decide_range(0, dies1.length); dies1.map(() => decide(`discard`));
    console.log(discard, "/", dies1.length);
    let points = discard;
    dies1 = dies1.filter((v, i) => i >= discard);
    console.log(dies1.join(" "));
    // hold, discard, second assault, attack

    for (let i = 0; i < dies1.length - 1; i += 1) {
        const max = Math.min(points, Math.max(0, defender.defence - dies1[i]));
        const x = decide_range(0, max);
        // console.log(max, x);
        points -= x;
        dies1[i] += x;
    }
    if (dies1.length > 0) {
        dies1[dies1.length - 1] += points;
    }
    
    console.log(dies1.join(" "));
    // At each step, as soon as the value of a die equals or exceeds the effective defence of the target, the die is immediately placed on the attacker’s dashboard or troop card to signify that they have inflicted a wound on the target (see 2.d  wounds)
    for (const die of dies1) {
        if (die >= defender.defence) {
            dashboard.push(die)
        }
    }
    dies1 = dies1.filter(v => v < defender.defence);
    console.log("dashboard", dashboard.join(" "));

    // c. Second Assault
    // If, during the first assault, the attacker rolled one or several dice with a result of 5, no matter if it was a direct result or after modification, they can carry out a second assault. To do this, carry out the following steps in order. If not, go straight to step 2.d  wounds.
    let dies2 = dies1.filter(v => v == 5);
    
    const rerolls = dies2.filter(v => {
        // decision: false,true
        return decide("reroll");
    });



    // .1 The attacker rolls as many dice as they wish from those of the first assault with a result equal to 5.
}


battles_sim();