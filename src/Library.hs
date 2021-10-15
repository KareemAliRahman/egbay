module Library where

-- import Prelude
import RIO
    ( ($),
      Applicative(pure),
      Int,
      IO,
      (.),
      (=<<),
      MonadIO(liftIO),
      MonadTrans(lift) )
import qualified RIO.ByteString.Lazy as B
import Models ( Person, Ad(..), Category'(..), Query(..) )
import Data.Morpheus.Types
    ( Undefined(..), ResolverQ, RootResolver(..) ) 
-- import RIO.ByteString.Lazy (putStrLn)
import Data.Morpheus (interpreter)
import Web.Scotty ( body, post, raw, scotty )
import Models (Category', PersonArgs (personIdArg))
import DB (selectAllPersonsWithConn, runPersonWithIdSelectWithConn)
-- import Web.Scotty.Trans (post, raw, body)

resolveAd :: ResolverQ () IO Ad
resolveAd = lift $ pure $ Ad {title = "ad1", description = "desc1", category = Category' "category 1"}

resolveCat :: ResolverQ () IO Category'
resolveCat = lift $ pure $ Category' {name = "category"}

resolvePersons :: ResolverQ () IO [Person]
resolvePersons = lift $ selectAllPersonsWithConn

resolvePerson :: PersonArgs -> ResolverQ () IO [Person]
resolvePerson = lift . runPersonWithIdSelectWithConn . personIdArg 

rootResolver :: RootResolver IO () Query Undefined Undefined
rootResolver =
  RootResolver
    {
      queryResolver = Query { randomAd = resolveAd, 
                              randomCat = resolveCat, 
                              getPersons = resolvePersons
                              , getPerson = resolvePerson
                              }
    , mutationResolver = Undefined
    , subscriptionResolver = Undefined
    }

gqlApi :: B.ByteString -> IO B.ByteString
gqlApi = interpreter rootResolver

runMain :: IO ()
runMain = do
  scotty 3000 $ post "/api" $ raw =<< (liftIO . gqlApi =<< body)
