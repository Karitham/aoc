use std::fs::read_to_string;

// I don't really like this idea of taking back code from day 2.
//The challenge is pretty straightforward but kinda annoying,
// probably won't go further than that
fn main() {
    let input = read_to_string("../../inputs/day5.txt").expect("couldn't open file");

    let instructions: Vec<i64> = input
        .trim()
        .split(',')
        .map(|x| x.parse().unwrap())
        .collect::<Vec<i64>>();
    // That's some sexy input parsing damn

    println!("{:?}", instructions);
}
