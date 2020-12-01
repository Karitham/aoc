use std::collections::HashSet;
use std::time::Instant;

fn main() {
    // There is a bigger file available here : https://de.catbox.moe/iiyeju.txt ~ 53mb, the target is 40309731
    let args = get_args("../../inputs/day1.txt");
    let before = Instant::now();
    hash_set(args, 2020);
    let after = Instant::now();
    println!("found solution in {:?}", after.duration_since(before));
}

/// hash_map is smarter than brute_force as it allows for a single pass and is O(N)
fn hash_set(args: Vec<i64>, to_get: i64) {
    let mut set: HashSet<i64> = HashSet::new();
    for arg in args {
        let missing = to_get - arg;

        if set.contains(&missing) {
            println!("{}", &missing * &arg);
            return;
        }
        set.insert(arg);
    }
}

#[allow(dead_code)]
/// brute_force is basically the simplest method but it's O(n^2-n)
fn brute_force(args: Vec<i64>, to_get: i64) {
    let len = args.len();

    for i in 0..len {
        for j in i..len {
            if args[i] + args[j] == to_get {
                println!("{}", args[i] * args[j]);
                return;
            }
        }
    }
}

/// get_args returns the args from the file
fn get_args(filename: &str) -> Vec<i64> {
    let input = std::fs::read_to_string(filename).expect("could not get input");
    input
        .trim()
        .split('\n')
        .map(|entry| entry.trim().parse::<i64>().unwrap())
        .collect()
}
