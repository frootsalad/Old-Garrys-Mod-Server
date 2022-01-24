    WEED_CONFIG = {}
--Only enable this in case gonzo asks it
WEED_CONFIG.Debug = false
WEED_CONFIG.WeedSpeed = 3
--Beeper price
WEED_CONFIG.BeeperPrice = 300
--How many weed does give a vial
WEED_CONFIG.VialAmount = 15
--Destroyable? greater than 0 to make stuff destroyable
WEED_CONFIG.ItemsHealth = 50
--Seconds between taking battery
WEED_CONFIG.LampDrain = 5
--How many water do we loss
WEED_CONFIG.WaterLoss = {1, 5}
--Every time weed grows, we have a chance to loss water, what's that chance
WEED_CONFIG.WaterLossChance = 70
--Waterizer power
WEED_CONFIG.WaterEffectiveness = 3
--How many seconds until tank gets 1%
WEED_CONFIG.WaterSourceSpeed = 0.25
--How many buckets can you load
WEED_CONFIG.WaterSourceBuckets = 50
--Charger reload rate
WEED_CONFIG.ReloadRate = 1
--Provider's tablet price
WEED_CONFIG.TabletPrice = 300
--Weed can purchase? //DISABLED BECAUSE POSSIBLE BAD USAGE/EXPLOIT
WEED_CONFIG.WeedPurchase = true
--Weed price -> Quantity
WEED_CONFIG.QuantityPrice = 0.75
--Weed price -> Quality
WEED_CONFIG.QualityPrice = 2
--Wweed price -> Sell
WEED_CONFIG.SellingPrice = 0.75
--Demo mode, no health and ultra fast growing
WEED_CONFIG.Demo = false

timer.Simple(1, function()
    --Jobs that CANT use this dealer
    WEED_CONFIG.AvoidJobs = {TEAM_POLICE, TEAM_CHEFPOLICE}
    WEED_CONFIG.Tablet = {TEAM_DEALER}
    --Jobs that CAN use this dealer, leave it blank so everyone can use it
    WEED_CONFIG.AbleJobs = {}
    --Give sniffers to the following jobs
    WEED_CONFIG.Sniffers = {TEAM_POLICE}
    --Use group data?
    WEED_CONFIG.UseGroupData = true

    --Groups data, {groupname,how many pots according every element players can have}
    WEED_CONFIG.GroupData = {
        user = 1,
        vip = 2.5,
        supervip = 5,
        admin = 10
    }

    --Custom function to check
    --If this is true, we'll override jobs check
    WEED_CONFIG.GoesFirst = true
    --Custom function to run
    WEED_CONFIG.Check = function(s, ply) return false end --Replace this to true in case you want to let everyone that's not on the avoidjobs list to use this end

    --Can use dealer
    function WEED_CONFIG:CanDeal(ply)
        if self.GoesFirst and self:Check(ply) then
            return true
        end

        if (table.HasValue(self.AvoidJobs, ply:Team())) then return false end
        if (table.HasValue(self.AbleJobs, ply:Team()) or #self.AbleJobs == 0) then return true end

        return self:Check(ply)
    end

    hook.Add("PlayerSpawn", "GiveSniffers", function(ply)
        if (table.HasValue(WEED_CONFIG.Sniffers, ply:Team()) and ply:IsPlayer() and isfunction(ply.Give)) then
            ply:Give("sent_sniffer")
        end
    end)

    hook.Add("OnPlayerChangedTeam", "RemoveSniffers", function(ply, b, t)
        if(SERVER) then
            ply:StripWeapon("sent_tablet")
            ply:StripWeapon("sent_sniffer")
            if(ply:HasWeapon("sent_tablet")) then
                ply:GetWeapon("sent_tablet"):Remove()
            end
        end
    end)
end)

--[[
if !(isnumber(t) && ply:IsPlayer() && isnumber(b)) then return end
if(SERVER && table.HasValue(WEED_CONFIG.Sniffers,t)) then
ply:Give("sent_sniffer")
end
]]
function _weedDebug(txt)
    if (WEED_CONFIG.Debug) then
        if (not file.Exists("weed_debug.txt", "DATA")) then
            file.Write("weed_debug.txt", "DEBUG FILE")
        end

        file.Append("weed_debug.txt", txt .. "\n")
    end
end
