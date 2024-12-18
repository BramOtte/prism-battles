pub struct Smg {
    pub num_players: usize,
    pub states: Vec<u32>,
    pub players: Vec<u8>,
    pub actions: Vec<u32>,
    pub transitions: Vec<(u32, f32)>,
    // pub guard_indices: Vec<u32>,
    // pub guard_labels: Vec<String>,
}

impl Smg {
    pub fn load<R: std::io::BufRead>(file: R) -> std::io::Result<Self> {
        let mut lines = file.lines();
        let first_line = lines.next().unwrap()?;

        let (num_states, first_line) = first_line.split_once(':').unwrap();
        let num_states: usize = num_states.parse().unwrap();

        let mut first_line = first_line.split(' ');
        let num_players: usize = first_line.next().unwrap().parse().unwrap();
        assert!(num_players < 256);
        let num_choices: usize = first_line.next().unwrap().parse().unwrap();
        let num_transitions: usize = first_line.next().unwrap().parse().unwrap();

        let mut states: Vec<u32> = Vec::with_capacity(num_states);
        let mut players: Vec<u8> = Vec::with_capacity(num_choices);
        let mut actions: Vec<u32> = Vec::with_capacity(num_choices);
        let mut transitions: Vec<(u32, f32)> = Vec::with_capacity(num_transitions);

        let mut action_i = 0;

        for line in lines {
            let line = line?;
            let line_str = &line;

            let (from, line) = line.split_once(":").unwrap();
            let from: u32 = from.parse().unwrap();

            let mut line = line.split(" ");

            let player: u8 = line.next().unwrap().parse().unwrap();
            let action: u32 = line.next().unwrap().parse().unwrap();
            let to: u32 = line.next().unwrap().parse().unwrap();
            let prob: f32 = line.next().unwrap().parse().unwrap();
            let quard_label: &str = line.next().unwrap();

            if from == states.len() as u32 {
                states.push(actions.len() as u32);
                action_i = 0;
            } else {
                assert_eq!(from as usize, states.len() - 1);
            }

            if action == action_i {
                actions.push(transitions.len() as u32);
                players.push(player);
                action_i += 1;
            } else {
                if (action + 1 != action_i) || (action > 0 && players.last().copied() != Some(player)) {
                    eprintln!("{} {} {:?} {}", action, action_i, players.last(), player);
                    panic!("{}", line_str);
                }
            }


            transitions.push((to, prob));
        }
        states.push(transitions.len() as u32);

        Ok(Self { states, players, actions, transitions, num_players })
    }

    pub fn actions(&self, state: u32) -> &[u32] {
        let start = self.states[state as usize] as usize;
        let end = self.states[state as usize + 1] as usize;
        &self.actions[start..end]
    }

    pub fn transitions(&self, action: u32) -> &[(u32, f32)] {
        let start = self.actions[action as usize] as usize;
        let end = self.actions[action as usize + 1] as usize;
        &self.transitions[start..end]
    }
}