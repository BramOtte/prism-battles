use rand::{thread_rng, Rng};

use crate::formats::transitions;

pub struct Transitions {
    pub states: Vec<u32>,
    pub transitions: Vec<(u32, f32)>,
}

impl Transitions {
    pub fn load<R: std::io::BufRead>(file: R) -> std::io::Result<Self> {
        let mut lines = file.lines();
        let first_line = lines.next().unwrap()?;
        let mut first_line = first_line.split(' ');
        let num_states: usize = first_line.next().unwrap().parse().unwrap();
        let num_transitions: usize = first_line.next().unwrap().parse().unwrap();

        let mut states: Vec<u32> = Vec::with_capacity(num_states);
        let mut transitions: Vec<(u32, f32)> = Vec::with_capacity(num_transitions);

        for line in lines {
            let line = line?;
            let mut line = line.split(" ");
            let from: u32 = line.next().unwrap().parse().unwrap();
            let to: u32 = line.next().unwrap().parse().unwrap();
            let prob: f32 = line.next().unwrap().parse().unwrap();

            if from == states.len() as u32 {
                states.push(transitions.len() as u32);
            } else {
                assert_eq!(from as usize, states.len() - 1);
            }

            transitions.push((to, prob));
        }
        states.push(transitions.len() as u32);

        Ok(Self { states, transitions })
    }

    pub fn get(&self, state: u32) -> &[(u32, f32)] {
        let start = self.states[state as usize] as usize;
        let end = self.states[state as usize + 1] as usize;
        &self.transitions[start..end]
    }

    pub fn step(&self, state: u32, rand: f32) -> u32 {
        let mut tot = 0f32;
        for (state, prob) in self.get(state).iter().copied() {
            // println!("{}>=x<{} -> {}", tot, tot+prob, state);
            if rand >= tot && rand < tot + prob {
                // println!("state {}", state);
                return state;
            }
            tot += prob;
        }

        return state;
    }

    pub fn sim(&self, mut state: u32) -> u32 {
        let mut rng = thread_rng();
        loop {
            let next = self.step(state, rng.gen_range(0f32..1f32));
            if next == state {
                break state;
            }
            state = next;
        }
    }

    pub fn expected_value<F: Fn(u32) -> i32>(&self, state: u32, f: &F) -> f64 {
        let mut cache = vec![None; self.states.len()-1];
        self.expected_value_r(state, &mut cache, f)
    }


    fn expected_value_r<F: Fn(u32) -> i32>(&self, state: u32, cache: &mut [Option<f64>], f: &F) -> f64 {
        if let Some(result) = cache[state as usize] {
            return result;
        }

        let base_reward = f(state);
        let transitions = self.get(state);
        let mut reward = base_reward as f64;
        for &(next, prob) in transitions {
            if next == state {
                assert_eq!(transitions.len(), 1);
                return reward;
            }
            reward += self.expected_value_r(next, cache, f) * prob as f64;
        }
        cache[state as usize] = Some(reward);

        reward
    }
}
