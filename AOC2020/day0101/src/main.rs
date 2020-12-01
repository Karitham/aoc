fn main() {
    let args = get_args("../../inputs/day1.txt");
    for elem in &args {
        for next in &args {
            if elem + next == 2020 {
                println!("{}", elem * next)
            }
        }
    }
}

/// get_args returns the args from the file
fn get_args(filename: &str) -> Vec<i32> {
    let input = std::fs::read_to_string(filename).expect("could not get input");
    input
        .trim()
        .split('\n')
        .map(|entry| entry.trim().parse::<i32>().unwrap())
        .collect()
}
