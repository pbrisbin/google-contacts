module Main (main) where

import Control.Monad (void)
import Google.Contacts.Token
import System.Environment (getArgs)

main :: IO ()
main = mapM_ configure =<< getArgs

configure :: String -> IO ()
configure email = do
    putStrLn $ "authenticating " ++ email ++ "..."
    void $ getToken email
    putStrLn "authenticated."
