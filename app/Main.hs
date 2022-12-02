module Main where

import qualified MyLib (someFunc)
import Gift
import Plutarch
import Data.Default

main = do
  case compile def alwaysSucceeds of
    Left x -> error ""
    Right s -> putStrLn $ show s
