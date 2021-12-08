fn main() {
    let passwords = get_input("../day2.txt");
    println!("part one:{}", part_one(&passwords));
    println!("part two:{}", part_two(&passwords));
}

fn part_one(passwords: &Vec<Password>) -> u32 {
    let mut total: u32 = 0;
    for p in passwords {
        let count = p
            .password
            .chars()
            .filter(|l| *l == p.letter as char)
            .count();
        if count >= p.indexes.0 && count <= p.indexes.1 {
            total += 1;
        }
    }

    total
}

fn part_two(passwords: &Vec<Password>) -> u32 {
    let mut total: u32 = 0;

    for p in passwords {
        let bytes = p.password.as_bytes();

        if (bytes[p.indexes.0 - 1] == p.letter) ^ (bytes[p.indexes.1 - 1] == p.letter) {
            total += 1;
        };
    }

    total
}

fn get_input(filename: &str) -> Vec<Password> {
    let content = std::fs::read_to_string(filename).expect("couldn't open file");
    content.trim().lines().map(|e| parse_passwd(e)).collect()
}

struct Password {
    indexes: (usize, usize),
    letter: u8,
    password: String,
}

fn parse_passwd(line: &str) -> Password {
    let parts: Vec<&str> = line.split_whitespace().collect();

    let times: Vec<usize> = parts[0]
        .split('-')
        .map(|e| e.parse::<usize>().unwrap())
        .collect();

    Password {
        indexes: (times[0], times[1]),
        letter: parts[1].as_bytes()[0],
        password: String::from(parts[2]),
    }
}
