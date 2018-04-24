{-# LANGUAGE OverloadedStrings #-}

module Google.Contacts.Token
    ( getToken
    ) where

import qualified Data.Text as T
import Network.Google.OAuth2
import Network.OAuth.OAuth2
import System.Directory (createDirectoryIfMissing)
import System.Environment.XDG.BaseDir (getUserCacheDir)
import System.FilePath ((<.>), (</>))

import qualified Client as C

getToken :: String -> IO OAuth2Token
getToken email = do
    cdir <- getUserCacheDir "contacts"
    createDirectoryIfMissing True cdir
    getAccessToken
        -- TODO: write the file as Text
        (T.pack C.clientId)
        (T.pack C.clientSecret)
        ["https://www.googleapis.com/auth/contacts.readonly"]
        (Just $ cdir </> email <.> "token")
