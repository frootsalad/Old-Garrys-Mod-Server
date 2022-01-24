-- [[------------------------]]
-- [[MGANGS Lang - EN - SHARED]]
-- [[Developed by Zephruz]]
-- [[------------------------]]

-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.

-- [[Register Language]]
local langID = "en" -- Language ID/Name

MGangs.Language:Register(langID)

--[[---------
  WORDS
-----------]]
MGangs.Language:AddTranslation(langID, "yes", "Yes")
MGangs.Language:AddTranslation(langID, "no", "No")
MGangs.Language:AddTranslation(langID, "to", "To")
MGangs.Language:AddTranslation(langID, "from", "From")
MGangs.Language:AddTranslation(langID, "other", "Other")
MGangs.Language:AddTranslation(langID, "name", "Name")
MGangs.Language:AddTranslation(langID, "page", "Page")
MGangs.Language:AddTranslation(langID, "set", "Set")
MGangs.Language:AddTranslation(langID, "save", "Save")
MGangs.Language:AddTranslation(langID, "settings", "Settings")
MGangs.Language:AddTranslation(langID, "delete", "Delete")
MGangs.Language:AddTranslation(langID, "submit", "Submit")
MGangs.Language:AddTranslation(langID, "admin", "Admin")
MGangs.Language:AddTranslation(langID, "edit", "Edit")
MGangs.Language:AddTranslation(langID, "cancel", "Cancel")
MGangs.Language:AddTranslation(langID, "leader", "Leader")
MGangs.Language:AddTranslation(langID, "gang", "Gang")
MGangs.Language:AddTranslation(langID, "invite", "Invite")
MGangs.Language:AddTranslation(langID, "general", "General")
MGangs.Language:AddTranslation(langID, "permissions", "Permissions")
MGangs.Language:AddTranslation(langID, "page", "Page")
MGangs.Language:AddTranslation(langID, "deny", "Deny")
MGangs.Language:AddTranslation(langID, "join", "Join")
MGangs.Language:AddTranslation(langID, "lvl", "Lvl")
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "deposit", "Deposit")
MGangs.Language:AddTranslation(langID, "withdraw", "Withdraw")
MGangs.Language:AddTranslation(langID, "options", "Options")
MGangs.Language:AddTranslation(langID, "priority", "Priority")
MGangs.Language:AddTranslation(langID, "refreshable", "Refreshable")

--[[---------
  PHRASES
-----------]]
MGangs.Language:AddTranslation(langID, "gang_icon_tootlip", "Must be a direct image link. (Example: http://zephruz.net/img/mgangs2_logo.png)")
MGangs.Language:AddTranslation(langID, "mustbe_number", "Must be a number!")
MGangs.Language:AddTranslation(langID, "fix_errors_please", "Fix the errors, please!")
MGangs.Language:AddTranslation(langID, "player_not_valid", "Player not valid!")
MGangs.Language:AddTranslation(langID, "player_ina_gang", "That player is in a gang!")
MGangs.Language:AddTranslation(langID, "you_cant_do_yet", "You can't do that yet!")
MGangs.Language:AddTranslation(langID, "you_cant_join_gang", "You can't join this gang!")
MGangs.Language:AddTranslation(langID, "youre_already_ina_gang", "You're already in a gang!")
MGangs.Language:AddTranslation(langID, "youre_not_ina_gang", "You're not in a gang!")
MGangs.Language:AddTranslation(langID, "you_invited_to_thegang", "You were invited to the gang %s!")
MGangs.Language:AddTranslation(langID, "search_results", "%s Result(s) for '%s'")
MGangs.Language:AddTranslation(langID, "search_results_took", "Took %s seconds")
MGangs.Language:AddTranslation(langID, "no_search_results", "No Results")
MGangs.Language:AddTranslation(langID, "search_for", "Search For")
MGangs.Language:AddTranslation(langID, "enter_search_criteria", "Enter your search criteria here")
MGangs.Language:AddTranslation(langID, "no_gang", "No Gang")
MGangs.Language:AddTranslation(langID, "refresh_gangs", "Refresh Gangs")
MGangs.Language:AddTranslation(langID, "search_gangs", "Search Gangs")
MGangs.Language:AddTranslation(langID, "search_fora_gang", "Search for a gang")
MGangs.Language:AddTranslation(langID, "search_gangs_criteria", "Type a name, gang id, etc. and press enter")
MGangs.Language:AddTranslation(langID, "edit_gangs", "Edit Gangs")
MGangs.Language:AddTranslation(langID, "deposit_amt", "Deposit amount")
MGangs.Language:AddTranslation(langID, "enter_deposit_amt", "Enter deposit amount")
MGangs.Language:AddTranslation(langID, "cant_deposit_amt", "You don't have that much money to deposit!")
MGangs.Language:AddTranslation(langID, "withdraw_amt", "Withdraw amount")
MGangs.Language:AddTranslation(langID, "enter_withdraw_amt", "Enter withdraw amount")
MGangs.Language:AddTranslation(langID, "cant_withdraw_amt", "Your gang doesn't have that much money to withdraw!")
MGangs.Language:AddTranslation(langID, "gang_information", "Gang Information")
MGangs.Language:AddTranslation(langID, "must_wait_seconds", "You must wait %s seconds, please stay near the flag!")
MGangs.Language:AddTranslation(langID, "you_want_to_do_this", "Are you sure you want to do this?")
MGangs.Language:AddTranslation(langID, "cant_afford_gang", "You can't afford to create a gang!")
MGangs.Language:AddTranslation(langID, "your_gang", "Your Gang")
MGangs.Language:AddTranslation(langID, "balance_disabled", "Balance disabled.")
MGangs.Language:AddTranslation(langID, "not_enough_balance", "Not enough balance!")
MGangs.Language:AddTranslation(langID, "invalid_balance_warn", "Invalid balance! (WARNING)")

