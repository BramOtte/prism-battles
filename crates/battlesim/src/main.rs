use rand::{distributions::Uniform, thread_rng, Rng};
use rayon::prelude::*;


fn main() {
    println!("Hello, world!");

    let attack = 10;
    let defense = 10;
    for attack in 1..=10 {
    //     for defense in 1..=10 {
            println!("{} {} {}", defense, attack, sim(defense, attack));
    //     }
    }

}


fn sim(defense: i32, offense: i32) -> f64 {
    let count = 20000000;

    let wounds = (0..count)
        .into_par_iter()
        .map(|_| {
        let die_dis = Uniform::from(0..=5);

        let mut dice: Vec<i32> = thread_rng().sample_iter(die_dis).take(offense as usize)
            .filter(|&die| die != 0)
            .collect();
        dice.sort_by(|a, b| b.cmp(a));
        let dice = dice;

        // println!("first {:?}", dice);

        if defense > 5 {
            let mut points = dice.len() as i32;
            let mut max_second_assault = 0;
            for die in dice.iter().copied() {
                if die < 5 {
                    let delta = 1 + (5-die);
                    if delta > points  {
                        break;
                    }
                    points -= delta;
                } else {
                    points -= 1;
                }
                max_second_assault += 1;
            }

            let best = (0..=max_second_assault).map(|chosen| {
                let mut wounds = 0;
                let mut second_dice: Vec<i32> = thread_rng().sample_iter(die_dis).take(chosen).collect();

                // println!("second {:?}", second_dice);

                second_dice.sort_by(|a, b| b.cmp(a));
                let second_dice = second_dice;
                let mut points = dice.len() as i32 - second_dice.iter().copied().filter(|&die| die == 0).count() as i32;
                for i in 0..second_dice.len() {
                    if second_dice[i] == 0 {
                        continue;
                    }

                    if second_dice[i]+5 < defense {
                        let delta = 1 + (5-dice[i]) + (defense-5-second_dice[i]);
                        if delta > points {
                            break;
                        }
                        points -= delta;
                    } else {
                        points -= 1;
                    }
                    wounds += 1;
                }
                for i in second_dice.len()..dice.len() {
                    let delta = 1 + (defense-dice[i]);
                    if delta > points {
                        break;
                    }
                    points -= delta;

                    wounds += 1;
                }
                wounds
            }).max().unwrap_or(0);

            // println!("{}\n", best);
            best
        } else {
            let mut points = dice.len() as i32;
            let mut wounds = 0;
            for i in 0..dice.len() {
                if dice[i] < defense {
                    let delta = defense+1-dice[i];
                    if delta > points {
                        break;
                    }
                    points -= delta
                } else {
                    points -= 1;
                }

                wounds += 1;
            }
            // println!("{}\n", wounds);
            wounds
        }
    }).sum::<usize>();


    wounds as f64 / count as f64
    // let discard = rng.gen_range(0..dice.len())
}