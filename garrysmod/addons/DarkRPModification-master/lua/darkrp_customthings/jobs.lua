-- Jobs File
-- Citizens Start
TEAM_BATTLE_MEDIC = DarkRP.createJob("Battle Medic", {
    color = Color(176, 176, 176, 255),
    model = {
                "models/player/Group03/male_02.mdl",
                "models/player/Group03/male_03.mdl",
                "models/player/Group03/male_07.mdl",
                "models/player/Group03/male_05.mdl"
            },
    description = [[]],
    weapons = {"pro_med_kit"},
    command = "battlemedic",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_LIGHT_ARMS_DEALER = DarkRP.createJob("Light Arms Dealer", {
    color = Color(255, 140, 0, 255),
    model = "models/player/monk.mdl",
    description = [[]],
    weapons = {""},
    command = "gundealer",
    max = 4,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"})
	
TEAM_CAR_MECHANIC = DarkRP.createJob("Car Mechanic", {
    color = Color(211, 211, 211, 255),
    model = "models/player/hostage/hostage_02.mdl",
    description = [[]],
    weapons = {"vc_wrench","vc_jerrycan"},
    command = "mechanic",
    max = 2,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens"})

TEAM_DJ = DarkRP.createJob("DJ", {
    color = Color(139, 0, 139, 255),
    model = {"models/player/daftpunk/daft_gold.mdl", "models/player/daftpunk/daft_silver.mdl"},
    description = [[]],
    weapons = {},
    command = "dj",
    max = 1,
    salary = 75,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = false,
    category = "Citizens"})

TEAM_HEAVY_ARMS_DEALER = DarkRP.createJob("Heavy Arms Dealer", {
    color = Color(209, 67, 4, 255),
    model = "models/player/eli.mdl",
    description = [[]],
    weapons = {""},
    command = "heavyarmsdealer",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_HOBO = DarkRP.createJob("Hobo", {
    color = Color(80, 45, 0, 255),
    model = "models/player/corpse1.mdl",
    description = [[]],
    weapons = {"weapon_angryhobo"},
    command = "hobo",
    max = 5,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Citizens",})

TEAM_HOBO_KING = DarkRP.createJob("Hobo King", {
    color = Color(80, 45, 0, 255),
    model = "models/player/zombie_soldier.mdl",
    description = [[]],
    weapons = {"weapon_angryhobo"},
    command = "hoboking",
    max = 1,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    hobo = true,
    category = "Citizens",})

TEAM_CASINO_MANAGER = DarkRP.createJob("Casino Manager", {
    color = Color(66, 244, 116, 255),
    model = "models/player/gman_high.mdl",
    description = [[]],
    weapons = {},
    command = "casinomanager",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens",})

TEAM_BANK_MANAGER = DarkRP.createJob("Bank Manager", {
    color = Color(66, 244, 116, 255),
    model = "models/player/magnusson.mdl",
    description = [[]],
    weapons = {},
    command = "bankmanager",
    max = 1,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = false,
    category = "Citizens",})

TEAM_PARKOUR = DarkRP.createJob("Parkourist", {
    color = Color(66, 244, 116, 255),
    model = "models/player/p2_chell.mdl",
    description = [[]],
    weapons = {"climb_swep2"},
    command = "parkourist",
    max = 4,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",})
-- Citizens End

-- Government Start
TEAM_POLICE = DarkRP.createJob("Police Officer", {
    color = Color(20, 55, 255, 255),
    model = {
        "models/player/uk_police/uk_police_01.mdl",
        "models/player/uk_police/uk_police_02.mdl",
        "models/player/uk_police/uk_police_03.mdl",
        "models/player/uk_police/uk_police_04.mdl",
        "models/player/uk_police/uk_police_05.mdl",
        "models/player/uk_police/uk_police_06.mdl",
        "models/player/uk_police/uk_police_07.mdl",
        "models/player/uk_police/uk_police_09.mdl"
    },
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_hk45", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "police",
    max = 8,
    salary = 500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government"})

TEAM_POLICE_UNDERCOVER = DarkRP.createJob("Undercover Cop", {
    color = Color(20, 55, 255, 255),
    model = {
        "models/player/uk_police/uk_police_01.mdl",
        "models/player/uk_police/uk_police_02.mdl",
        "models/player/uk_police/uk_police_03.mdl",
        "models/player/uk_police/uk_police_04.mdl",
        "models/player/uk_police/uk_police_05.mdl",
        "models/player/uk_police/uk_police_06.mdl",
        "models/player/uk_police/uk_police_07.mdl",
        "models/player/uk_police/uk_police_09.mdl"
    },
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_hk45", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "undercovercop",
    max = 1,
    salary = 500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government"})

TEAM_POLICE_K9 = DarkRP.createJob("Police K9", {
    color = Color(20, 55, 255, 255),
    model = {
        "models/pierce/police_k9.mdl"
    },
    description = [[]],
    weapons = {"weapon_sh_detector", "weapon_pet"},
    command = "k9",
    max = 1,
    salary = 500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government"})

TEAM_POLICE_CHIEF = DarkRP.createJob("Police Chief", {
    color = Color(20, 55, 255, 255),
    model = {"models/player/uk_police/uk_police_08.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_remington870", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "policechief",
    max = 1,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    chief = true,
    category = "Government",
    NeedToChangeFrom = TEAM_POLICE})

TEAM_POLICE_MEDIC = DarkRP.createJob("Police Medic", {
    color = Color(20, 55, 255, 255),
    model = {
                "models/player/Group03m/male_02.mdl",
                "models/player/Group03m/female_02.mdl",
                "models/player/Group03m/female_04.mdl",
                "models/player/Group03m/female_03.mdl",
                "models/player/Group03m/male_01.mdl",
                "models/player/Group03m/male_04.mdl",
                "models/player/Group03m/male_03.mdl",
                "models/player/Group03m/male_05.mdl",
                "models/player/Group03m/male_08.mdl"
            },
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_hk45", "med_kit", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "policemedic",
    max = 8,
    salary = 500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government"})

TEAM_SWAT = DarkRP.createJob("S.W.A.T. Officer", {
    color = Color(10, 10, 255, 255),
    model = {"models/mark2580/payday2/pd2_gs_elite_player.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_m92beretta", "m9k_smgp90", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "swat",
    max = 4,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
	category = "Government",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_SWAT_SNIPER = DarkRP.createJob("S.W.A.T. Sniper", {
    color = Color(10, 10, 255, 255),
    model = {"models/mark2580/payday2/pd2_gs_elite_player.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_intervention", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "swatsniper",
    max = 1,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",
    category = "Government"})

TEAM_SWAT_HEAVY = DarkRP.createJob("S.W.A.T. Heavy", {
    color = Color(10, 10, 255, 255),
    model = {"models/mark2580/payday2/pd2_bulldozer_zeal_player.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_ares_shrike", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "swatheavy",
    max = 1,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
	customCheck = function(ply) return CLIENT or
    table.HasValue({"vip", "celestial", "vtrialmoderator", "ctrialmoderator", "vmoderator", "cmoderator", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a VIP+ job",
    PlayerSpawn = function(ply)
        if SERVER then
            ply:SetBodygroup(5, 1)
            ply:SetBodygroup(0, 1)
            ply:SetArmor(150)
            ply:SetWalkSpeed(120)
            ply:SetRunSpeed(200)
        end
    end,
    PlayerLoadout = function(ply)
        if SERVER then
            ply:SetBodygroup(5, 1)
            ply:SetBodygroup(0, 1)
            ply:SetArmor(150)
            ply:SetWalkSpeed(120)
            ply:SetRunSpeed(200)
        end
    end,
    category = "Government"})

TEAM_SWAT_MEDIC = DarkRP.createJob("S.W.A.T. Medic", {
    color = Color(10, 10, 255, 255),
    model = {"models/payday2/units/medic_player.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_m92beretta", "pro_med_kit", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "swatmedic",
    max = 2,
    salary = 750,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",
    category = "Government"})

TEAM_SWAT_CHIEF = DarkRP.createJob("S.W.A.T. Commander", {
    color = Color(10, 10, 255, 255),
    model = {"models/mark2580/payday2/pd2_gs_elite_player.mdl"},
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_m92beretta", "m9k_usas", "arrest_stick", "unarrest_stick", "stunstick", "door_ram", "weaponchecker"},
    command = "swatcommander",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    chief = true,
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",
    category = "Government"})

TEAM_PRESIDENT = DarkRP.createJob("President", {
    color = Color(34, 159, 199, 255),
    model = {"models/player/breen.mdl"},
    description = [[ ]],
    weapons = {},
    command = "president",
    max = 1,
    salary = 1000,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = false,
    category = "Government",
    mayor = true,
    PlayerDeath = function(ply, weapon, killer)
        ply:teamBan()
        ply:changeTeam(GAMEMODE.DefaultTeam, true)
        DarkRP.notifyAll(0, 4, "The president died and therefore a new one must be elected.")
    end})

TEAM_SECRET_SERVICE = DarkRP.createJob("Secret Service", {
    color = Color(20, 55, 255, 255),
    model = {
        "models/player/barney.mdl"
    },
    description = [[]],
    weapons = {"stungun", "weapon_cuff_police", "m9k_usp", "arrest_stick", "unarrest_stick", "stunstick", "weaponchecker"},
    command = "secretservice",
    max = 4,
    salary = 500,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Government"})

GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_POLICE_K9] = true,
    [TEAM_POLICE_UNDERCOVER] = true,
    [TEAM_POLICE_MEDIC] = true,
    [TEAM_POLICE_CHIEF] = true,
    [TEAM_SWAT] = true,
    [TEAM_SWAT_CHIEF] = true,
    [TEAM_SWAT_MEDIC] = true,
    [TEAM_SWAT_SNIPER] = true,
    [TEAM_SWAT_HEAVY] = true,
    [TEAM_SECRET_SERVICE] = true}
-- Government End

-- Criminals Start
TEAM_THIEF = DarkRP.createJob("Thief", {
    color = Color(176, 176, 176, 255),
    model = {"models/player/arctic.mdl"},
    description = [[]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "thief",
    max = 14,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})
    
TEAM_DEMO = DarkRP.createJob("Demolitionist", {
    color = Color(176, 176, 176, 255),
    model = {"models/player/arctic.mdl"},
    description = [[]],
    weapons = {"lockpick", "weapon_sh_doorcharge"},
    command = "demolitionist",
    max = 2,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})
    
TEAM_DEALER = DarkRP.createJob("Marijuana Specialist", {
    color = Color(176, 176, 176, 255),
    model = {"models/models/konnie/stoner/stoner.mdl"},
    description = [[]],
    weapons = {},
    command = "weed",
    max = 4,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Drug Dealers"})
	
TEAM_PRO_THIEF = DarkRP.createJob("Pro Thief", {
    color = Color(126, 126, 126, 255),
    model = {
                "models/player/pd2_chains_p.mdl",
                "models/player/pd2_dallas_p.mdl",
                "models/player/pd2_hoxton_p.mdl",
                "models/player/pd2_wolf_p.mdl"
            },
    description = [[]],
    weapons = {"csgo_default_t", "m9k_sig_p229r", "pro_lockpick", "pro_keypad_cracker"},
    command = "prothief",
    max = 8,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_STEALTHY_THIEF_ = DarkRP.createJob("Stealthy Thief", {
    color = Color(255, 255, 255, 255),
    model = {"models/player/tfa_syn_kilo.mdl"},
    description = [[]],
    weapons = {"csgo_default_knife", "climb_swep2", "suppressed_pistol", "stealthy_lockpick", "stealthy_keypad_cracker"},
    command = "stealthythief",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals",
    PlayerSpawn = function(ply)
        if SERVER then
            ply:SetMaxHealth(50)
            ply:SetHealth(50)
            ply:SetWalkSpeed(176)
            ply:SetRunSpeed(264)
        end
    end,
    PlayerLoadout = function(ply)
        if SERVER then
            ply:SetMaxHealth(50)
            ply:SetHealth(50)
            ply:SetWalkSpeed(176)
            ply:SetRunSpeed(264)
        end
    end,
	customCheck = function(ply) return CLIENT or
    table.HasValue({"superadmin"}, ply:GetNWString("usergroup"))	
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_KIDNAPPER = DarkRP.createJob("Kidnapper", {
    color = Color(22, 22, 22, 255),
    model = {"models/player/phoenix.mdl"},
    description = [[]],
    weapons = {"weapon_leash_elastic"},
    command = "kidnapper",
    max = 8,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Criminals"})

TEAM_PRO_KIDNAPPER = DarkRP.createJob("Pro Kidnapper", {
    color = Color(22, 22, 22, 255),
    model = {"models/player/guerilla.mdl"},
    description = [[]],
    weapons = {"m9k_deagle", "weapon_cuff_rope"},
    command = "prokidnapper",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Criminals",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

TEAM_CRIPZ_LEADER = DarkRP.createJob("Cripz Leader", {
    color = Color(42, 178, 237, 255),
    model = {"models/player/cripz/slow_3.mdl"},
    description = [[]],
    weapons = {"m9k_coltpython", "lockpick", "keypad_cracker"},
    command = "cripzleader",
    max = 1,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_CRIP = DarkRP.createJob("Crip", {
    color = Color(42, 178, 237, 255),
    model = {"models/player/cripz/slow_1.mdl", "models/player/cripz/slow_2.mdl"},
    description = [[]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "crip",
    max = 8,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_BLOODZ_LEADER = DarkRP.createJob("Bloodz Leader", {
    color = Color(255, 33, 33, 255),
    model = {"models/player/bloodz/slow_1.mdl"},
    description = [[]],
    weapons = {"m9k_model3russian", "lockpick", "keypad_cracker"},
    command = "bloodzleader",
    max = 1,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_BLOOD = DarkRP.createJob("Blood", {
    color = Color(255, 33, 33, 255),
    model = {"models/player/bloodz/slow_1.mdl", "models/player/bloodz/slow_2.mdl"},
    description = [[]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "blood",
    max = 8,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_MAFIA_LEADER = DarkRP.createJob("Godfather", {
    color = Color(0, 0, 0, 255),
    model = {"models/humans/mafia/male_08.mdl"},
    description = [[]],
    weapons = {"m9k_remington1858", "lockpick", "keypad_cracker"},
    command = "mafialeader",
    max = 1,
    salary = 75,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_MAFIA = DarkRP.createJob("Mafia", {
    color = Color(0, 0, 0, 255),
    model = {
                "models/humans/mafia/male_02.mdl",
                "models/humans/mafia/male_04.mdl", 
                "models/humans/mafia/male_06.mdl", 
                "models/humans/mafia/male_07.mdl",
                "models/humans/mafia/male_09.mdl"
            },
    description = [[]],
    weapons = {"lockpick", "keypad_cracker"},
    command = "mafia",
    max = 8,
    salary = 50,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Criminals"})

TEAM_HITMAN = DarkRP.createJob("Hitman", {
    color = Color(168, 24, 24, 255),
    model = {
        "models/player/leet.mdl",
        "models/player/guerilla.mdl"
    },
    description = [[]],
    weapons = {"m9k_colt1911"},
    command = "hitman",
    max = 4,
    salary = 50,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = true,
    category = "Hitmen"})

TEAM_ASSASSIN = DarkRP.createJob("Assassin", {
    color = Color(168, 24, 24, 255),
    model = {"models/player/lordvipes/rerc_vector/vector_cvp.mdl"},
    description = [[]],
    weapons = {"m9k_usp", "m9k_m24", "climb_swep2"},
    command = "assassin",
    max = 3,
    salary = 100,
    admin = 0,
    vote = true,
    hasLicense = false,
    candemote = true,
    category = "Hitmen",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})

DarkRP.addHitmanTeam(TEAM_HITMAN) 
DarkRP.addHitmanTeam(TEAM_ASSASSIN) 
-- Criminals End

-- Security Start

TEAM_SECURITY_GUARD = DarkRP.createJob("Security Guard", {
    color = Color(0, 0, 0, 255),
    model = {"models/player/odessa.mdl"},
    description = [[]],
    weapons = {"m9k_colt1911"},
    command = "securityguard",
    max = 4,
    salary = 50,
    admin = 0,
    vote = true,
    hasLicense = true,
    candemote = true,
    category = "Security"})

TEAM_MERCENARY = DarkRP.createJob("Mercenary", {
    color = Color(255, 50, 50, 255),
    model = {"models/mark2580/payday2/pd2_cloaker_zeal_player.mdl"},
    description = [[]],
    weapons = {"m9k_model500", "m9k_winchester73"},
    command = "mercenary",
    max = 4,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = true,
    candemote = true,
    category = "Security",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"donator", "vip", "celestial", "dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a donator+ job",})
-- Security End

-- Other Start

TEAM_DARTH_VADER = DarkRP.createJob("Darth Vader", {
    color = Color(0, 0, 0, 255),
    model = {"models/player/darth_vader.mdl"},
    description = [[]],
    weapons = {"weapon_lightsaber"},
    command = "darthvader",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Other",
	customCheck = function(ply) return CLIENT or
    table.HasValue({"vip", "celestial", "vtrialmoderator", "ctrialmoderator", "vmoderator", "cmoderator", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup"))
						end,
	CustomCheckFailMsg = "This is a VIP+ job"})

TEAM_LUKE_SKYWALKER = DarkRP.createJob("Luke Skywalker", {
    color = Color(33, 255, 33, 255),
    model = {"models/player/luke_skywalker.mdl"},
    description = [[]],
    weapons = {"weapon_lightsaber"},
    command = "lukeskywalker",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Other",
	customCheck = function(ply) return CLIENT or table.HasValue({"celestial", "ctrialmoderator", "cmoderator", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup")) end,
	CustomCheckFailMsg = "This is a VIP+ job",})

-- Other End

-- Staff Start
TEAM_STAFF = DarkRP.createJob("Staff on Duty", {
    color = Color(255, 0, 199, 255),
    model = {"models/player/combine_super_soldier.mdl"},
    description = [[This is for staff that aren't currently roleplaying]],
    weapons = {"arrest_stick", "unarrest_stick", "weapon_keypadchecker", "staff_lockpick"},
    command = "staff",
    max = 0,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Staff",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
    end,
customCheck = function(ply) return CLIENT or table.HasValue({"dtrialmoderator", "vtrialmoderator", "ctrialmoderator", "dmoderator", "vmoderator", "cmoderator", "dadmin", "vadmin", "cadmin", "sr.admin", "superadmin"}, ply:GetNWString("usergroup")) end,
CustomCheckFailMsg = "This job is Staff only.",})
-- Staff End

-- Custom Jobs Start
TEAM_RORSCHACH = DarkRP.createJob("Rorschach", {
    color = Color(85, 26, 139, 255),
    model = "models/player/saintbaron/rorschach/rorschach.mdl",
    description = [[]],
    weapons = {"blink", "weapon_camo", "pro_med_kit", "m9k_spas12", "awp_asiimov", "pro_lockpick", "pro_keypad_cracker"},
    command = "rorschach",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:69686745", "STEAM_0:0:75914575"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Kakarot's Custom Job."})

TEAM_RATCHET = DarkRP.createJob("Ratchet", {
    color = Color(255, 233, 0, 255),
    model = "models/player/korka007/ratchet.mdl",
    description = [[]],
    weapons = {"m9k_spas12", "blink", "pro_lockpick", "pro_keypad_cracker"},
    command = "ratchet",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:86628945"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Hoyo's Custom Job."})

TEAM_GRIM = DarkRP.createJob("Grim Reaper", {
    color = Color(157, 0, 219, 255),
    model = "models/dawson/death_a_grim_bundle_pms/death_classic/death_classic.mdl",
    description = [[]],
    weapons = {"m9k_psg1", "m9k_spas12", "weapon_camo", "blink", "pro_lockpick", "weapon_sh_doorcharge", "pro_keypad_cracker"},
    command = "grim",
    max = 1,
    salary = 69,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:67831329"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Molly's Custom Job."})

TEAM_XENOMORPH = DarkRP.createJob("Xenomorph", {
    color = Color(0, 0, 0, 255),
    model = {
            "models/iffy/alienscm/alien/xeno_boiler_player.mdl",
            "models/iffy/alienscm/alien/xeno_lurker_player.mdl",
            "models/iffy/alienscm/alien/xeno_soldier_player.mdl"
        },
    description = [[]],
    weapons = {"m9k_psg1", "m9k_spas12", "weapon_camo", "blink", "pro_lockpick", "pro_keypad_cracker", "pro_med_kit"},
    command = "xenomorph",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:55844420", "STEAM_0:0:56820243"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Mdubs's Custom Job."})

TEAM_DOOMSLAYER = DarkRP.createJob("Doom Slayer", {
    color = Color(255, 0, 0, 255),
    model = "models/pechenko_121/doomslayer.mdl",
    description = [[]],
    weapons = {"m9k_psg1", "blink", "pro_lockpick", "pro_keypad_cracker", "m9k_dbarrel", "weapon_camo", "pro_med_kit"},
    command = "doom",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:47056899", "STEAM_0:1:55117269"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Mickey's Custom Job."})

TEAM_TYRONE = DarkRP.createJob("Tyrone", {
    color = Color(165, 0, 0, 255),
    model = "models/player/corvo.mdl",
    description = [[]],
    weapons = {"m9k_psg1", "blink", "pro_lockpick", "pro_keypad_cracker", "m9k_m249lmg", "weapon_camo", "weapon_vape_medicinal"},
    command = "tyrone",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:66035302"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Squeak's Custom Job."})

TEAM_GREG = DarkRP.createJob("Greg", {
    color = Color(0, 0, 0, 255),
    model = "models/player/bobert/redhood.mdl",
    description = [[]],
    weapons = {"m9k_svu", "blink", "pro_lockpick", "pro_keypad_cracker", "m9k_dbarrel", "weapon_camo"},
    command = "greg",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:86995000"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is SpicyEggRoll's Custom Job."})

TEAM_INFILTRATOR = DarkRP.createJob("Infiltrator", {
    color = Color(140, 140, 140, 255),
    model = "models/player/n7legion/quarian_infiltrator.mdl",
    description = [[]],
    weapons = {"m9k_svu", "pro_lockpick", "pro_keypad_cracker", "m9k_ares_shrike", "weapon_camo"},
    command = "infiltrator",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:86171972", "STEAM_0:0:143973073"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Prone's Custom Job."})

TEAM_JASON_VOORHEES	 = DarkRP.createJob("Jason Voorhees", {
    color = Color(35, 35, 35, 255),
    model = "models/models/konnie/jasonpart8/jasonpart8.mdl",
    description = [[]],
    weapons = {"m9k_SVU", "stealthy_lockpick", "stealthy_keypad_cracker", "weapon_camo", "m9k_spas12", "pro_med_kit"},
    command = "breather",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:47056899", "STEAM_0:0:56820243"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is mickey's Custom Job."})

TEAM_GHOST_RIDER = DarkRP.createJob("The Ghost Rider", {
    color = Color(139, 0, 139, 255),
    model = "models/player/ghostrider/ghostrider.mdl",
    description = [[]],
    weapons = {"m9k_psg1", "blink", "pro_lockpick", "pro_keypad_cracker", "m9k_ares_shrike", "weapon_camo"},
    command = "ghostrider",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:91163155"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is TacTic's Custom Job."})

TEAM_HACKER = DarkRP.createJob("Hacker", {
    color = Color(0, 0, 0, 255),
    model = "models/player/anonymous.mdl",
    description = [[]],
    weapons = {"m9k_svu", "m9k_spas12", "weapon_camo", "blink", "pro_lockpick", "weapon_sh_doorcharge", "pro_keypad_cracker"},
    command = "hacker",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:46619133"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Hatty's Custom Job."})

TEAM_KERMIT = DarkRP.createJob("Kermit the Frog", {
    color = Color(32, 219, 32, 255),
    model = "models/player/kermit.mdl",
    description = [[]],
    weapons = {"weapon_camo", "pro_lockpick", "pro_keypad_cracker", "m9k_spas12", "m9k_svu"},
    command = "kermit",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:46757294"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Benjjamin's Custom Job."})

TEAM_BURNED_MAN = DarkRP.createJob("Burned Man", {
    color = Color(110, 110, 110, 255),
    model = "models/kuma96/joshuagraham/joshuagraham_pm.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_spas12", "m9k_svu"},
    command = "burnedman",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:38250478"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Rebitaay's Custom Job."})

TEAM_SNOOP_DOGG = DarkRP.createJob("Snoop Dogg", {
    color = Color(0, 130, 32, 255),
    model = "models/player/voikanaa/snoop_dogg.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_jackhammer", "m9k_svu", "blink"},
    command = "snoopdogg",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:83986999"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Daily's Custom Job."})

TEAM_SHARK = DarkRP.createJob("The Silly Shark", {
    color = Color(66, 238, 240, 255),
    model = "models/freeman/player/left_shark.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "m9k_psg1", "m9k_spas12", "riot_shield"},
    command = "shark",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:55844420"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is matt's Custom Job."})

TEAM_KING = DarkRP.createJob("King Penguin", {
    color = Color(0, 0, 0, 255),
    model = "models/mark2580/defalt_playermodel.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "awpdragon", "m9k_svu", "m9k_dbarrel", "blink", "weapon_camo"},
    command = "king",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:111509393"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is teddybear's Custom Job."})

TEAM_WULF = DarkRP.createJob("Wulf", {
    color = Color(119, 0, 255, 255),
    model = "models/thresh/thresh.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink"},
    command = "wulf",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:164033727"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is derkins's Custom Job."})

TEAM_WIDOW_MAKER = DarkRP.createJob("Widowmaker", {
    color = Color(135, 0, 255, 255),
    model = "models/player/tfa_widowmaker.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "m9k_svu", "m9k_spas12"},
    command = "widow",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:41422748"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is CoCo's Custom Job."})

TEAM_CLOAKER = DarkRP.createJob("Cloaker", {
    color = Color(255, 127, 71, 255),
    model = "models/player/fuze_spetsnaz.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "weapon_camo"},
    command = "cloaker",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:97943078", "STEAM_0:0:96045873"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is LazyDoge's Custom Job."})

TEAM_GORDON_FREEMAN = DarkRP.createJob("Gordon Freeman", {
    color = Color(224, 130, 18, 255),
    model = "models/joshers/badasses/playermodels/eli.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "weapon_rainbowshotgun", "m9k_barret_m82", "m9k_ak47"},
    command = "thedealer",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:4072141"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Comet's Custom Job."})

TEAM_WALRIDER = DarkRP.createJob("Walrider", {
    color = Color(36, 36, 36, 255),
    model = "models/immigrant/outlast/walrider_pm.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "weapon_camo", "m9k_m60", "m9k_svu", "blink"},
    command = "walrider",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:41422748", "STEAM_0:0:189217395"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is CoCo's Custom Job."})

TEAM_BABY_GIRL = DarkRP.createJob("Baby Girl", {
    color = Color(255, 127, 223, 255),
    model = "models/player/dewobedil/vocaloid/haku/bikini_p.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "weapon_camo", "m9k_svu", "m9k_m60", "blink"},
    command = "baby",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:126054538", "STEAM_0:0:67480843"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Panda's Custom Job."})

TEAM_THICC = DarkRP.createJob("ThiccDaddy", {
    color = Color(0, 0, 0, 255),
    model = "models/player/daedric.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "weapon_camo", "m9k_svu", "m9k_spas12", "blink", "m9k_m60"},
    command = "thicc",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:84712022", "STEAM_0:1:59286613"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is John Buckle's Custom Job."})
  
TEAM_HUNK = DarkRP.createJob("Hunk", {
    color = Color(0, 0, 0, 255),
    model = "models/player/lordvipes/rerc_hunk/hunk_cvp.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_dbarrel"},
    command = "hunk",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:184600682"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Tracy Minajj's Custom Job."})
    
TEAM_BLACK_PANTHER = DarkRP.createJob("Black Panther", {
    color = Color(0, 0, 0, 255),
    model = "models/dusty/avengers/civilwar/characters/blackpanther/blackpanther_playermodel.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "weapon_camo", "m9k_svu", "m9k_dbarrel", "awp_asiimov"},
    command = "blackpanther",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:90571076", "STEAM_0:0:150530144"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is exbower2's Custom Job."})
    
TEAM_SOUL_REAPER = DarkRP.createJob("Soul Reaper", {
    color = Color(85, 26, 139, 255),
    model = "models/thresh/thresh.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "awp_asiimov", "m9k_ak47", "m9k_dbarrel"},
    command = "soulreaper",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:178980432"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is MilkIsLife's Custom Job."})

TEAM_MASTER_CHIEF = DarkRP.createJob("Master Chief", {
    color = Color(225, 140, 227, 255),
    model = "models/player/rottweiler/mc.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_dbarrel"},
    command = "masterchief",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:86205272"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is vietnam veteran's Custom Job."})

TEAM_TRON = DarkRP.createJob("Tron the Soviet", {
    color = Color(33, 33, 255, 255),
    model = "models/player/anon/anon.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "weapon_camo", "m9k_ak47", "awpdragon", "m9k_dbarrel"},
    command = "tronthesoviet",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:107458945"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Communism's Custom Job."})

TEAM_BAMANABONI_BROTHERS = DarkRP.createJob("Bamanaboni Brothers", {
    color = Color(33, 33, 255, 255),
    model = "models/player/nanosuit/slow_nanosuit.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "weapon_camo", "m9k_svu", "awpdragon", "m9k_usas"},
    command = "bamanabonibrothers",
    max = 2,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:162689952", "STEAM_0:0:146330695"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Wilko's Custom Job."})

TEAM_GOPNIK = DarkRP.createJob("Gopnik", {
    color = Color(255, 2, 5, 255),
    model = "models/gtaiv/characters/niko.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "m9k_svu", "m9k_spas12", "pro_med_kit"},
    command = "gopnik",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:46885963"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is DanK's Custom Job."})
	
	TEAM_JOKER = DarkRP.createJob("Joker", {
    color = Color(6, 193, 0, 255),
    model = "models/player/bobert/acjoker.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "m9k_svu", "m9k_spas12", "weapon_camo"},
    command = "joker",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:48261364"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Salts's Custom Job."})

	TEAM_MYSTERIOUS_HEROINE_X = DarkRP.createJob("Mysterious Heroine X", {
    color = Color(0, 31, 127, 255),
    model = "models/cyanblue/fate/grandorder/saber.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "blink", "m9k_svu", "m9k_spas12", "weapon_camo"},
    command = "mysteriousheroinex",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:62515216"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Pandimei's Custom Job."})

TEAM_THE_EQUALIZER = DarkRP.createJob("The Equalizer", {
    color = Color(191, 127, 255, 255),
    model = "models/mailer/wow_characters/wowanim_illidan.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_usas", "m9k_barret_m82", "edgystick", "blink"},
    command = "equalizer",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:79606616"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Donny's Custom Job."})

TEAM_CRASHED = DarkRP.createJob("Crashed", {
    color = Color(0, 0, 0, 255),
    model = "models/player/dewobedil/dreadout/pocongmotor/pocongmotor.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_jackhammer", "m9k_svu", "edgystick"},
    command = "crashed",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:210515244"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Sir Asian's Custom Job."})

TEAM_RANGER = DarkRP.createJob("Ranger", {
    color = Color(0, 0, 0, 255),
    model = "models/ncr/rangercombatarmor.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_mp40"},
    command = "ranger",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:47367942"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Proto's Custom Job."})

TEAM_ANONYMOUS = DarkRP.createJob("Anonymous", {
    color = Color(250, 0, 0, 255),
    model = "models/player/kuma/kuma.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_usas", "blink", "weapon_camo"},
    command = "anonymous",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:162339682"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Anonymous Bear's Custom Job."})

TEAM_WENSLEYDALE_THIEF = DarkRP.createJob("Wensleydale Thief", {
    color = Color(0, 31, 127, 255),
    model = "models/player/hellinspector/wallace/wallace.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_usas", "weapon_camo"},
    command = "wensleydale",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:32250027"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Karl Stefanssons's Custom Job."})

TEAM_RHYS = DarkRP.createJob("Rhys", {
    color = Color(72, 72, 72, 255),
    model = "models/mark2580/borderlands_tales/rhys_future_player.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_spas12", "m9k_deagle", "weapon_camo"},
    command = "rhys",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:40934557"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Vikingaus's Custom Job."})

TEAM_BIG_SMOKE = DarkRP.createJob("Big Smoke", {
    color = Color(24, 116, 44, 255),
    model = "models/bigsmoke/smoke.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_dbarrel", "weapon_camo"},
    command = "bigsmoke",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:61153481"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is TangoYeet's Custom Job."})

TEAM_MEMES_R_GUD = DarkRP.createJob("Memes R Gud", {
    color = Color(24, 116, 44, 255),
    model = "models/player/ianmata1998/whealteyii.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_dbarrel"},
    command = "memesrgud",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:0:94015044"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Taxiboy's Custom Job."})

TEAM_DR_ZOIDBERG = DarkRP.createJob("Dr. Zoidberg", {
    color = Color(191, 127, 255, 255),
    model = "models/zoidberg/zoidberg.mdl",
    description = [[]],
    weapons = {"pro_lockpick", "pro_keypad_cracker", "m9k_svu", "m9k_dbarrel", "blink"},
    command = "drzoidberg",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Custom Jobs",
    customCheck = function(ply) return CLIENT or
        table.HasValue({"STEAM_0:1:107349061"}, ply:SteamID())
    end,
    CustomCheckFailMsg = "This is Darcy's Custom Job."})
-- Custom Jobs End