-- Gang Invites
MGangs.Language:AddTranslation(langID, "gang_invites", "Gang Invites")
MGangs.Language:AddTranslation(langID, "search_invites", "Search Invites")
MGangs.Language:AddTranslation(langID, "search_invites_criteria", "Type a gang name, gang ID, etc. and press enter")

-- Gang Creation
MGangs.Language:AddTranslation(langID, "your_gang_created", "Your gang has successfully been created!")
MGangs.Language:AddTranslation(langID, "gang_create_fail_noleader", "Gang creation failed, no leader group set.")
MGangs.Language:AddTranslation(langID, "gang_create_fail", "Gang creation failed.")
MGangs.Language:AddTranslation(langID, "gang_created_group", "You've created a group!")

--[[Phrases: Gang (Admin/general)]]
MGangs.Language:AddTranslation(langID, "members_online", "Member(s) Online")
MGangs.Language:AddTranslation(langID, "members", "Members")
MGangs.Language:AddTranslation(langID, "search_members", "Search Members")
MGangs.Language:AddTranslation(langID, "search_members_criteria", "Type a player name, SteamID, etc. and press enter")

-- Gang Name
MGangs.Language:AddTranslation(langID, "gang_name", "Gang Name")
MGangs.Language:AddTranslation(langID, "gang_name_not_set_invalid", "Gang name was not set, invalid name.")
MGangs.Language:AddTranslation(langID, "gang_name_set", "Set gang name to %s!")
MGangs.Language:AddTranslation(langID, "name_not_allowed", "Name not allowed")
MGangs.Language:AddTranslation(langID, "enter_gang_name", "Enter gang name")

-- Gang ID Copying
MGangs.Language:AddTranslation(langID, "copy_gang_id", "Copy Gang ID")
MGangs.Language:AddTranslation(langID, "copied_gang_id", "Copied Gangs ID to clipboard!")

-- Gang Delete
MGangs.Language:AddTranslation(langID, "delete_this_gang_pmt", "Delete this gang?")
MGangs.Language:AddTranslation(langID, "gang_not_deleted", "Gang was not deleted.")
MGangs.Language:AddTranslation(langID, "gang_deleted", "Gang deleted!")

-- Gang Icon URL
MGangs.Language:AddTranslation(langID, "icon_url", "Icon URL")
MGangs.Language:AddTranslation(langID, "gang_icon_url", "Gang Icon URL")
MGangs.Language:AddTranslation(langID, "invalid_icon_url", "Invalid icon URL")
MGangs.Language:AddTranslation(langID, "enter_gang_icon_url", "Enter gang icon URL")
MGangs.Language:AddTranslation(langID, "gang_invalid_icon_url", "Gang icon URL was not set, invalid icon URL.")
MGangs.Language:AddTranslation(langID, "gang_icon_url_set", "Set gang icon URL to %s!")

