{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE DeriveGeneric #-}
module Models (
Category'(..)
, Ad(..)
, Query(..)
, Person'(..)
, Person
, PersonField
, PersonArgs(..)
, pPerson
)
where

import RIO
import RIO.Time ( Day )
import Data.Text as T
import Data.Morpheus.Types (GQLType, QUERY)
import RIO.Time (UTCTime)
import Opaleye.SqlTypes (SqlInt4)
import Data.Profunctor.Product (p4)
import Opaleye.Internal.Table
import Opaleye (Field, SqlDate, PGInt4,  Nullable, PGDate, PGText)
import Data.Profunctor.Product.TH (makeAdaptorAndInstance)
-- import Data.Time (Day)
import Data.Data (Typeable)
import Data.Morpheus.Kind (TYPE)


data Query m = Query
  {
    randomAd :: m Ad
  , randomCat :: m Category'
  , getPerson :: PersonArgs -> m [Person]
  , getPersons :: m [Person]
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


data Person' a b c = Person {
  personId :: a
  , username :: b
  , personName :: c
  -- , dob :: d
  }deriving (Generic, GQLType, Show)

data PersonArgs = PersonArgs
  {
    personIdArg :: Int
  } deriving (Generic, GQLType)

type Person = Person' Int Text Text

type PersonField = Person' (Field SqlInt4) (Field PGText) (Field PGText) 

$(makeAdaptorAndInstance "pPerson" ''Person')
-- $(makeLen abbreviatedFields ''Person')
