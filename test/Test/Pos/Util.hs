{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE RankNTypes          #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Test.Pos.Util
       ( binaryEncodeDecode
       , safeCopyEncodeDecode
       , serDeserId
       , showRead
       ) where

import           Data.SafeCopy   (SafeCopy, safeGet, safePut)
import           Data.Serialize  (runGet, runPut)
import           Pos.Binary      (Bi, Serialized (..), decode, encode)
import           Prelude         (read)
import           Test.QuickCheck (Property, (===))
import           Universum

binaryEncodeDecode :: (Show a, Eq a, Bi a) => a -> Property
binaryEncodeDecode a = decode (encode a) === a

safeCopyEncodeDecode :: (Show a, Eq a, SafeCopy a) => a -> Property
safeCopyEncodeDecode a =
    either (panic . toText) identity
     (runGet safeGet $ runPut $ safePut a) === a

showRead :: (Show a, Eq a, Read a) => a -> Property
showRead a = read (show a) === a

serDeserId :: forall t lt . (Show t, Eq t, Serialized t lt) => t -> Property
serDeserId a =
    let serDeser = either (panic . toText) identity . deserialize @t @lt . serialize @t @lt
    in a === serDeser a
