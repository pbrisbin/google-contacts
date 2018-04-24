{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import qualified Data.Text.IO as T
import Google.Contacts.Client
import Google.Contacts.Formatters.Mutt
import Google.Contacts.Query
import Google.Contacts.Token
import Options.Applicative
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

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
