{-# LANGUAGE OverloadedStrings #-}
module Main where

import Contacts.Client
import Contacts.Format
import Contacts.Options
import Contacts.Query

import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import System.Environment (getEnv)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.Exit (exitFailure)
import System.FilePath ((</>), (<.>))
import System.IO (hPutStrLn, stderr)

import qualified Data.Text.IO as T

main :: IO ()
main = do
    options <- getOptions

    token <- getToken $ oEmailAddress options
    decoded <- getFeedJSON token $ oEmailAddress options

    case decoded of
        Left err -> do
            hPutStrLn stderr err
            exitFailure

        Right feed -> T.putStrLn $
            formatEntries $ queryFeed (oQuery options) feed

getToken :: String -> IO OAuth2Token
getToken email = do
    client <- OAuth2Client
        <$> getEnv "GOOGLE_OAUTH_CLIENT_ID"
        <*> getEnv "GOOGLE_OAUTH_CLIENT_SECRET"

    cdir <- getUserCacheDir "contacts"
    getAccessToken client scopes $ Just $ cache cdir

  where
    scopes :: [String]
    scopes = ["https://www.googleapis.com/auth/contacts.readonly"]

    cache :: FilePath -> FilePath
    cache cdir = cdir </> email <.> "token"
