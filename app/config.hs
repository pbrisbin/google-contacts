module Main where

import Token

import System.Environment (getArgs)
import Control.Monad (void)

main :: IO ()
main = mapM_ configure =<< getArgs

configure :: String -> IO ()
configure email = do
    putStrLn $ "authenticating " ++ email ++ "..."
    void $ getToken email
    putStrLn $ "authenticated."
