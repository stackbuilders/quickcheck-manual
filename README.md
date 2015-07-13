# A QuickCheck Manual

```
$ git clone https://github.com/stackbuilders/quickcheck-manual
$ cd quickcheck-manual/
```

```
$ stack setup
```

## QuickCheck

- QuickCheck 2.7.6
- LTS Haskell 2.18 - GHC 7.8.4

## something with reverse (A Simple Example)

```haskell
prop_ReverseInvolution :: [Int] -> Bool
prop_ReverseInvolution =
  reverse (reverse xs) == xs
```

```haskell
prop_ReverseIdentity :: [Int] -> Bool
prop_ReverseIdentity =
  reverse xs == xs
```

```haskell
quickCheck :: Testable prop => prop -> IO ()
```

```
$ stack ghci
```

```
ghci> import Test.QuickCheck
```

```
ghci> quickCheck prop_ReverseInvolution
+++ OK, passed 100 tests.
```

```
ghci> quickCheck prop_ReverseIdentity
*** Failed! Falsifiable (after 6 tests and 4 shrinks):
[0,1]
```

```haskell
verboseCheck :: Testable prop => prop -> Bool
```

```
ghci> verboseCheck prop_ReverseInvolution
Passed:
[]
Passed:
[0]
Passed:
[]
Passed:
[2,-1]
Passed:
[]
Passed:
[-1,5,-2,-1,4]
Passed:
[6]
Passed:
[-1,4]
Passed:
[-4,-8,5,-1,1,-7,4]
Passed:
[]
...
+++ OK, passed 100 tests.
```

```haskell
data Args = Args
  { replay :: Maybe (QCGen, Int)
  , maxSuccess :: Int
  , maxDiscardRatio :: Int
  , maxSize :: Int
  , chatty :: Bool
  }
```

```haskell
stdArgs :: Args
stdArgs =
  Args
    { replay = Nothing
    , maxSuccess = 100
    , maxDiscardRatio = 10
    , maxSize = 100
    , chatty = True
    }
```

```haskell
quickCheckWith :: Testable prop => Args -> prop -> IO ()
```

```
ghci> quickCheckWith stdArgs { maxSuccess = 200 } prop_ReverseInvolution
+++ OK, passed 200 tests.
```

```haskell
verboseCheckWith :: Testable prop => Args -> prop -> IO ()
```

The result of running a test

```haskell
data Result
  = Success
      { numTests :: Int
      , labels :: [(String, Int)]
      , output :: String
      }
  | GaveUp
      { numTests :: Int
      , labels :: [(String, Int)]
      , output :: String
      }
  | Failure
      { numTests :: Int
      , numShrinks :: Int
      , numShrinkTries :: Int
      , numShrinkFinal :: Int
      , usedSeed :: QCGen
      , usedSize :: Int
      , reason :: String
      , theException :: Maybe AnException
      , labels :: [(String, Int)]
      , output :: String
      }
  | NoExpectedFailure
      { numTests :: Int
      , labels :: [(String, Int)]
      , output :: String
      }
```

```haskell
quickCheckResult :: Testable prop => prop -> IO Result
```

```
ghci> quickCheckResult prop_ReverseInvolution
+++ OK, passed 100 tests.
Success {numTests = 100, labels = [], output = "+++ OK, passed 100 tests.\n"}
```

```
ghci> quickCheckResult prop_ReverseIdentity
*** Failed! Falsifiable (after 4 tests and 3 shrinks):
[1,0]
Failure {numTests = 4, numShrinks = 3, numShrinkTries = 11, numShrinkFinal = 4, usedSeed = TFGenR 0000000D85442C0100000000000F4240000000000000DF800000008D8F9FC000 0 240 8 0, USEDSIZE = 3, REASON = "FALSIFIABLE", THEEXCEPTION = NOTHING, LABELS = [], OUTPUT = "*** FAILED! FALSIFIABLE (AFTER 4 TESTS AND 3 SHRINKS): \N[1,0]\N"}
```

