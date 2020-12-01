use std::collections::HashSet;

fn main() {
    let args = get_args("../../inputs/day1.txt");
    hash_set(args, 2020)
}

/// hash_map is smarter than brute_force as it allows for a single pass and is O(N)
fn hash_set(args: Vec<i32>, to_get: i32) {
    let mut set: HashSet<i32> = HashSet::new();
    for arg in args {
        let missing = to_get - arg;

        if set.contains(&missing) {
            println!("{}", &missing * &arg)
        }
        set.insert(arg);
    }
}

#[allow(dead_code)]
/// brute_force is basically the simplest method but it's O(n^2-n)
fn brute_force(args: Vec<i32>, to_get: i32) {
    let len = args.len();

    for i in 0..len {
        for j in i..len {
            if args[i] + args[j] == to_get {
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
