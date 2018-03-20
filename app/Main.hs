module Main where

import Control.Concurrent (threadDelay)
import Data.DateTime (getCurrentTime)

import Uhouse.Hardware.DS18B20

myLog :: Maybe Temperature -> IO ()
myLog t = do
    currTime <- getCurrentTime
    let logM = show (currTime, t) ++ "\n"
    appendFile "temperature.log" logM
    putStr logM

main :: IO ()
main = do
    -- initModprobe
    file <- getTemperatureFile
    putStrLn $ show file
    go file
      where
        go tempFile = do
            temp <- readTemp tempFile
            myLog temp
            threadDelay 1000000
            go tempFile
