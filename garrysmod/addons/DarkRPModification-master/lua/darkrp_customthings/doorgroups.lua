--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)
AddDoorGroup("Government", TEAM_PRESIDENT, TEAM_POLICE_UNDERCOVER, TEAM_POLICE_K9, TEAM_POLICE, TEAM_SECRET_SERVICE, TEAM_POLICE_MEDIC, TEAM_POLICE_CHIEF, TEAM_SWAT, TEAM_SWAT_CHIEF, TEAM_SWAT_MEDIC, TEAM_SWAT_SNIPER, TEAM_SWAT_HEAVY)
AddDoorGroup("Casino", TEAM_CASINO_MANAGER)
AddDoorGroup("Bank", TEAM_BANK_MANAGER)
AddDoorGroup("Mechanic", TEAM_CAR_MECHANIC)
