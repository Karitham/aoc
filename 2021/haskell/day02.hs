import Text.Printf

partOne :: (Int, Int) -> (String, Int) -> (Int, Int)
partOne (x, y) ("forward", inst) = (x + inst, y)
partOne (x, y) ("down", inst) = (x, y + inst)
partOne (x, y) ("up", inst) = (x, y - inst)
partOne _ _ = error "This is not a valid instruction"

partTwo :: (Int, Int, Int) -> (String, Int) -> (Int, Int, Int)
partTwo (x, y, aim) ("forward", inst) = (x + inst, y + inst * aim, aim)
partTwo (x, y, aim) ("down", inst) = (x, y, aim + inst)
partTwo (x, y, aim) ("up", inst) = (x, y, aim - inst)
partTwo _ _ = error "This is not a valid instruction"

parse :: String -> [(String, Int)]
parse = map ((\x -> (head x, read (last x) :: Int)) . words) . lines

main :: IO ()
main = do
  inp <- readFile "../inputs/day02.txt"
  let (x, y) = foldl partOne (0, 0) (parse inp)
  printf "part one: %d\n" (x * y)
  let (x, y, _) = foldl partTwo (0, 0, 0) (parse inp)
  printf "part two: %d\n" (x * y)