fn main() {
    let map = get_input("../day3.txt");

    println!("part one: {}", part_one(map, 3, 1));

    println!(
        "part two: {}",
        part_one(map, 1, 1)
            * part_one(map, 3, 1)
            * part_one(map, 5, 1)
            * part_one(map, 7, 1)
            * part_one(map, 1, 2)
    )
}

/// Part_one is implemented as such that it can be reused so part 2 is basically part one a bunch of times
fn part_one(map: [[bool; 31]; 323], right: usize, down: usize) -> i64 {
    let mut tree_count = 0;
    let (mut x, mut y) = (0, 0);

    loop {
        if map[y][x] {
            tree_count += 1;
        }

        y += down;
        x = (x + right) % map[0].len();

        if y >= map.len() {
            break;
        }
    }

    tree_count
}

/// Only works for my input, I should have used something else than arrays but this works well for me
fn get_input(filename: &str) -> [[bool; 31]; 323] {
    let input = std::fs::read_to_string(filename).expect("couldn't read file");

    let mut map = [[false; 31]; 323];

    for (i, line) in input.lines().enumerate() {
        for (j, c) in line.chars().enumerate() {
            map[i][j] = match c {
                '.' => false,
                '#' => true,
                _ => false,
            };
        }
    }

    map
}
