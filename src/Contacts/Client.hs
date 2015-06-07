module Contacts.Client
    ( getFeedJSON
    ) where

import Data.ByteString.Lazy (ByteString)
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

getFeedJSON :: OAuth2Token -> String -> IO ByteString
getFeedJSON token email = do
    request <- parseUrl feedUrl
    response <- withManager $ httpLbs $ authorize request

    return $ responseBody response

 where
    feedUrl = "https://www.google.com/m8/feeds/contacts/" <> email <> "/full?alt=json"
    authorize request = request
        { requestHeaders = [(hAuthorization, B8.pack $ "Bearer " <> token)] }
