module Uhouse.Hardware.DS18B20
    (     Temperature

        ,  initModprobe
        , getTemperatureFile
        , readTemp
    )
where

import Data.Foldable (asum)
import Data.List (find, isPrefixOf, stripPrefix)
import System.Directory (getDirectoryContents)
import System.Process (callCommand)

initModprobe :: IO ()
initModprobe = do
    callCommand "modprobe w1-gpio"
    callCommand "modprobe w1-therm"

getTemperatureFile :: IO FilePath
getTemperatureFile = pickTempFile <$> getDirectoryContents "/sys/bus/w1/devices/"
  where
    pickTempFile :: [FilePath] -> FilePath
    pickTempFile ps = case find (isPrefixOf "10") ps of
        Just dn -> dn
        Nothing -> error "No device found"

newtype Temperature = RawTemperature { getRawTemp :: String } deriving (Show)

readTemp :: FilePath -> IO (Maybe Temperature)
readTemp fp = mapTemp <$> readFile fp

mapTemp :: String -> Maybe Temperature
mapTemp = fmap parseTemp . asum . fmap strip . words
  where
    strip = stripPrefix "t="
    parseTemp = RawTemperature
