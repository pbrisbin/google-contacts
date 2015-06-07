{-# LANGUAGE OverloadedStrings #-}
module Main where

import Contacts.Client

import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import System.Environment (getEnv)

import qualified Data.ByteString.Lazy.Char8 as L8

main :: IO ()
main = do
    t <- getToken
    feed <- getFeedJSON t "pbrisbin@gmail.com"

    L8.putStrLn $ feed

getToken :: IO OAuth2Token
getToken = do
    client <- OAuth2Client
        <$> getEnv "GOOGLE_OAUTH_CLIENT_ID"
        <*> getEnv "GOOGLE_OAUTH_CLIENT_SECRET"

    getAccessToken client scopes $ Just cache

  where
    scopes :: [String]
    scopes = ["https://www.googleapis.com/auth/contacts.readonly"]

    cache :: FilePath
    cache = "/home/patrick/.cache/contacts/oauth2.token"
