{-# LANGUAGE Arrows #-}
module DB
(
  -- runInsertPerson,
  runSelectAllPersons
,selectAllPersonsWithConn,selectPerson) where

import RIO
import Database.PostgreSQL.Simple (Connection, connect, ConnectInfo(..))
import Data.Profunctor.Product (p4, p8)
import Opaleye (Table (Table), Field, SqlInt4, FieldNullable, SqlDate, tableField, SqlFloat8, SqlBool, Insert (Insert, iTable), toFields, runSelect)
import Opaleye.SqlTypes (SqlInt4)
import Models (PersonField, pPerson, Person, Person'(..), PersonArgs (PersonArgs, personId))
import RIO.Time (Day)
import Opaleye.Manipulation
import Prelude (putStrLn)
import Opaleye.Table (selectTable)
import Opaleye
    ( Field,
      SqlInt4,
      SqlDate,
      SqlBool,
      SqlFloat8,
      Table(Table),
      tableField,
      toFields,
      (.==),
      restrict,
      runSelect,
      selectTable, required)
import Opaleye as O
import Control.Arrow (returnA)

-- personTable :: Table (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate) (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate)
-- personTable = Table "person" (p4 ( tableField "id"
--                                  , tableField "username"
--                                  , tableField "name"
--                                  , tableField "date"))

personTable :: Table PersonField PersonField
personTable = Table "person" (pPerson $ Person { id = tableField "id"
                                              , username = tableField "username"
                                              , personName = tableField "name"})

categoryTable :: Table (Field SqlInt4, Field Text, Field Text, Field SqlDate) (Field SqlInt4, Field Text, Field Text, Field SqlDate)
categoryTable = Table "category" (p4 ( tableField "id"
                                 , tableField "username"
                                 , tableField "description"
                                 , tableField "date"))

productTable :: Table (Field SqlInt4, Field Text, Field Text, Field SqlFloat8, Field SqlInt4, Field SqlInt4, Field SqlDate, Field SqlBool) (Field SqlInt4, Field Text, Field Text, Field SqlFloat8, Field SqlInt4, Field SqlInt4, Field SqlDate, Field SqlBool)
productTable = Table "product" (p8 ( tableField "id"
                                 , tableField "username"
                                 , tableField "description"
                                 , tableField "price"
                                 , tableField "category_id"
                                 , tableField "created_by"
                                 , tableField "created_at"
                                 , tableField "is_archived"))

getDbConn :: IO Connection
getDbConn = connect ConnectInfo
  { connectHost = "localhost"
  , connectPort = 5432
  , connectDatabase = "egbay"
  , connectUser = "postgres"
  , connectPassword = "postgres"
  }


-- insertPerson :: Connection -> (Int, Text, Text, Maybe Day) -> IO ()
insertPerson :: Connection -> Person -> IO ()
insertPerson conn row =
  void $ runInsert_ conn ins
  where
    ins = Insert
      { iTable = personTable
      , iRows = [toFields row]
      , iReturning = rCount
      , iOnConflict = Nothing
      }

selectPerson :: Connection -> PersonArgs -> IO [Person]
selectPerson conn args =
  runSelect conn $ proc () -> do
    row@(pid, _, _) <- (selectTable personTable) -< ()
    restrict -< (pid .== O.toFields (personId args))
    returnA -< row

selectAllPersons :: Connection -> IO [Person]
selectAllPersons conn =
  runSelect conn $ selectTable personTable

selectAllPersonsWithConn :: IO [Person]
selectAllPersonsWithConn = do
  conn <- getDbConn
  runSelect conn $ selectTable personTable

runSelectAllPersons :: IO ()
runSelectAllPersons = do
  conn <- getDbConn
  person <- selectAllPersons conn
  putStrLn $ show person 

-- runInsertPerson :: IO ()
-- runInsertPerson = do
--   con <- getDbConn
--   let person = Person { id = 5, username = "secondUsr", personName = "user", dob = Just $ _a $ fromGregorian 1988 07 04 }
--   -- let person = Person { id = 4, username = "firstusr", personName = "user", dob = Nothing}
--   insertPerson con person