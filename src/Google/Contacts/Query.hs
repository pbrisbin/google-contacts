module Google.Contacts.Query
    ( queryFeed
    ) where

import Google.Contacts.Feed

import Data.Text (Text)

import qualified Data.Text as T

queryFeed :: String -> Feed -> [Entry]
queryFeed query = filter (matches query) . feedEntries

matches :: String -> Entry -> Bool
matches query entry
    | query `matchesText` title = True
    | any ((query `matchesText`) . emailAddress) $ emails = True
    | otherwise = False

  where
    title = entryTitle entry
    emails = entryEmails entry

matchesText :: String -> Text -> Bool
matchesText s t = T.pack s `containedIn` t

-- A case-insensitive isInfixOf
containedIn :: Text -> Text -> Bool
x `containedIn` y = T.toCaseFold x `T.isInfixOf` T.toCaseFold y
