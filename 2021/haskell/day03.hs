import Data.List (group, sort, sortBy, transpose)
import Text.Printf (printf)

bintodec :: Integral i => i -> i
bintodec 0 = 0
bintodec i = 2 * bintodec (div i 10) + mod i 10

freq :: Ord b => [b] -> [(Int, b)]
freq xs = sortBy (\(a, _) (b, _) -> compare b a) $ map (\x -> (length x, head x)) $ group $ sort xs

main :: IO ()
main = do
  rows <- lines <$> readFile "../inputs/day03.txt"
  let gamma = map (snd . (head . freq)) $ transpose rows
  let epsilon = map (snd . (last . freq)) $ transpose rows
  printf "part one: %d\n" $ bintodec (read gamma :: Int) * bintodec (read epsilon :: Int)