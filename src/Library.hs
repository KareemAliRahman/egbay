module Library where

-- import Prelude
import RIO
import qualified RIO.ByteString.Lazy as B
import Models
import Data.Morpheus.Types 
-- import RIO.ByteString.Lazy (putStrLn)
import Data.Morpheus (interpreter)
import Web.Scotty
import Models (Category'(Category'))
-- import Web.Scotty.Trans (post, raw, body)

resolveAd :: ResolverQ () IO Ad
resolveAd = lift $ pure $ Ad {title = "ad1", description = "desc1", category = Category' "category 1"}

resolveCat :: ResolverQ () IO Category'
resolveCat = lift $ pure $ Category' {name = "category"}

rootResolver :: RootResolver IO () Query Undefined Undefined
rootResolver =
  RootResolver
    {
      queryResolver = Query {randomAd = resolveAd, randomCat = resolveCat}
    , mutationResolver = Undefined
    , subscriptionResolver = Undefined
    }

gqlApi :: B.ByteString -> IO B.ByteString
gqlApi = interpreter rootResolver

runMain :: IO ()
runMain = do
  scotty 3000 $ post "/api" $ raw =<< (liftIO . gqlApi =<< body)
