--[[
MGANGS - ACHIEVEMENTS CONFIG
Developed by Zephruz
]]

MG2_ACHIEVEMENTS.config = {}

-- [[Register Achievements]]
-- [[Members]]
MGangs.Gang:CreateAchievement("2 Members", "Members", {
  reqAmt = 2,         -- Number of members required
	rewards = {
		exp = 20,				-- Gang EXP received
		balance = 3000,	  -- Gang Balance received
	},

  defVal = 1,         -- Default/start value
	type = "members",	  -- Type of achievement
})

MGangs.Gang:CreateAchievement("10 Members", "Members", {
  reqAmt = 10,

	rewards = {
		exp = 100,				 -- Gang EXP received
		balance = 7500,	  -- Gang Balance received
	},

  defVal = 1,         -- Default/start value
	type = "members",	  -- Type of achievement
})

-- [[Balances]]
MGangs.Gang:CreateAchievement("Small Balance", "Balance", {
  reqAmt = 100000,
	rewards = {
		exp = 20,				-- Gang EXP received
		balance = 2000,	  -- Gang Balance received
	},

	type = "balance",	  -- Type of achievement
})

MGangs.Gang:CreateAchievement("Hefty Balance", "Balance", {
  reqAmt = 1000000,
	rewards = {
		exp = 75,				-- Gang EXP received
		balance = 5000,	  -- Gang Balance received
	},

	type = "balance",	  -- Type of achievement
})

MGangs.Gang:CreateAchievement("Massive Balance", "Balance", {
  reqAmt = 5000000,
	rewards = {
		exp = 150,				-- Gang EXP received
		balance = 10000,	 -- Gang Balance received
	},

	type = "balance",	  -- Type of achievement
})
