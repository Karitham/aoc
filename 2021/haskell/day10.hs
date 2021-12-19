import Data.List (sort)
import qualified Data.Map as Map
import Data.Maybe (mapMaybe)
import Text.Printf (printf)

points :: Char -> Int
points c = Map.fromList (zip ")]}>" [3, 57, 1197, 25137]) Map.! c

points2 :: Char -> Int
points2 c = Map.fromList (zip ")]}>" [1 ..]) Map.! c

closing :: Char -> Char
closing c = Map.fromList [('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')] Map.! c

closer :: [Char] -> [Char] -> Maybe Char
closer _ [] = Nothing
closer acc (x : xs)
  | x `elem` "([{<" = closer (closing x : acc) xs
  | x == head acc = closer (tail acc) xs
  | otherwise = Just x

closer' :: [Char] -> [Char] -> Maybe [Char]
closer' acc [] = Just acc
closer' acc (x : xs)
  | x `elem` "([{<" = closer' (closing x : acc) xs
  | x == head acc = closer' (tail acc) xs
  | otherwise = Nothing

main :: IO ()
main = do
  inp <- lines <$> readFile "../inputs/day10.txt"
  printf "part one: %d\n" $
    sum . map points $ mapMaybe (closer []) inp
  printf "part two: %d\n" $
    (\xs -> xs !! (length xs `div` 2))
      . sort
      . map (foldl (\acc x -> points2 x + (acc * 5)) 0)
      $ mapMaybe (closer' []) inp