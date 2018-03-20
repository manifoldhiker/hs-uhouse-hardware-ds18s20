module Main where

import Control.Concurrent (threadDelay)

import Uhouse.Hardware.DS18B20

myLog :: String -> IO ()
myLog = putStrLn

main :: IO ()
main = do
    initModprobe
    file <- getTemperatureFile
    go file
      where
        go tempFile = do
            temp <- readTemp tempFile
            myLog $ show temp
            threadDelay 1000000
            go tempFile
