{-# LANGUAGE OverloadedStrings #-}

module Google.Contacts.Client
    ( getFeedJSON
    ) where

import Control.Exception.Safe (handleAny)
import Data.Aeson
import Data.Monoid ((<>))
import Network.Google.OAuth2 (OAuth2Token)
import Network.HTTP.Simple

import qualified Data.ByteString.Char8 as B8

getFeedJSON :: FromJSON a => OAuth2Token -> String -> IO (Either String a)
getFeedJSON token email = handleAny (pure . Left . show) $ do
    request <- parseRequest
        $ "https://www.google.com/m8/feeds/contacts/"
        <> email <> "/full?max-results=1000&alt=json"

    Right . getResponseBody <$> httpJSON (authorize request)
  where
    authorize = setRequestHeaders
        [ ("Authorization", B8.pack $ "Bearer " <> token)
        ]
