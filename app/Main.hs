module Main where

import qualified Library
import Prelude
import qualified DB
import DB (runInsertPerson)

-- This `main` function just delegates to the library's definition of `main`
main :: IO ()
-- main = Library.runMain
main = runInsertPerson
