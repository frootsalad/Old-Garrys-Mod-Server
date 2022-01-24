--[[
MGANGS - TERRITORIES CONFIG
Developed by Zephruz
]]

MG2_TERRITORIES.config = {}

--[[Config]]
MG2_TERRITORIES.config.canBuild = false     -- If a player can build in a territory that's not theirs

MG2_TERRITORIES.config.claimRadius = 400    -- The distance a player can go from claiming a territory flag before it cancels

-- How long (in seconds) it takes to claim a territory
MG2_TERRITORIES.config.claimWait = {
  uncon = 5,          -- For claiming an uncontrolled territory
  con = 10,           -- For claiming a controlled territory
}

-- Rewards for claiming a territory
MG2_TERRITORIES.config.claimRewards = {
  uncon = {           -- For claiming an uncontrolled territory
    exp = 10,
    money = 100,
  },
  con = {             -- For claming a controlled territory
    exp = 100,
    money = 1000,
  },
}

-- Rewards for controlling/occupying a territory
MG2_TERRITORIES.config.occupyRewards = {
  enabled = true, -- Enable (true)/Disable (false) - Occupying rewards
  time = 300,     -- How frequent the occupying gang is rewarded (in seconds) [RECOMMENDED TO KEEP THIS ABOVE 300 SECONDS]
  exp = 5,        -- How much exp the gang gets
  money = 50,     -- How much money the gang gets
}

--[[Misc. Config]]
MG2_TERRITORIES.config.flagModels = {
  "models/zerochain/mgangs2/mgang_flagpost.mdl",  -- I would HIGHLY recommend to only use this model (as it was made for this)
}
