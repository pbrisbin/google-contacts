{-# LANGUAGE OverloadedStrings #-}
module Contacts.Format
    ( formatEntries
    ) where

import Contacts.Feed

import Data.List (sort)
import Data.Monoid ((<>))
import Data.Text (Text)

import qualified Data.Text as T

formatEntries :: [Entry] -> Text
formatEntries = T.unlines . ("":) . map formatEntry

formatEntry :: Entry -> Text
formatEntry entry = T.unlines $
    map (formatEmail $ entryTitle entry) $ sort $ entryEmails entry

formatEmail :: Text -> Email -> Text
formatEmail title email = emailAddress email <> "\t" <> title