-- Gang EXP
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "set_exp", "Set EXP")
MGangs.Language:AddTranslation(langID, "enter_exp", "Enter the desired EXP")
MGangs.Language:AddTranslation(langID, "gang_invalid_exp", "Gang EXP was not set, invalid EXP.")
MGangs.Language:AddTranslation(langID, "gang_exp_set", "Set gang EXP to %s!")

-- Gang Level
MGangs.Language:AddTranslation(langID, "level", "Level")
MGangs.Language:AddTranslation(langID, "set_level", "Set Level")
MGangs.Language:AddTranslation(langID, "enter_level", "Enter the desired level")
MGangs.Language:AddTranslation(langID, "gang_invalid_level", "Gang level was not set, invalid level.")
MGangs.Language:AddTranslation(langID, "gang_level_set", "Set gang level to %s!")
MGangs.Language:AddTranslation(langID, "gang_level_isnow", "Your gang is now level %s!")

-- Gang Balance
MGangs.Language:AddTranslation(langID, "balance", "Balance")
MGangs.Language:AddTranslation(langID, "set_balance", "Set Balance")
MGangs.Language:AddTranslation(langID, "enter_balance", "Enter the desired balance")
MGangs.Language:AddTranslation(langID, "gang_invalid_balance", "Gang balance was not set, invalid level.")
MGangs.Language:AddTranslation(langID, "gang_balance_set", "Set gang balance to %s!")

--[[Phrases: Player]]
-- Player Kick
MGangs.Language:AddTranslation(langID, "kick_from_gang", "Kick From Gang")
MGangs.Language:AddTranslation(langID, "kick_from_gang_pmt", "Kick from gang?")
MGangs.Language:AddTranslation(langID, "kicked_from_gang", "%s kicked from gang!")
MGangs.Language:AddTranslation(langID, "not_kicked_from_gang", "%s was not kicked from gang.")

-- Player (Set As) Leader
MGangs.Language:AddTranslation(langID, "as_leader", "As Leader")
MGangs.Language:AddTranslation(langID, "set_as_leader_pmt", "Set as gang leader?")
MGangs.Language:AddTranslation(langID, "set_as_leader", "%s set as leader!")
MGangs.Language:AddTranslation(langID, "not_set_as_leader", "%s was not set as leader.")

-- Player (Set) Gang
MGangs.Language:AddTranslation(langID, "set_gang", "Set Gang")
MGangs.Language:AddTranslation(langID, "enter_gang_id", "Enter Gang ID")
MGangs.Language:AddTranslation(langID, "player_added_to_gang", "%s added to gang %s!")
MGangs.Language:AddTranslation(langID, "player_not_added_to_gang", "%s was not added to gang!")

--[[Phrases: Admin]]
MGangs.Language:AddTranslation(langID, "back_to_admin", "Back to Admin")

--[[Phrases: Settings]]
-- Groups
MGangs.Language:AddTranslation(langID, "group_name", "Group Name")
MGangs.Language:AddTranslation(langID, "group_priority", "Group Priority")
MGangs.Language:AddTranslation(langID, "enter_group_priority", "Enter the group priority")
MGangs.Language:AddTranslation(langID, "enter_group_name", "Enter group name")
MGangs.Language:AddTranslation(langID, "create_group", "Create Group")
MGangs.Language:AddTranslation(langID, "edit_groups", "Edit Groups")
MGangs.Language:AddTranslation(langID, "save_groups", "Save Groups")
MGangs.Language:AddTranslation(langID, "group_icon", "Group Icon")
MGangs.Language:AddTranslation(langID, "updated_gang_groups", "Updated gang groups!")
MGangs.Language:AddTranslation(langID, "gang_groups", "Gang Groups")
MGangs.Language:AddTranslation(langID, "select_group_icon", "Select a group icon")

-- Players
MGangs.Language:AddTranslation(langID, "invite_players", "Invite Players")
MGangs.Language:AddTranslation(langID, "invite_player", "Invite Player")
MGangs.Language:AddTranslation(langID, "invite_failed", "Did not successfully send invite, please contact an administrator.")
MGangs.Language:AddTranslation(langID, "invited_player", "Successfully invited %s to the gang!")
MGangs.Language:AddTranslation(langID, "already_invited_player", "%s has already been invited!")
MGangs.Language:AddTranslation(langID, "search_players", "Search Players")
MGangs.Language:AddTranslation(langID, "search_players_pholder", "Type a name, SteamID, gang, etc. and press enter")
MGangs.Language:AddTranslation(langID, "edit_players", "Edit Players")

