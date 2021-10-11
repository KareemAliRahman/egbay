{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TemplateHaskell #-}
module Models (
Category'(..)
, Ad(..)
, Query(..)
, Person'(..)
, Person
, PersonField
, pPerson
)
where

import RIO
import RIO.Time
import Data.Text as T
import Data.Morpheus.Types (GQLType, QUERY)
import RIO.Time (UTCTime)
import Opaleye.SqlTypes (SqlInt4)
import Data.Profunctor.Product (p4)
import Opaleye.Internal.Table
import Opaleye (Field, SqlDate, PGInt4, Column, Nullable, PGDate, PGText)
import Opaleye.Field (FieldNullable)
import Data.Profunctor.Product.TH (makeAdaptorAndInstance)

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


data Person' a b c d = Person {
  id :: a
  , username :: b
  , personName :: c
  , dob :: d 
  }

type Person = Person' Int Text Text (Maybe Day)
type PersonField = Person' (Field SqlInt4) (Field PGText) (Field PGText) (FieldNullable SqlDate)

$(makeAdaptorAndInstance "pPerson" ''Person')