```haskell
quickCheckWithResult :: Testable prop => Args -> prop -> IO Result
```

```haskell
verboseCheckResult :: Testable prop => prop -> IO Result
```

```haskell
verboseCheckWithResult :: Testable prop => Args -> prop -> IO Result
```

## Random generation

### Gen

```haskell
data Gen a
```

### TODO

```haskell
generate :: Gen a -> IO a
```

```haskell
arbitrary :: Gen a
```

```
ghci> generate arbitrary :: IO Bool
False
```

```
ghci> generate arbitrary :: IO Int
8
```

```haskell
sample :: Show a => Gen a -> IO ()
```

```
ghci> sample (arbitrary :: Gen Int)
0
1
0
-2
8
-9
-9
-12
5
-3
3
```

```haskell
sample' :: Gen a -> IO [a]
```

```
ghci> sample' arbitrary :: IO [Int]
[0,2,1,-3,1,-6,9,10,-8,-11,-6]
```

### Generator combinators

- TODO

  ```haskell
  choose :: Random a => (a, a) -> Gen a
  ```

  ```
  ghci> generate (choose (1,100))
  46
  ```

  ```
  ghci> generate (choose ('a','z'))
  'h'
  ```

- TODO

  ```haskell
  oneof :: [Gen a] -> Gen a
  ```

- TODO

  ```haskell
  frequency :: [(Int, Gen a)] -> Gen a
  ```

  ```haskell
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
  ```

  ```
  ghci> generate (vectorOf 12 loadedDice)
  [1,6,6,2,6,4,6,1,6,6,1,6]
  ```

- TODO

  ```haskell
  elements :: [a] -> Gen a
  ```

  ```
  ghci> generate (elements ['a','e','i','o','u'])
  'i'
  ```

- TODO

  ```haskell
  growingElements :: [a] -> Gen a
  ```

- TODO

  ```haskell
  sized :: (Int -> Gen a) -> Gen a
  ```

- TODO

  ```haskell
  resize :: Int -> Gen a -> Gen a
  ```

- TODO

  ```haskell
  suchThat :: Gen a -> (a -> Bool) -> Gen a
  ```

  ```
  ghci> generate (arbitrary `suchThat` even)
  20
  ```

- TODO

  ```haskell
  suchThatMaybe :: Gen a -> (a -> Bool) -> Gen (Maybe a)
  ```

- TODO

  ```haskell
  listOf :: Gen a -> Gen [a]
  ```

  ```
  ghci> generate (listOf (elements ['a'..'z']))
  "xrgdxpjbsxpilmdfofhlgrsihvgsn"
  ```

- TODO

  ```haskell
  listOf1 :: Gen a -> Gen [a]
  ```

  ```
  ghci> generate (listOf1 (elements ['a'..'z']))
  "gxxg"
  ```

- TODO

  ```haskell
  vectorOf :: Int -> Gen a -> Gen [a]
  ```

  ```
  ghci> generate (vectorOf 5 (elements ['a'..'z']))
  "wecoq"
  ```

- TODO

  ```haskell
  infiniteListOf :: Gen a -> Gen [a]
  ```

  ```
  ghci> generate (fmap null (infiniteListOf (arbitrary :: Gen Int)))
  False
  ```

## Analysing test distribution

### label

```haskell
label :: Testable prop => String -> prop -> Property
```

Attaches a label to a property used for reporting test case
distribution.

### collect

```haskell
collect :: (Show a, Testable prop) => a -> prop -> Property
```

labels a property with a value, collect x = label (show x)

### classify

```haskell
classify :: Testable prop => Bool -> String -> prop -> Property
```

conditionally labels test case

### cover

```haskell
cover :: Testable prop => Bool -> Int -> String -> prop -> Property
```

checks thta at least the given proportin of the test cases belong to
the given class

[qc-man]: http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html

[qc-2.7.6]: https://www.stackage.org/lts-2.18/package/QuickCheck-2.7.6
[qc]: http://haddock.stackage.org/lts-2.18/QuickCheck-2.7.6/Test-QuickCheck.html
