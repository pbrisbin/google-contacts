{-# LANGUAGE OverloadedStrings #-}
module Google.Contacts.Formatters.Mutt
    ( formatEntries
    , formatEntry
    , formatEmail
    ) where

import Google.Contacts.Feed

import Data.List (sort)
import Data.Monoid ((<>))
import Data.Text (Text)

import qualified Data.Text as T

formatEntries :: [Entry] -> Text
formatEntries = T.unlines . ("":) . concatMap formatEntry

formatEntry :: Entry -> [Text]
formatEntry entry =
    map (formatEmail $ entryTitle entry) $ sort $ entryEmails entry

formatEmail :: Text -> Email -> Text
formatEmail title email = emailAddress email <> "\t" <> title
