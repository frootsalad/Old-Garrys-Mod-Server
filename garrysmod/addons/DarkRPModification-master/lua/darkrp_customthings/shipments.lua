--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

-- Pistols

DarkRP.createShipment("Python", {
    model = "models/weapons/w_colt_python.mdl",
    entity = "m9k_coltpython",
    price = 6000,
    amount = 10,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Colt 1911", {
    model = "models/weapons/s_dmgf_co1911.mdl",
    entity = "m9k_colt1911",
    price = 3500,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("HK 45C", {
    model = "models/weapons/w_hk45c.mdl",
    entity = "m9k_hk45",
    price = 2500,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
}) 

DarkRP.createShipment("Luger", {
    model = "models/weapons/w_luger_p08.mdl",
    entity = "m9k_luger",
    price = 5000,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("Raging Bull", {
    model = "models/weapons/w_taurus_raging_bull.mdl",
    entity = "m9k_ragingbull",
    price = 6000,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})  

DarkRP.createShipment("S&W 500", {
    model = "models/weapons/w_sw_model_500.mdl",
    entity = "m9k_model500",
    price = 5500,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})  

DarkRP.createShipment("M29 Satan", {
    model = "models/weapons/w_m29_satan.mdl",
    entity = "m9k_m29satan",
    price = 7500,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})  

   
DarkRP.createShipment("Beretta", {
    model = "models/weapons/w_beretta_m92.mdl",
    entity = "m9k_m92beretta",
    price = 3200,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
   
DarkRP.createShipment("S&W Model 3 Russian", {
    model = "models/weapons/w_model_3_rus.mdl",
    entity = "m9k_model3russian",
    price = 4000,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})  

DarkRP.createShipment("S&W 627", {
    model = "models/weapons/w_sw_model_627.mdl",
    entity = "m9k_model627",
    price = 3500,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

-- Shotguns


DarkRP.createShipment("M3", {
        model = "models/weapons/w_benelli_m3.mdl",
        entity = "m9k_m3",
        price = 40000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Browning Auto", {
        model = "models/weapons/w_browning_auto.mdl",
        entity = "m9k_browningauto5",
        price = 70000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Double Barrel Shotgun", {
        model = "models/weapons/w_double_barrel_shotgun.mdl",
        entity = "m9k_dbarrel",
        price = 100000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Ithaca 37", {
        model = "models/weapons/w_ithaca_m37.mdl",
        entity = "m9k_ithacam37",
        price = 65000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Mossberg 590", {
        model = "models/weapons/w_mossberg_590.mdl",
        entity = "m9k_mossberg590",
        price = 60000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Pancor Jackhammer", {
        model = "models/weapons/w_pancor_jackhammer.mdl",
        entity = "m9k_jackhammer",
        price = 120000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Remington-870", {
        model = "models/weapons/w_remington_870_tact.mdl",
        entity = "m9k_remington870",
        price = 62000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Spas-12", {
        model = "models/weapons/w_spas_12.mdl",
        entity = "m9k_spas12",
        price = 110000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Striker-12", {
        model = "models/weapons/w_striker_12g.mdl",
        entity = "m9k_striker12",
        price = 125000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("USAS", {
        model = "models/weapons/w_usas_12.mdl",
        entity = "m9k_usas",
        price = 125000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Winchester-1897", {
        model = "models/weapons/w_winchester_1897_trench.mdl",
        entity = "m9k_1897winchester",
        price = 55000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Winchester-1887", {
        model = "models/weapons/w_winchester_1887.mdl",
        entity = "m9k_1887winchester",
        price = 55000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})


-- Subs


DarkRP.createShipment("Bizon P19", {
        model = "models/weapons/w_pp19_bizon.mdl",
        entity = "m9k_bizonp19",
        price = 35500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
       
DarkRP.createShipment("FM P90", {
        model = "models/weapons/w_fn_p90.mdl",
        entity = "m9k_smgp90",
        price = 47500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("HK MP5", {
        model = "models/weapons/w_hk_mp5.mdl",
        entity = "m9k_mp5",
        price = 37500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("HK MP7", {
        model = "models/weapons/w_mp7_silenced.mdl",
        entity = "m9k_mp7",
        price = 45500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("HK UMP45", {
        model = "models/weapons/w_hk_ump45.mdl",
        entity = "m9k_ump45",
        price = 45000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("HK USC", {
        model = "models/weapons/w_hk_usc.mdl",
        entity = "m9k_usc",
        price = 32500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("KAC PDW", {
        model = "models/weapons/w_kac_pdw.mdl",
        entity = "m9k_kac_pdw",
        price = 42500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("KRISS Vector", {
        model = "models/weapons/w_kriss_vector.mdl",
        entity = "m9k_vector",
        price = 38000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Magpul PDR", {
        model = "models/weapons/w_magpul_pdr.mdl",
        entity = "m9k_magpulpdr",
        price = 32500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("MP40", {
        model = "models/weapons/w_mp40smg.mdl",
        entity = "m9k_mp40",
        price = 30000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("MP5 SD", {
        model = "models/weapons/w_hk_mp5sd.mdl",
        entity = "m9k_mp5sd",
        price = 36000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Sten", {
        model = "models/weapons/w_sten.mdl",
        entity = "m9k_sten",
        price = 32500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Tec-9", {
        model = "models/weapons/w_intratec_tec9.mdl",
        entity = "m9k_tec9",
        price = 30500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Tommy Gun", {
        model = "models/weapons/w_tommy_gun.mdl",
        entity = "m9k_thompson",
        price = 30500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Uzi", {
        model = "models/weapons/w_uzi_imi.mdl",
        entity = "m9k_uzi",
        price = 34000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

-- ARs
       
DarkRP.createShipment("ACR", {
        model = "models/weapons/w_masada_acr.mdl",
        entity = "m9k_acr",
        price = 62000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("AK-47", {
        model = "models/weapons/w_ak47_m9k.mdl",
        entity = "m9k_ak47",
        price = 61000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("AK-74", {
        model = "models/weapons/w_tct_ak47.mdl",
        entity = "m9k_ak74",
        price = 64000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("AMD-65", {
    model = "models/weapons/w_amd_65.mdl",
    entity = "m9k_amd65",
    price = 65000,
    amount = 10,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Winchester-73", {
        model = "models/weapons/w_winchester_1873.mdl",
        entity = "m9k_winchester73",
        price = 72000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("AMD-65", {
        model = "models/weapons/w_amd_65.mdl",
        entity = "m9k_amd65",
        price = 75000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("An-94", {
        model = "models/weapons/w_rif_an_94.mdl",
        entity = "m9k_an94",
        price = 62500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("AS VAL", {
        model = "models/weapons/w_dmg_vally.mdl",
        entity = "m9k_val",
        price = 62500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("F-2000", {
        model = "models/weapons/w_fn_f2000.mdl",
        entity = "m9k_f2000",
        price = 67500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Famas", {
        model = "models/weapons/w_tct_famas.mdl",
        entity = "m9k_famas",
        price = 52500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("FN-FAL", {
        model = "models/weapons/w_fn_fal.mdl",
        entity = "m9k_fal",
        price = 75000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("G-36", {
        model = "models/weapons/w_hk_g36c.mdl",
        entity = "m9k_g36",
        price = 65500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M-416", {
        model = "models/weapons/w_hk_416.mdl",
        entity = "m9k_m416",
        price = 65500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("HK G3A3", {
        model = "models/weapons/w_hk_g3.mdl",
        entity = "m9k_g3a3",
        price = 57500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("L-85", {
        model = "models/weapons/w_l85a2.mdl",
        entity = "m9k_l85",
        price = 65000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("M-14", {
        model = "models/weapons/w_snip_m14sp.mdl",
        entity = "m9k_m14sp",
        price = 77500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M16A4", {
        model = "models/weapons/w_dmg_m16ag.mdl",
        entity = "m9k_m16a4_acog",
        price = 68000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M4A1", {
        model = "models/weapons/w_m4a1_iron.mdl",
        entity = "m9k_m4a1",
        price = 67000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Scar-H", {
        model = "models/weapons/w_fn_scar_h.mdl",
        entity = "m9k_scar",
        price = 85000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("S3-3M Vikhir", {
        model = "models/weapons/w_dmg_vikhr.mdl",
        entity = "m9k_vikhr",
        price = 52500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Aug-A3", {
        model = "models/weapons/w_auga3.mdl",
        entity = "m9k_auga3",
        price = 57000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Tar-21", {
        model = "models/weapons/w_imi_tar21.mdl",
        entity = "m9k_tar21",
        price = 81000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M1918 Bar", {
        model = "models/weapons/w_m1918_bar.mdl",
        entity = "m9k_m1918bar",
        price = 67500,
        amount = 5,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

-- Snipers

 DarkRP.createShipment("AW-50", {
        model = "models/weapons/w_acc_int_aw50.mdl",
        entity = "m9k_aw50",
        price = 105000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Barret-M82", {
        model = "models/weapons/w_barret_m82.mdl",
        entity = "m9k_barret_m82",
        price = 127500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("M98b", {
        model = "models/weapons/w_barrett_m98b.mdl",
        entity = "m9k_m98b",
        price = 122500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Dragonuv SVU", {
        model = "models/weapons/w_dragunov_svu.mdl",
        entity = "m9k_svu",
        price = 155000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Sl8", {
        model = "models/weapons/w_hk_sl8.mdl",
        entity = "m9k_sl8",
        price = 130000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Intervention", {
        model = "models/weapons/w_snip_int.mdl",
        entity = "m9k_intervention",
        price = 135000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M-24", {
        model = "models/weapons/w_snip_m24_6.mdl",
        entity = "m9k_m24",
        price = 145000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
 DarkRP.createShipment("Remington 7615p", {
        model = "models/weapons/w_remington_7615p.mdl",
        entity = "m9k_remington7615p",
        price = 115000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_LIGHT_ARMS_DEALER, TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("PSG-1", {
        model = "models/weapons/w_hk_psg1.mdl",
        entity = "m9k_psg1",
        price = 135000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Dragunov", {
        model = "models/weapons/w_svd_dragunov.mdl",
        entity = "m9k_dragunov",
        price = 127500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("SVT 40", {
        model = "models/weapons/w_svt_40.mdl",
        entity = "m9k_svt40",
        price = 13500,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
       
DarkRP.createShipment("Contender", {
        model = "models/weapons/w_g2_contender.mdl",
        entity = "m9k_contender",
        price = 145000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})


-- Heavy

DarkRP.createShipment("PKM", {
    model = "models/weapons/w_mach_russ_pkm.mdl",
    entity = "m9k_pkm",
    price = 185000,
    amount = 3,
    seperate = false,
    pricesep = 500,
    noship = false,
    allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("Ares Shrike", {
        model = "models/weapons/w_ares_shrike.mdl",
        entity = "m9k_ares_shrike",
        price = 190000,
        amount = 3,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("FG-42", {
        model = "models/weapons/w_fg42.mdl",
        entity = "m9k_fg42",
        price = 175000,
        amount = 5,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M60", {
        model = "models/weapons/w_m60_machine_gun.mdl",
        entity = "m9k_m60",
        price = 185000,
        amount = 3,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("M-249", {
        model = "models/weapons/w_m249_machine_gun.mdl",
        entity = "m9k_m249lmg",
        price = 180000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
 
DarkRP.createShipment("PKM", {
        model = "models/weapons/w_mach_russ_pkm.mdl",
        entity = "m9k_pkm",
        price = 195000,
        amount = 10,
        seperate = false,
        pricesep = 500,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("Flashbang", {
        model = "models/shenesis/w_flashbang.mdl",
        entity = "weapon_sh_flashbang",
        price = 85000,
        amount = 1,
        seperate = false,
        pricesep = 10000,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("Frag Grenade", {
        model = "models/weapons/w_m61_fraggynade.mdl",
        entity = "m9k_m61_frag",
        price = 750000,
        amount = 3,
        seperate = false,
        pricesep = 750000,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})

DarkRP.createShipment("Gas Mask", {
        model = "models/gasmasks/m40.mdl",
        entity = "item_sh_gasmask",
        price = 10000,
        amount = 1,
        seperate = false,
        pricesep = 1000000,
        noship = false,
        allowed = {TEAM_HEAVY_ARMS_DEALER, TEAM_BURNED_MAN}
})
