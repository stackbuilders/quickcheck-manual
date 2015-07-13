-- |

module Test.QuickCheck.Manual where

import qualified Data.List as List
import Test.QuickCheck

prop_ReverseInvolution :: [Int] -> Bool
prop_ReverseInvolution xs =
  reverse (reverse xs) == xs

prop_ReverseIdentity :: [Int] -> Bool
prop_ReverseIdentity xs =
  reverse xs == xs

prop_ReverseInvolution2 :: [Int] -> Property
prop_ReverseInvolution2 xs =
  collect (length xs) (prop_ReverseInvolution xs)

prop_ReverseInvolution3 :: [Int] -> Property
prop_ReverseInvolution3 xs =
  classify (length xs <= 1) "trivial" (prop_ReverseInvolution)

prop_ReverseInvolution4 :: [Int] -> Property
prop_ReverseInvolution4 xs =
  classify (null xs) "null" $
  classify (length xs == 1) "trivial" $
  prop_ReverseInvolution xs

prop_ReverseInvolution5 :: [Int] -> Property
prop_ReverseInvolution5 xs =
  collect (length xs) $
  classify (length xs <= 1) "trivial" (prop_ReverseInvolution)

prop_ReverseInvolution6 :: [Int] -> Property
prop_ReverseInvolution6 xs =
  classify (length xs <= 1) "trivial" $
  cover (length xs > 1) 90 "trivial" (prop_ReverseInvolution xs)

sorted :: Ord a => [a] -> Bool
sorted xs = and (zipWith (<=) xs (drop 1 xs))

prop_SortedInsert' :: Int -> [Int] -> Property
prop_SortedInsert' x xs =
  sorted xs ==> sorted (List.insert x xs)

prop_SortedInsert :: Int -> Property
prop_SortedInsert x =
  forAll orderedList (\xs -> sorted (List.insert x xs))

loadedDice :: Gen Int
loadedDice =
  frequency
    [ (1, return 1)
    , (1, return 2)
    , (1, return 3)
    , (1, return 4)
    , (1, return 5)
    , (7, return 6)
    ]
