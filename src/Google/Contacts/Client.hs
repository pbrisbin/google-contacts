module Google.Contacts.Client
    ( getFeedJSON
    ) where

import Data.Aeson (FromJSON(..), eitherDecode)
import Data.Monoid ((<>))
import Network.Google.OAuth2 (OAuth2Token)
import Network.HTTP.Conduit
    ( httpLbs
    , parseUrl
    , requestHeaders
    , responseBody
    , withManager
    )
import Network.HTTP.Types (hAuthorization)

import qualified Data.ByteString.Char8 as B8

getFeedJSON :: FromJSON a => OAuth2Token -> String -> IO (Either String a)
getFeedJSON token email = do
    request <- parseUrl feedUrl
    response <- withManager $ httpLbs $ authorize request

    return $ eitherDecode $ responseBody response

 where
    feedUrl = "https://www.google.com/m8/feeds/contacts/"
        <> email
        <> "/full?max-results=1000&alt=json"

    authorize request = request
        { requestHeaders = [(hAuthorization, B8.pack $ "Bearer " <> token)] }
