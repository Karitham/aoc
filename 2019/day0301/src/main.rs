use std::{collections::HashSet, str::FromStr};

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

    fn manhattan(&self) -> u64 {
        self.x.abs() as u64 + self.y.abs() as u64
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

fn to_vec(line: &str) -> Vec<Instruction> {
    line.rsplit(',')
        .rev()
        .map(|instruction| Instruction::from_str(instruction).unwrap())
        .collect()
}

impl Instruction {
    fn to_set(wire: &Vec<Instruction>) -> HashSet<Point> {
        let mut set: HashSet<Point> = HashSet::new();
        let mut point: Point = Point::new(0, 0);

        for inst in wire {
            for _ in 0..inst.length {
                point.move_one(&inst.direction);
                set.insert(point);
            }
        }

        set
    }
}

fn get_input(filename: &str) -> (Vec<Instruction>, Vec<Instruction>) {
    let contents =
        std::fs::read_to_string(filename).expect("Something went wrong reading the file");

    let mut lines = contents.lines();

    (
        lines.next().map(to_vec).unwrap(),
        lines.next().map(to_vec).unwrap(),
    )
}

fn crosses(w1: Vec<Instruction>, w2: Vec<Instruction>) -> Vec<Point> {
    let set_1 = Instruction::to_set(&w1);
    let set_2 = Instruction::to_set(&w2);

    set_1.intersection(&set_2).cloned().collect()
}

fn main() {
    let (w1, w2) = get_input("../../inputs/day3.txt");

    let crossing_points = crosses(w1, w2);

    let lowest = match crossing_points.iter().map(Point::manhattan).min() {
        Some(v) => v,
        None => panic!("No points cross themselves"),
    };

    println!("closest intersection to the center is {}", lowest)
}