-- Misc
MGangs.Language:AddTranslation(langID, "back_to_settings", "Back to Settings")
MGangs.Language:AddTranslation(langID, "leave_gang", "Leave Gang")
MGangs.Language:AddTranslation(langID, "edit_gang", "Edit Gang")
MGangs.Language:AddTranslation(langID, "edit_gang_information", "Edit Gang Information")
MGangs.Language:AddTranslation(langID, "gang_administration", "Gang Administration")
MGangs.Language:AddTranslation(langID, "updated_gang_info", "Updated gang information!")

--[[Phrases: Gang Creation]]
MGangs.Language:AddTranslation(langID, "edit_default_groups", "Edit Default Groups")
MGangs.Language:AddTranslation(langID, "edit_groups_after_creation", "You can add new groups and edit group permission after your gang has been created.")
MGangs.Language:AddTranslation(langID, "review_and_finish", "Review & Finish")
MGangs.Language:AddTranslation(langID, "finish_gang_creation", "Finish Gang Creation")
MGangs.Language:AddTranslation(langID, "create_your_gang", "Create Your Gang")
MGangs.Language:AddTranslation(langID, "previous_step", "Previous Step")
MGangs.Language:AddTranslation(langID, "next_step", "Next Step")


--[[------------
  Module Translations
  - These are for the modules that come with MGangs 2
  - Any thirdparty modules translations will have to be translated within the module
--------------]]

--[[TERRITORIES]]
-- Territory Weapon/Creation
MGangs.Language:AddTranslation(langID, "territory_creator_info1_flag", "[Left Click] Place Flag")
MGangs.Language:AddTranslation(langID, "territory_creator_info1", "[Left Click + Hold] Draw the area")
MGangs.Language:AddTranslation(langID, "territory_creator_info2", "[Right Click] Save the area")
MGangs.Language:AddTranslation(langID, "territory_creator_info3", "[Reload] Reset the area")
MGangs.Language:AddTranslation(langID, "terr_doesnt_exist", "Territory doesn't exist!")
MGangs.Language:AddTranslation(langID, "terr_created", "Territory created!")
MGangs.Language:AddTranslation(langID, "terr_notcreated", "Failed to delete territory!")
MGangs.Language:AddTranslation(langID, "terr_deleted", "Deleted territory!")
MGangs.Language:AddTranslation(langID, "terr_notdeleted", "Failed to delete territory!")
MGangs.Language:AddTranslation(langID, "terr_updated", "Deleted territory!")
MGangs.Language:AddTranslation(langID, "terr_notupdated", "Failed to delete territory!")

-- Territory Flag
MGangs.Language:AddTranslation(langID, "someone_else_is_claiming", "Someone else is claming this!")
MGangs.Language:AddTranslation(langID, "cant_claim_own_territory", "You can't claim your own gangs territory!")
MGangs.Language:AddTranslation(langID, "cant_claim_territory", "This territory can't be claimed!")
MGangs.Language:AddTranslation(langID, "claimed_territory_for", "You've claimed the territory '%s' for your gang!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Your gangs territory '%s' is being claimed!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Your gangs territory '%s' is being claimed!")
MGangs.Language:AddTranslation(langID, "t_notclaming_dead", "You died! You're no-longer claming the territory.")
MGangs.Language:AddTranslation(langID, "t_notclaming_toofar", "You're no-longer claiming the territory, you've strayed too far.")
MGangs.Language:AddTranslation(langID, "terr_cantbuild", "You can't build in this territory, your gang must own it!")
MGangs.Language:AddTranslation(langID, "terr_youarein", "You are in the territory")

