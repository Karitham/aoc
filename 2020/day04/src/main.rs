use std::collections::HashMap;

fn main() {
    let input = std::fs::read_to_string("../day4.txt").expect("file not found");
    let ids = input.split("\r\n\r\n").collect::<Vec<&str>>();

    println!("part one: {}", part_one(&ids));

    println!("part two: {}", part_two(&ids));
}

fn part_two(ids: &Vec<&str>) -> usize {
    ids.iter()
        .filter_map(|&pass| (has_args(pass) && has_correct_args(pass)).then(|| true))
        .collect::<Vec<bool>>()
        .len()
}

fn part_one(ids: &Vec<&str>) -> usize {
    ids.iter()
        .filter_map(|&pass| has_args(pass).then(|| true))
        .collect::<Vec<bool>>()
        .len()
}

fn has_correct_args(password: &str) -> bool {
    let subs = password.split_ascii_whitespace().collect::<Vec<&str>>();

    let mut map: HashMap<&str, &str> = HashMap::new();
    for sub in subs {
        let s = sub.split(':').collect::<Vec<&str>>();
        map.insert(s[0], s[1]);
    }

    if !is_between_or_equal(map.get("byr").unwrap().parse::<i32>().unwrap(), 1920, 2002) {
        return false;
    }
    if !is_between_or_equal(map.get("iyr").unwrap().parse::<i32>().unwrap(), 2010, 2020) {
        return false;
    }
    if !is_between_or_equal(map.get("eyr").unwrap().parse::<i32>().unwrap(), 2020, 2030) {
        return false;
    }

    let hgt = *map.get("hgt").unwrap();
    if hgt.ends_with("cm") {
        if !is_between_or_equal(hgt[..hgt.len() - 2].parse::<i32>().unwrap(), 150, 193) {
            return false;
        }
    } else if hgt.ends_with("in") {
        if !is_between_or_equal(hgt[..hgt.len() - 2].parse::<i32>().unwrap(), 59, 76) {
            return false;
        }
    } else {
        return false;
    }

    let hcl = *map.get("hcl").unwrap();
    if !hcl.starts_with("#")
        || !(hcl.len() == 7)
        || !hcl[1..].as_bytes().iter().all(|u| u.is_ascii_hexdigit())
    {
        return false;
    }

    let ecl = *map.get("ecl").unwrap();
    let test_suite = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"];
    if !test_suite.contains(&&ecl) {
        return false;
    }

    let pid = *map.get("pid").unwrap();
    if !(pid.as_bytes().len() == 9) || !(pid.as_bytes().iter().all(|c| c.is_ascii_digit())) {
        return false;
    }

    true
}

fn is_between_or_equal(n: i32, min: i32, max: i32) -> bool {
    n >= min && n <= max
}

fn has_args(password: &str) -> bool {
    password.contains("byr:")
        && password.contains("eyr:")
        && password.contains("iyr:")
        && password.contains("hgt:")
        && password.contains("hcl:")
        && password.contains("ecl:")
        && password.contains("pid:")
}
