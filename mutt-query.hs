{-# LANGUAGE OverloadedStrings #-}
module Main where

import Google.Contacts.Client
import Google.Contacts.Formatters.Mutt
import Google.Contacts.Query

import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import Options.Applicative
import System.Environment (getEnv)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.Exit (exitFailure)
import System.FilePath ((</>), (<.>))
import System.IO (hPutStrLn, stderr)

import qualified Data.Text.IO as T

data Options = Options
    { oEmailAddress :: String
    , oQuery :: String
    }

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


getOptions :: IO Options
getOptions = execParser $ parseOptions
    `withInfo` "Query google contacts from mutt"

  where
    withInfo :: Parser a -> String -> ParserInfo a
    withInfo opts desc = info (helper <*> opts) $ progDesc desc

    parseOptions :: Parser Options
    parseOptions = Options
        <$> argument str (metavar "EMAIL")
        <*> argument str (metavar "QUERY")
