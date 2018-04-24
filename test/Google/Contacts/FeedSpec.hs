{-# LANGUAGE OverloadedStrings #-}

module Google.Contacts.FeedSpec
    ( spec
    ) where

import Test.Hspec

import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as C8
import Google.Contacts.Feed

spec :: Spec
spec = describe "Feed" $
    it "is correctly parsed as JSON" $ do
        result <- eitherDecode <$> C8.readFile "test/example.json"

        expectEntry result $ \entry -> do
            entryId entry `shouldBe` "entry-id"
            entryTitle entry `shouldBe` "entry-title"

            map (\e -> (emailAddress e, emailPrimary e)) (entryEmails entry)
                `shouldBe`
                    [ ("email1@example.com", True)
                    , ("email2@example.com", False)
                    , ("email3@example.com", False)
                    ]

expectEntry :: Either String Feed -> (Entry -> Expectation) -> Expectation
expectEntry (Left err) _ = expectationFailure $ "parse error: " ++ err
expectEntry (Right (Feed [])) _ = expectationFailure "feed has no entries"
expectEntry (Right (Feed (entry:_))) f = f entry
