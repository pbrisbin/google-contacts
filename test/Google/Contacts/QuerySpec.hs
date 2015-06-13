{-# LANGUAGE OverloadedStrings #-}
module Google.Contacts.QuerySpec
    ( spec
    , main
    ) where

import Test.Hspec
import Google.Contacts.Feed
import Google.Contacts.Query

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "Query" $
    describe "queryFeed" $ do
        it "matches title case-insensitively" $ do
            let feed = Feed
                    [ Entry "1" "no match" []
                    , Entry "2" "match ab match" []
                    , Entry "3" "no match" []
                    , Entry "4" "AB match" []
                    , Entry "5" "no match" []
                    ]

            map entryId (queryFeed "ab" feed) `shouldBe` ["2", "4"]

        it "matches address case-insensitively" $ do
            let feed = Feed
                    [ Entry "1" "" [Email "no@e.com" False]
                    , Entry "2" ""
                        [ Email "anbo@e.com" False, Email "mabtch@e.com" False]
                    , Entry "3" "" []
                    , Entry "4" ""
                        [ Email "ABMatched@e.com" False, Email "no@e.com" False]
                    , Entry "5" "" []
                    ]

            map entryId (queryFeed "ab" feed) `shouldBe` ["2", "4"]
