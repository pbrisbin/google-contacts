module Contacts.Options
    ( Options(..)
    , getOptions
    ) where

import Options.Applicative

data Options = Options
    { oEmailAddress :: String
    , oQuery :: String
    }

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
