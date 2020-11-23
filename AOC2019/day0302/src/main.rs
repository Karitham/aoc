use std::{collections::HashMap, str::FromStr};

struct Instruction {
    direction: Direction,
    length: i64,
}
enum Direction {
    Right,
    Left,
    Up,
    Down,
}

#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash)]
struct Point {
    x: i64,
    y: i64,
}

impl Point {
    fn new(x: i64, y: i64) -> Self {
        Self { x, y }
    }

    fn move_one(&mut self, d: &Direction) {
        match d {
            Direction::Right => self.x += 1,
            Direction::Left => self.x -= 1,
            Direction::Up => self.y += 1,
            Direction::Down => self.y -= 1,
        };
    }
}

impl FromStr for Instruction {
    type Err = std::string::ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let b = s.as_bytes()[0];

        Ok(Instruction {
            direction: match b {
                b'R' => Direction::Right,
                b'L' => Direction::Left,
                b'U' => Direction::Up,
                b'D' => Direction::Down,
                _ => unreachable!(),
            },

            length: s[1..].parse::<i64>().unwrap(),
        })
    }
}

fn to_map(wire: Vec<Instruction>) -> HashMap<Point, u64> {
    let mut map: HashMap<Point, u64> = HashMap::new();
    let mut point: Point = Point::new(0, 0);
    let mut move_count: u64 = 0;

    for instruction in &wire {
        for _ in 0..instruction.length {
            point.move_one(&instruction.direction);
            move_count += 1;

            map.insert(point, move_count);
        }
    }

    map
}

fn get_input(filename: &str) -> (Vec<Instruction>, Vec<Instruction>) {
    fn to_vec(line: &str) -> Vec<Instruction> {
        line.rsplit(',')
            .rev()
            .map(|instruction| Instruction::from_str(instruction).unwrap())
            .collect()
    }

    let contents =
        std::fs::read_to_string(filename).expect("Something went wrong reading the file");

    let mut lines = contents.lines();

    (
        lines.next().map(to_vec).unwrap(),
        lines.next().map(to_vec).unwrap(),
    )
}

fn get_signal(wire_1: &HashMap<Point, u64>, wire_2: &HashMap<Point, u64>) -> HashMap<Point, u64> {
    let mut results: HashMap<Point, u64> = HashMap::new();

    for (elem, length) in wire_1.into_iter() {
        if wire_2.contains_key(elem) {
            results.insert(*elem, length + wire_2.get(elem).unwrap());
        }
    }

    results
}

fn main() {
    let (wire_1, wire_2) = get_input("../../inputs/day3.txt");

    let w1 = to_map(wire_1);
    let w2 = to_map(wire_2);

    let signals = get_signal(&w1, &w2);
    let smallest = match signals.into_iter().map(|tuple| tuple.1).min() {
        Some(v) => v,
        None => 0,
    };

    println!("The smallest signal is {}", smallest);
}
