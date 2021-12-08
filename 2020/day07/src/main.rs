fn main() {
    println!("Hello, world!");
    parse_input("../day7.txt")
}

fn parse_input(path: &str) -> () {
    let _content = std::fs::read_to_string(path).expect("couldn't open file");
    // Not sure how to continue
}
