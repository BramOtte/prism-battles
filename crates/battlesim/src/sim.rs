fn sim(defense: i32, offense: i32) -> f64 {
    let outer_loop = 10000;
    let inner_loop = 20000;

    let wounds = (0..outer_loop)
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

            // Sampling bias here because we pick the best result, should be minimized as inner_loop becomes larger
            let best = (0..=max_second_assault).map(|chosen| {
                let mut wounds = 0;
                for _ in 0..inner_loop {
                    let mut dice: Vec<i32> = dice.clone();
                    let mut discard = 0;
                    for (i, die2) in thread_rng().sample_iter(die_dis).take(chosen).enumerate() {
                        discard += 5 - dice[i] as usize;
                        if die2 > 0 {
                            dice[i] += die2;
                        } else {
                            dice[i] = 0;
                        }
                    }
                    assert!(discard <= dice.len() - chosen);
                    dice.truncate(dice.len() - discard);
                    dice.retain(|&die| die > 0);
                    dice.sort_by(|a, b| b.cmp(a));
                    let dice = dice;

                    let mut points = dice.len() as i32;
                    for i in 0..dice.len() {
                        if dice[i] < defense {
                            let delta = 1 + (defense-dice[i]);
                            if delta > points {
                                break;
                            }
                            points -= delta
                        } else {
                            points -= 1;
                        }
    
                        wounds += 1;
                    }
                }
                // println!("{}\n", wounds);
                wounds
            }).max().unwrap_or(0);

            // println!("{}\n", best);
            best
        } else {
            let mut wounds = 0;
            let mut points = dice.len() as i32;
            for i in 0..dice.len() {
                if dice[i] < defense {
                    let delta = 1 + (defense-dice[i]);
                    if delta > points {
                        break;
                    }
                    points -= delta
                } else {
                    points -= 1;
                }

                wounds += 1;
            }
            wounds * inner_loop
        }
    }).sum::<usize>();


    wounds as f64 / (outer_loop * inner_loop) as f64
}