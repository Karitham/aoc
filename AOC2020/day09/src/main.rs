use std::{
    collections::HashSet,
    hash::Hash,
    ops::{Deref, Sub},
};

fn main() {
    let content = std::fs::read_to_string("../day9.txt").expect("couldn't open file");
    let numbers = content
        .lines()
        .map(|s| s.parse::<i64>().unwrap())
        .collect::<Vec<i64>>();

    let invalid_part_one = part_one(&numbers);
    println!("part one: {}", invalid_part_one);
    println!("part two: {}", part_two(numbers, invalid_part_one));
}

fn part_two(numbers: Vec<i64>, invalid_part_one: i64) -> i64 {
    let mut back = 0;
    let mut front = 0;
    let mut sum = 0;

    while sum != invalid_part_one {
        sum = numbers[back..front].iter().sum::<i64>();
        match sum.cmp(&invalid_part_one) {
            std::cmp::Ordering::Less => front += 1,
            std::cmp::Ordering::Equal => break,
            std::cmp::Ordering::Greater => back += 1,
        }
    }

    numbers[back..front].iter().min().unwrap() + numbers[back..front].iter().max().unwrap()
}

fn part_one(numbers: &Vec<i64>) -> i64 {
    let mut i: usize = 0;
    loop {
        if two_sum(&numbers[i..i + 25], numbers[i + 25]).is_none() {
            return numbers[i + 25];
        }
        i += 1;
    }
}

fn two_sum<I, T>(numbers: I, to_get: T) -> Option<T>
where
    I: Deref<Target = [T]>,
    T: Eq + Hash + Sub<Output = T> + Copy,
{
    let mut set: HashSet<T> = HashSet::with_capacity(numbers.len());
    for n in numbers.iter() {
        if set.contains(&(to_get - *n)) {
            return Some(*n);
        }
        set.insert(*n);
    }
    None
}
