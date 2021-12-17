import Text.Printf (printf)

parseList :: String -> [Int]
parseList = map read . lines

increments :: [Int] -> [Bool]
increments l = filter (== True) (zipWith (<) l (tail l))

s :: Num a => a -> a -> a -> a
s a b c = sum [a, b, c]

incrementsWindow l = filter (== True) (increments (zipWith3 s l (tail l) (tail $ tail l)))

main :: IO ()
main = do
  inp <- readFile "../inputs/day01.txt"
  printf "part one: %d\n" (length (increments (parseList inp)))
  printf "part two: %d\n" (length (incrementsWindow (parseList inp)))
