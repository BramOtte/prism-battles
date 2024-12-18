mod formats;
use std::{fs::File, io::BufReader, path::Path, time::Instant};

use formats::{smg::Smg, states::States, dtmc::Dtmc};
use rand::{thread_rng, Rng};
use rayon::prelude::*;


fn main() {
    let folder = Path::new("../../out/strats/6-6");

    // {
    //     let start = Instant::now();
    //     let tra = folder.join("model.tra");
    //     let tra = BufReader::new(File::open(tra).unwrap());
    //     let tra = Smg::load(tra).unwrap();
    //     let end = Instant::now();

    //     println!("{:?}", end.duration_since(start));
    //     println!("{} {} {}", tra.states.len(), tra.actions.len(), tra.transitions.len());
    //     return;
    // }

    let states = folder.join("states.sta");
    let states = BufReader::new(File::open(states).unwrap());
    let states = States::load(states).unwrap();

    let initial_values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6];



    println!("{:?} {:?} {}", states.header, states.data.len(), states.data.len() / states.header.len());

    let transitions_names = [
        "rmax.tra",
        "rmax-reroll.tra"
        , "pmax1.tra", "pmax2.tra", "pmax3.tra", "pmax4.tra", "pmax5.tra", "pmax6.tra", "pmax7.tra", "pmax8.tra", "pmax9.tra", "pmax10.tra"
        ];
    let transitions: Vec<Dtmc> = transitions_names.par_iter().map(|trans| {
        let trans = folder.join(trans);
        println!("{:?}", trans);
        let trans = BufReader::new(File::open(trans).unwrap());
        let trans = Dtmc::load(trans).unwrap();

        trans
    }).collect();

    let mut initial_state = 0;
    println!("{:?} {}", states.header, states.data.len());

    for i in 0..states.state_count() as u32 {
        if states.get(i) == initial_values {
            initial_state = i;
            break;
        }
    }
    let initial_state = initial_state;
    if initial_state == 0 {
        panic!("Unable to find initial state {:?}", initial_values)
    }

    for (trans, name) in transitions.iter().zip(transitions_names.iter()) {
        let count = 1_000_000;
        let a = Instant::now();
        let wounds: Vec<i32> = (0..count).into_par_iter().map(|_| {
            let state = {
                let this = &trans;
                let mut state = initial_state;
                let mut rng = thread_rng();
                loop {
                    let next = this.step(state, rng.gen_range(0f32..1f32));
                    if next == state {
                        break state;
                    }

                    state = next;
                }
            };
            let values = states.get(state);
            let wounds = values[10];
            wounds
        }).collect();

        let b = Instant::now();

        let total = wounds.par_iter().copied().map(|w| w as i64).sum::<i64>();
        let w1  = wounds.par_iter().copied().filter(|&w| w >=  1).count() as f64 / count as f64;
        let w2  = wounds.par_iter().copied().filter(|&w| w >=  2).count() as f64 / count as f64;
        let w3  = wounds.par_iter().copied().filter(|&w| w >=  3).count() as f64 / count as f64;
        let w4  = wounds.par_iter().copied().filter(|&w| w >=  4).count() as f64 / count as f64;
        let w5  = wounds.par_iter().copied().filter(|&w| w >=  5).count() as f64 / count as f64;
        let w6  = wounds.par_iter().copied().filter(|&w| w >=  6).count() as f64 / count as f64;
        let w7  = wounds.par_iter().copied().filter(|&w| w >=  7).count() as f64 / count as f64;
        let w8  = wounds.par_iter().copied().filter(|&w| w >=  8).count() as f64 / count as f64;
        let w9  = wounds.par_iter().copied().filter(|&w| w >=  9).count() as f64 / count as f64;
        let w10 = wounds.par_iter().copied().filter(|&w| w >= 10).count() as f64 / count as f64;

        let avg = total as f64 / count as f64;
        let c = Instant::now();


        println!("{}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.9}\t{:.6?}\t{:.6?}", name, avg, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, b.duration_since(a), c.duration_since(b));
        let exp = trans.expected_value(initial_state, &|state| {
            let values = states.get(state);
            if values[14] == 8 {values[10]} else {0}
        });
        print!("\t\t{:.9}", exp);
        for min in 1..=10 {
            let prob = trans.expected_value(initial_state, &|state| {
                let values = states.get(state);
                if values[14] == 8 && values[10] >= min {1} else {0}
            });
            print!("\t{:.9}", prob);
        }
        println!();
    }

    // let mut rng = thread_rng();

    // for i in 0..10 {

    //     let mut state = 0;
    //     for i in 0..states.state_count() as u32 {
    //         if states.get(i) == initial_state {
    //             state = i;
    //             break;
    //         }
    //     }

    //     println!("{}", states.header.join("\t"));
    //     for value in states.get(state) {
    //         print!("{}\t", value)
    //     }
    //     println!("{}", transitions_names[0]);

    //     loop {
    //         let rand = rng.gen_range(0f32..1f32);
    //         let mut next = transitions.iter().map(|trans| {
    //             trans.step(state, rand)
    //         });
    //         let first = next.next().unwrap();
    //         for value in states.get(first) {
    //             print!("{}\t", value)
    //         }
    //         println!("{}", transitions_names[0]);

    //         let mut stop = false;
    //         for (state, name) in next.zip(transitions_names.iter().skip(1)) {
    //             if state == first {
    //                 continue;
    //             }
    //             if !stop {
    //                 println!("vvvv");
    //             }
    //             stop = true;
    //             for value in states.get(state) {
    //                 print!("{}\t", value)
    //             }
    //             println!("{}", name);
    //         }
    //         if stop {
    //             break;
    //         }
    
    //         // println!("{}", next_state);
    //         if first == state {
    //             break;
    //         }
    //         state = first;
    //     }
    //     println!();
    // }



    // println!("defense\toffense\texpected wounds");

    // let attack = 10;
    // let defense = 10;
    // for attack in 10..=10 {
    //     for defense in 5..=10 {
    //         println!("{}\t{}\t{}", defense, attack, sim(defense, attack));
    //     }
    // }

}