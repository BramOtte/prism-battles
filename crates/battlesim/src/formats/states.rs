use std::collections::HashMap;

#[derive(Debug)]
pub struct States {
    pub header: Vec<String>,
    pub data: Vec<i32>,
}

impl States {
    pub fn state_count(&self) -> usize {
        self.data.len() / self.header.len()
    }

    pub fn get(&self, state: u32) -> &[i32] {
        &self.data[state as usize*self.header.len()..(state as usize+1)*self.header.len()]
    }

    pub fn inverse(&self) -> HashMap<Vec<i32>, u32> {
        let mut inverse = HashMap::new();
        for state in 0..self.state_count() as u32 {
            let values = self.get(state);
            inverse.insert(values.to_owned(), state);
        }

        inverse
    }

    pub fn load<R: std::io::BufRead>(file: R) -> std::io::Result<Self> {
        let mut lines = file.lines();
        let first_line = lines.next().unwrap()?;
        let header: Vec<String> = first_line[1..first_line.len()-1].split(',').map(str::to_owned).collect();;
        let mut data: Vec<i32> = Vec::new();
    
        for line in lines {
            let line = line?;
            let Some((index, line)) = line.split_once(':') else {
                break;
            };
            let index: usize = index.parse().unwrap();
            assert_eq!(index, data.len() / header.len());
    
            data.reserve(header.len());
            for value in line[1..line.len()-1].split(',') {
                let value: i32 = value.parse().unwrap();
                data.push(value);
            }
    
            assert_eq!(data.len() % header.len(), 0);
        }
    
        Ok(Self { header, data })
    }
}
