import Data.DateTime (getCurrentTime)

import Control.Concurrent (threadDelay)
import Uhouse.Hardware.DS18B20

myLog :: Maybe Temperature -> IO ()
myLog t = do
    currTime <- getCurrentTime
    let logM = show (currTime, t) ++ "\n"
    -- appendFile "/home/pi/temperature.ds18s20.log" logM
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
