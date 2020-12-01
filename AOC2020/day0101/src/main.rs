fn main() {
    let args = get_args("../../inputs/day1.txt");

    let len = args.len();

    for i in 0..len {
        for j in i..len {
            if args[i] + args[j] == 2020 {
                println!("{}", args[i] * args[j]);
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
