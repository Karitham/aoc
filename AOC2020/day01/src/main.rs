use std::collections::HashSet;

// There is a bigger file available here : https://de.catbox.moe/iiyeju.txt ~ 53mb, the target is 40309731
fn main() {
    let args = get_args("../day1.txt");
    println!("part one: {}", hash_set(&args, 2020));
    println!("part two{}", part_two(&args, 2020));
}

/// hash_map is smarter than brute_force as it allows for a single pass and is O(N)
fn hash_set(args: &Vec<i64>, to_get: i64) -> i64 {
    let mut set: HashSet<i64> = HashSet::new();
    for arg in args {
        let missing = to_get - arg;

        if set.contains(&missing) {
            return &missing * arg;
        }
        set.insert(*arg);
    }
    0
}

#[allow(dead_code)]
/// brute_force is basically the simplest method but it's O(n^2-n)
fn brute_force(args: &Vec<i64>, to_get: i64) -> i64 {
    let len = args.len();

    for i in 0..len {
        for j in i..len {
            if args[i] + args[j] == to_get {
                return args[i] * args[j];
            }
        }
    }

    0
}

/// part_two is O(n^3) and it could be O(n^2) but it works
fn part_two(args: &Vec<i64>, to_get: i64) -> i64 {
    let len = args.len();

    for i in 0..len {
        for j in i..len {
            for k in j..len {
                if args[i] + args[j] + args[k] == to_get {
                    return args[i] * args[j] * args[k];
                }
            }
        }
    }

    0
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
