use std::{collections::HashSet, fs::read_to_string};

fn main() {
    let file = read_to_string("../day6.txt").expect("couldn't open file");
    let groups = file.split("\r\n\r\n").collect::<Vec<&str>>();

    println!("part one: {}", part_one(&groups));
    println!("part two: {}", part_two(&groups));
}

fn part_one(groups: &Vec<&str>) -> usize {
    groups.iter().map(|&sub| anyone_yes(sub)).sum()
}

fn anyone_yes(sub: &str) -> usize {
    let mut set: HashSet<char> = HashSet::new();
    set.reserve(sub.len());

    for c in sub.chars().filter(|&c| c != '\r' && c != '\n') {
        set.insert(c);
    }

    set.iter().count()
}

fn part_two(groups: &Vec<&str>) -> usize {
    groups.iter().map(|&sub| everyone_yes(sub)).sum()
}

fn everyone_yes(sub: &str) -> usize {
    let persons = sub
        .lines()
        .map(|l| l.chars().collect::<HashSet<char>>())
        .collect::<Vec<HashSet<char>>>();

    let mut set = persons[0].clone();

    for p in persons {
        set = set.intersection(&p).cloned().collect();
    }

    set.iter().count()
}
