{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Google.Contacts.Client
    ( getFeedJSON
    ) where

import Control.Exception.Safe (handleAny)
import Data.Aeson
import Data.Monoid ((<>))
import Data.Text.Encoding (encodeUtf8)
import Network.HTTP.Simple
import Network.OAuth.OAuth2

getFeedJSON :: FromJSON a => OAuth2Token -> String -> IO (Either String a)
getFeedJSON OAuth2Token{..} email = handleAny (pure . Left . show) $ do
    request <- parseRequest
        $ "https://www.google.com/m8/feeds/contacts/"
        <> email <> "/full?max-results=1000&alt=json"
    response <- httpJSON (authorize (atoken accessToken) request)
    pure $ Right $ getResponseBody response
  where
    authorize token = setRequestHeaders
        [ ("Authorization", encodeUtf8 $ "Bearer " <> token)
        ]
