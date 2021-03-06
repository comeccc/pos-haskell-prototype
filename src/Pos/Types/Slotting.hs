{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ViewPatterns        #-}

-- | Slotting types.

module Pos.Types.Slotting
       ( flattenSlotId
       , unflattenSlotId
       ) where

import           Universum

import           Pos.Constants   (epochSlots)
import           Pos.Types.Types (FlatSlotId, SlotId (..))

-- | Flatten 'SlotId' (which is basically pair of integers) into a single number.
flattenSlotId :: SlotId -> FlatSlotId
flattenSlotId SlotId {..} = fromIntegral siEpoch * epochSlots + fromIntegral siSlot

-- | Construct 'SlotId' from a flattened variant.
unflattenSlotId :: FlatSlotId -> SlotId
unflattenSlotId n =
    let (fromIntegral -> siEpoch, fromIntegral -> siSlot) =
            n `divMod` epochSlots
    in SlotId {..}

instance Enum SlotId where
    toEnum = unflattenSlotId . fromIntegral
    fromEnum = fromIntegral . flattenSlotId
