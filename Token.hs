module Token (getToken) where

import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import System.Environment (getEnv)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.FilePath ((</>), (<.>))

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
