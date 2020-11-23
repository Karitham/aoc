use std::collections::HashMap;

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
    fn move_up(&mut self) {
        self.y += 1;
    }
    fn move_down(&mut self) {
        self.y -= 1;
    }
    fn move_right(&mut self) {
        self.x += 1;
    }
    fn move_left(&mut self) {
        self.x -= 1
    }
    fn move_one(&mut self, d: &Instruction) {
        match d.direction {
            Direction::Right => self.move_right(),
            Direction::Left => self.move_left(),
            Direction::Up => self.move_up(),
            Direction::Down => self.move_down(),
        };
    }

    fn manhattan(&self) -> u64 {
        self.x.abs() as u64 + self.y.abs() as u64
    }
}

impl Instruction {
    fn parse(input: &str) -> Instruction {
        let b = input.as_bytes()[0];

        Instruction {
            direction: match b {
                b'R' => Direction::Right,
                b'L' => Direction::Left,
                b'U' => Direction::Up,
                b'D' => Direction::Down,
                _ => unreachable!(),
            },

            length: input[1..].parse::<i64>().unwrap(),
        }
    }
}

fn get_vec(line: &str) -> Vec<Instruction> {
    let mut wire: Vec<Instruction> = Vec::new();

    for field in line.rsplit(',').rev() {
        wire.push(Instruction::parse(field));
    }

    wire
}

fn get_input(filename: &str) -> (Vec<Instruction>, Vec<Instruction>) {
    let contents =
        std::fs::read_to_string(filename).expect("Something went wrong reading the file");

    let mut lines = contents.lines();

    (
        get_vec(lines.next().unwrap()),
        get_vec(lines.next().unwrap()),
    )
}

fn crosses(w1: Vec<Instruction>, w2: Vec<Instruction>) -> Vec<Point> {
    let mut map = HashMap::new();

    let mut crosses_at: Vec<Point> = Vec::new();

    let mut p1: Point = Point::new(0, 0);
    let mut p2: Point = Point::new(0, 0);

    for inst in w1.iter() {
        for _ in 0..inst.length {
            p1.move_one(inst);
            map.insert(p1, 0);
        }
    }

    for inst in w2.iter() {
        for _ in 0..inst.length {
            p2.move_one(inst);
            if map.contains_key(&p2) {
                crosses_at.push(p2);
            };
        }
    }

    crosses_at
}

fn main() {
    let (w1, w2) = get_input("../../inputs/day3.txt");
    let c = crosses(w1, w2);

    let mut lowest: u64 = c[0].manhattan();

    for point in c.iter() {
        lowest = if lowest < point.manhattan() {
            lowest
        } else {
            point.manhattan()
        }
    }

    println!("closest point to center is {}", lowest)
}
