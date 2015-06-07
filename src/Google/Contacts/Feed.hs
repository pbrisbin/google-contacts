{-# LANGUAGE OverloadedStrings #-}
module Google.Contacts.Feed
    ( Email(..)
    , Entry(..)
    , Feed(..)
    ) where

import Data.Aeson
import Data.Monoid ((<>))
import Data.Text (Text)

data Email = Email
    { emailAddress :: Text
    , emailPrimary :: Bool
    }
    deriving (Eq, Show)

-- primary first, then address ascending
instance Ord Email where
    Email _ True `compare` Email _ False = LT
    Email _ False `compare` Email _ True = GT
    Email a _ `compare` Email b _ = a `compare` b

instance FromJSON Email where
    parseJSON = withObject "Email" $ \o -> Email
        <$> o .: "address"
        <*> (toBool =<< (o .:? "primary" .!= "false"))

      where
        toBool "true" = return True
        toBool "false" = return False
        toBool x = fail $ "non-boolean string: " <> x

data Entry = Entry
    { entryId :: Text
    , entryTitle :: Text
    , entryEmails :: [Email]
    }
    deriving Show

instance FromJSON Entry where
    parseJSON = withObject "Entry" $ \o -> Entry
        <$> ((.: "$t") =<< o .: "id")
        <*> ((.: "$t") =<< o .: "title")
        <*> o .:? "gd$email" .!= []

data Feed = Feed
    { feedEntries :: [Entry]
    }
    deriving Show

instance FromJSON Feed where
    parseJSON = withObject "Feed" $ \o -> Feed
        <$> ((.: "entry") =<< o .: "feed")
