use std::collections::HashSet;

fn main() {
    let content = std::fs::read_to_string("../day8.txt").expect("couldn't open file");

    let inst = content
        .lines()
        .map(|sub| sub.parse::<Inst>().unwrap())
        .collect::<Vec<Inst>>();

    println!("part one: {:?}", part_one(inst))
}

fn part_one(instructions: Vec<Inst>) -> i64 {
    let mut map: HashSet<usize> = HashSet::new();

    let mut accumulator = 0;
    let mut index = 0;

    loop {
        if map.contains(&index) {
            return accumulator;
        }

        map.insert(index);

        match instructions[index].0 {
            OP::ACC => accumulator += instructions[index].1,
            OP::JMP => {
                index = (instructions[index].1 + (index as i64)) as usize;
                continue;
            }
            OP::NOP => {}
        }
        index += 1;
        if index == instructions.len() {
            return accumulator;
        }
    }
}

enum OP {
    ACC,
    JMP,
    NOP,
}

struct Inst(OP, i64);

impl std::str::FromStr for Inst {
    type Err = std::num::ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let parts = s.split_whitespace().collect::<Vec<&str>>();
        Ok(Inst(
            match parts[0] {
                "acc" => OP::ACC,
                "jmp" => OP::JMP,
                "nop" => OP::NOP,
                _ => unreachable!(),
            },
            parts[1].parse()?,
        ))
    }
}
