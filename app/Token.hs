module Token (getToken) where

import Network.Google.OAuth2 (OAuth2Client(..), OAuth2Token, getAccessToken)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.Directory (createDirectoryIfMissing)
import System.FilePath ((</>), (<.>))

import qualified Client as C

getToken :: String -> IO OAuth2Token
getToken email = do
    let client = OAuth2Client C.clientId C.clientSecret
    cdir <- getUserCacheDir "contacts"
    createDirectoryIfMissing True cdir
    getAccessToken client scopes $ Just $ cache cdir

  where
    scopes :: [String]
    scopes = ["https://www.googleapis.com/auth/contacts.readonly"]

    cache :: FilePath -> FilePath
    cache cdir = cdir </> email <.> "token"
