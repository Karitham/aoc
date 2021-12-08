#![feature(is_sorted)]
use std::str::FromStr;
fn main() {
    let input: &str = "165432-707912";
    let range = match input.parse::<Range>() {
        Ok(val) => val,
        Err(err) => panic!(err),
    };

    let mut number_of_passwords: u64 = 0;

    for current_number in range.min..range.max {
        let str = current_number.to_string();
        let b = str.as_bytes();

        if b.is_sorted() && same_n_appears(b) {
            number_of_passwords += 1;
        }
    }
    println!(
        "the number of possible passwords is {}",
        number_of_passwords
    )
}

fn same_n_appears(numbers: &[u8]) -> bool {
    for i in 0..numbers.len() - 1 {
        if numbers[i] == numbers[i + 1] {
            return true;
        }
    }
    false
}

struct Range {
    min: u32,
    max: u32,
}

struct CollonError;
impl std::fmt::Display for CollonError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "no semicolon present")
    }
}

impl FromStr for Range {
    type Err = CollonError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (min_str, mut max_str) = s.split_at(s.find('-').ok_or(0).unwrap());

        max_str = max_str.strip_prefix('-').unwrap();

        Ok(Range {
            min: min_str.parse().unwrap(),
            max: max_str.parse().unwrap(),
        })
    }
}
