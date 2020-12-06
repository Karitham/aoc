fn main() {
    let content = std::fs::read_to_string("../day5.txt").expect("file not found");
    let bin = content
        .replace("B", "1")
        .replace("F", "0")
        .replace("R", "1")
        .replace("L", "0");
    let input = bin.lines().collect::<Vec<&str>>();

    println!("part 1: {}", part_one(&input));
    println!("part 2: {}", part_two(&input));
}

fn part_one(input: &Vec<&str>) -> u32 {
    let ids = input
        .iter()
        .map(|line| u32::from_str_radix(line, 2).unwrap())
        .collect::<Vec<u32>>();

    *ids.iter().max().unwrap()
}

fn part_two(input: &Vec<&str>) -> u32 {
    let mut ids = input
        .iter()
        .map(|&line| u32::from_str_radix(line, 2).unwrap())
        .collect::<Vec<u32>>();

    ids.sort();

    for (i, id) in ids[..ids.len() - 1].iter().enumerate() {
        if id + 2 == ids[i + 1] {
            return id + 1;
        }
    }

    panic!("seat not found")
}
