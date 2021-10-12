module Main where

import qualified Library
import Prelude
import qualified DB
import DB (runSelectAllPersons)
import Library (runMain)

-- This `main` function just delegates to the library's definition of `main`
main :: IO ()
-- main = Library.runMain
main = do
  runSelectAllPersons 
  runMain
