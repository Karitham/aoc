use std::str::FromStr;

type Grid = Vec<Vec<Seat>>;

const ADJ_SEATS: [(i32, i32); 8] = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
];

fn main() {
    let content = std::fs::read_to_string("../day11.txt").expect("couldn't open file");
    let area = content
        .lines()
        .map(|l| {
            l.chars()
                .map(|c| (c.to_string()).parse::<Seat>().unwrap())
                .collect::<Vec<Seat>>()
        })
        .collect::<Grid>();

    println!("part one: {}", part_one(area.clone()));
}

fn part_one(input: Grid) -> usize {
    let mut seats = input.clone();
    let mut prev_count = 0;

    loop {
        seats = apply_rule(&seats, 4);

        let occupied = seats
            .iter()
            .flatten()
            .filter(|s| **s == Seat::Occupied)
            .count();

        if occupied == prev_count {
            return prev_count;
        }

        prev_count = occupied;
    }
}

fn apply_rule(seats: &Grid, max_adjacent: usize) -> Grid {
    let mut new_seats = seats.clone();
    for y in 0..seats.len() {
        for x in 0..seats[0].len() {
            match seats[y][x] {
                Seat::Floor => {}
                Seat::Occupied => {
                    if adjacent_occupied(&seats, x, y) >= max_adjacent {
                        new_seats[y][x] = Seat::Empty
                    };
                }
                Seat::Empty => {
                    if adjacent_occupied(&seats, x, y) == 0 {
                        new_seats[y][x] = Seat::Occupied;
                    };
                }
            }
        }
    }
    new_seats
}

fn adjacent_occupied(seats: &Grid, x: usize, y: usize) -> usize {
    ADJ_SEATS
        .iter()
        .map(|(dx, dy)| {
            seats
                .get((y as i32 + dy) as usize)
                .and_then(|row| row.get((x as i32 + dx) as usize))
                .unwrap_or(&Seat::Floor)
        })
        .filter(|&s| *s == Seat::Occupied)
        .count()
}

#[derive(Eq, PartialEq, Clone, Copy)]
enum Seat {
    Floor,
    Occupied,
    Empty,
}

impl FromStr for Seat {
    type Err = std::num::ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "." => Ok(Seat::Floor),
            "#" => Ok(Seat::Occupied),
            "L" => Ok(Seat::Empty),
            _ => unreachable!(),
        }
    }
}

#[test]
fn test_p1() {
    let grid = r#"L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"#;

    let input = grid
        .lines()
        .map(|l| {
            l.trim()
                .chars()
                .map(|c| (c.to_string()).parse::<Seat>().unwrap())
                .collect::<Vec<Seat>>()
        })
        .collect::<Grid>();

    assert_eq!(part_one(input), 37);
}
