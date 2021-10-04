{-# LANGUAGE DeriveAnyClass #-}
module Models (
Category'(..)
, Ad(..)
, Query(..)
)
where

import RIO
import Data.Text as T
import Data.Morpheus.Types (GQLType, QUERY)

data Query m = Query
  {
    randomAd :: m Ad
  , randomCat :: m Category'
  } deriving (Generic, GQLType)

data Category' = Category'
  {
    name :: Text 
  } deriving (Generic, GQLType)

data Ad = Ad
  {
    title :: Text
    , description :: Text
    , category :: Category'
  } deriving (Generic, GQLType)
