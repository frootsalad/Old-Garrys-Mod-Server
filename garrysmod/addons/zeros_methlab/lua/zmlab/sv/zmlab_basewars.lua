if not SERVER then return end

local entTable = {
    ["zmlab_combiner"] = true,
    ["zmlab_collectcrate"] = true,
    ["zmlab_filter"] = true,
    ["zmlab_frezzer"] = true,
    ["zmlab_frezzingtray"] = true,
    ["zmlab_methylamin"] = true,
    ["zmlab_aluminium"] = true
}

hook.Add("BaseWars_PlayerBuyEntity", "zmlab_BaseWars_PlayerBuyEntity", function(ply, ent)
    --Check table of entities
    if entTable[ent:GetClass()] then
        zmlab.f.SetOwnerID(ent, ply)
    end
end)
