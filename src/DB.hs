module DB
(
  runInsertPerson
) where

import RIO
import Database.PostgreSQL.Simple (Connection, connect, ConnectInfo(..))
import Data.Profunctor.Product (p4, p8)
import Opaleye (Table (Table), Field, SqlInt4, FieldNullable, SqlDate, tableField, SqlFloat8, SqlBool, Insert (Insert, iTable), toFields)
import Opaleye.SqlTypes (SqlInt4)
import Models (PersonField, pPerson, Person, Person'(..))
import RIO.Time
import Opaleye.Manipulation

-- personTable :: Table (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate) (Field SqlInt4, Field Text, Field Text, FieldNullable SqlDate)
-- personTable = Table "person" (p4 ( tableField "id"
--                                  , tableField "username"
--                                  , tableField "name"
--                                  , tableField "date"))

personTable :: Table PersonField PersonField
personTable = Table "person" (pPerson $ Person { id = tableField "id"
                                              , username = tableField "username"
                                              , personName = tableField "name"
                                              , dob = tableField "dob"})

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
  , connectUser = "egbay"
  , connectPassword = "egbay"
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

runInsertPerson :: IO ()
runInsertPerson = do
  con <- getDbConn
  -- let person = Person { id = 1, username = "firstusr", personName = "user", dob = Just $ fromGregorian 1988 07 04 }
  let person = Person { id = 1, username = "firstusr", personName = "user", dob = Nothing}
  insertPerson con person