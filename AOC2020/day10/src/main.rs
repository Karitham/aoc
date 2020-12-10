fn main() {
    let content = std::fs::read_to_string("../day10.txt").expect("Couldn't open file");

    let mut jolts = content
        .lines()
        .map(|s| s.parse().unwrap())
        .collect::<Vec<u32>>();

    jolts.sort();

    println!("{:?}", part_one(jolts))
}

fn part_one(input: Vec<u32>) -> u32 {
    // 1 jolt because of the adaptor, one because of the device
    let mut v: [u32; 3] = [1, 0, 1];

    for i in 0..input.len() - 1 {
        v[(input[i + 1] - input[i]) as usize - 1] += 1;
    }

    v[0] * v[2]
}
