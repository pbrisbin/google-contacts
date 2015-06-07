{-# LANGUAGE OverloadedStrings #-}
module Main where

import Contacts.Client
import Contacts.Feed
import Contacts.Options

import Control.Monad (forM_)
import Data.Monoid ((<>))
import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import System.Environment (getEnv)

import qualified Data.Text.IO as T

main :: IO ()
main = do
    options <- getOptions

    token <- getToken $ oEmailAddress options
    decoded <- getFeedJSON token $ oEmailAddress options

    case decoded of
        Left err -> putStrLn err
        Right feed -> forM_ (feedEntries feed) $ \entry -> do
            T.putStrLn $ entryTitle entry
            forM_ (entryEmails entry) $ \email -> do
                T.putStrLn $ "  - " <> emailAddress email

getToken :: String -> IO OAuth2Token
getToken email = do
    client <- OAuth2Client
        <$> getEnv "GOOGLE_OAUTH_CLIENT_ID"
        <*> getEnv "GOOGLE_OAUTH_CLIENT_SECRET"

    getAccessToken client scopes $ Just cache

  where
    scopes :: [String]
    scopes = ["https://www.googleapis.com/auth/contacts.readonly"]

    -- TODO: XDG_CACHE_HOME
    cache :: FilePath
    cache = "/home/patrick/.cache/contacts/" <> email <> ".token"