-- Menu
MGangs.Language:AddTranslation(langID, "territory", "Territory")
MGangs.Language:AddTranslation(langID, "territories", "Territories")
MGangs.Language:AddTranslation(langID, "search_territories", "Search Territories")
MGangs.Language:AddTranslation(langID, "search_territories_criteria", "Type a name, description, etc. and press enter")
MGangs.Language:AddTranslation(langID, "create_territory", "Create Territory")
MGangs.Language:AddTranslation(langID, "t_controlled_by", "Controlled By '%s'")
MGangs.Language:AddTranslation(langID, "t_being_claimed_by", "Being claimed by '%s'")
MGangs.Language:AddTranslation(langID, "t_currently_uncontrolled", "Currently uncontrolled")
MGangs.Language:AddTranslation(langID, "claim_territory_for_rewards", "Claim for rewards!")
MGangs.Language:AddTranslation(langID, "edit_territories", "Edit Territories")
MGangs.Language:AddTranslation(langID, "edit_territory", "Edit Territory")
MGangs.Language:AddTranslation(langID, "edit_territory_name", "Edit territory name")
MGangs.Language:AddTranslation(langID, "edit_territory_desc", "Edit territory description")
MGangs.Language:AddTranslation(langID, "terr_flagmodel", "Flag Model")

--[[GANGCHAT]]
MGangs.Language:AddTranslation(langID, "gc_message_wrongsize", "Message exceeds maximum (%s) / minimum (%s) length!")

--[[STASH]]
MGangs.Language:AddTranslation(langID, "stash", "Stash")
MGangs.Language:AddTranslation(langID, "back_to_stash", "Back to Stash")
MGangs.Language:AddTranslation(langID, "deposit_item", "Deposit Item")
MGangs.Language:AddTranslation(langID, "search_items", "Search Items")
MGangs.Language:AddTranslation(langID, "search_items_criteria", "Type a name, class, etc. and press enter")

--[[ASSOCIATIONS]]
MGangs.Language:AddTranslation(langID, "associations", "Associations")
MGangs.Language:AddTranslation(langID, "active_associations", "Active Associations")
MGangs.Language:AddTranslation(langID, "already_at_war_with", "You're already at war with %s!")
MGangs.Language:AddTranslation(langID, "not_at_war_with", "You're not at war with %s!")
MGangs.Language:AddTranslation(langID, "cant_start_war_with", "You can't start a war with %s!")
MGangs.Language:AddTranslation(langID, "war_startend_with", "War %s with %s!")
MGangs.Language:AddTranslation(langID, "ass_cant_set_owngang", "You can't set an association with your own gang!")
MGangs.Language:AddTranslation(langID, "at_war_with_gang", "You're at war with them!")
MGangs.Language:AddTranslation(langID, "now_ass_with", "We are now %s with %s!")
MGangs.Language:AddTranslation(langID, "set_gang_ass_to", "Set %s to %s!")

--[[ACHIEVEMENTS]]
MGangs.Language:AddTranslation(langID, "achievements", "Achievements")
MGangs.Language:AddTranslation(langID, "ach_already_complete", "Achievement already complete.")
MGangs.Language:AddTranslation(langID, "ach_exists_set", "Achievement (%s) exists, set.")

--[[RANKINGS]]
MGangs.Language:AddTranslation(langID, "rankings", "Rankings")
MGangs.Language:AddTranslation(langID, "refresh_ranks", "Refresh Ranks")
MGangs.Language:AddTranslation(langID, "ranks_refreshes_in", "Refreshes in %s")

--[[UPGRADES]]
MGangs.Language:AddTranslation(langID, "upgrades", "Upgrades")
MGangs.Language:AddTranslation(langID, "upgrade", "Upgrade")
MGangs.Language:AddTranslation(langID, "upgrade_current", "Current: %s")
MGangs.Language:AddTranslation(langID, "upgrade_next", "Next: %s")
MGangs.Language:AddTranslation(langID, "upgrade_exists", "Upgrade already exists!")
MGangs.Language:AddTranslation(langID, "upgrade_invalidtype", "Invalid upgrade type!")
MGangs.Language:AddTranslation(langID, "upgrade_purchased", "Purchased upgrade!")
MGangs.Language:AddTranslation(langID, "upgraded_to", "Upgraded %s to %s!")
MGangs.Language:AddTranslation(langID, "upg_invalid_amtgangid", "Invalid amount (%s) or gangid (%s).")
MGangs.Language:AddTranslation(langID, "upg_bal_cantdeposit", "You can't deposit that much money!")
MGangs.Language:AddTranslation(langID, "upg_stash_invalid_itemgangid", "Invalid item (%s) or gangid (%s).")
MGangs.Language:AddTranslation(langID, "upg_stash_cantdeposit", "You can't deposit any more items!")
MGangs.Language:AddTranslation(langID, "upg_gang_memberfull", "You can't join that gang because it's full!")
