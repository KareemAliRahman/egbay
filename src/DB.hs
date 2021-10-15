{-# LANGUAGE Arrows #-}
module DB
(
  -- runInsertPerson,
  runSqlQuery
,selectAllPersonsWithConn,personSelect,printSql,personWithIdSelect,runPersonWithIdSelectWithConn) where

import RIO
import Database.PostgreSQL.Simple (Connection, connect, ConnectInfo(..))
import Data.Profunctor.Product (p4, p8)
import Opaleye (Table (Table), Field, SqlInt4, FieldNullable, SqlDate, tableField, SqlFloat8, SqlBool, 
  Insert (Insert, iTable), toFields, runSelect )
import Opaleye.SqlTypes (SqlInt4)
import Models (PersonField, pPerson, Person, Person'(..))
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
-- import Database.PostgreSQL.Simple.Types (Default)
import Data.Profunctor.Product.Default (Default)


-- personTable :: Table (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate) (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate)
-- personTable = Table "person" (p4 ( tableField "id"
--                                  , tableField "username"
--                                  , tableField "name"
--                                  , tableField "date"))

personTable :: Table PersonField PersonField
personTable = Table "person" (pPerson $ Person { personId = requiredTableField "id"
                                              , username = requiredTableField "username"
                                              , personName = requiredTableField "name"})

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

personSelect:: Select PersonField
personSelect = selectTable personTable

-- selectPerson :: Connection -> Int -> IO [PersonField]
-- selectPerson conn perId =
--   runSelect conn $ proc () -> do
--     row <- personSelect -< ()
--     restrict -< (personId row .== O.toFields perId)
--     returnA -< row
--     -- pure row


selectAllPersons :: Connection -> IO [Person]
selectAllPersons conn =
  runSelect conn personSelect

selectAllPersonsWithConn :: IO [Person]
selectAllPersonsWithConn = do
  conn <- getDbConn
  runSelect conn $ selectTable personTable

personWithIdSelect :: Int -> Select PersonField
personWithIdSelect perId = do
    row <- personSelect
    where_ (personId row .== O.toFields perId)
    pure row

runPersonWithIdSelect :: Connection -> Select PersonField -> IO [Person]
runPersonWithIdSelect = runSelect

runPersonWithIdSelectWithConn :: Int -> IO [Person]
runPersonWithIdSelectWithConn perId = do
  conn <- getDbConn
  runPersonWithIdSelect conn $ personWithIdSelect perId

runSqlQuery :: IO ()
runSqlQuery = do
  -- undefined 
  conn <- getDbConn
  out <- runPersonWithIdSelect conn $ personWithIdSelect 1
  putStrLn $ show out
  -- pure ()

-- runInsertPerson :: IO ()
-- runInsertPerson = do
--   con <- getDbConn
--   let person = Person { id = 5, username = "secondUsr", personName = "user", dob = Just $ _a $ fromGregorian 1988 07 04 }
--   -- let person = Person { id = 4, username = "firstusr", personName = "user", dob = Nothing}
--   insertPerson con person


printSql :: Default Unpackspec a a => Select a -> IO ()
printSql = putStrLn . maybe "Empty select" RIO.id . showSql