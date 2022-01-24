-- [[------------------------]]
-- [[MGANGS Lang - GE - SHARED]]
-- [[Translated by [Ventix] Riveq]]
-- [[------------------------]]

-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.

-- [[Register Language]]
local langID = "ge" -- Language ID/Name

MGangs.Language:Register(langID)

--[[---------
  WORDS
-----------]]
MGangs.Language:AddTranslation(langID, "yes", "Ja")
MGangs.Language:AddTranslation(langID, "no", "Nein")
MGangs.Language:AddTranslation(langID, "name", "Name")
MGangs.Language:AddTranslation(langID, "page", "Seite")
MGangs.Language:AddTranslation(langID, "set", "Setzen")
MGangs.Language:AddTranslation(langID, "save", "Speichern")
MGangs.Language:AddTranslation(langID, "settings", "Einstellungen")
MGangs.Language:AddTranslation(langID, "delete", "Löschen")
MGangs.Language:AddTranslation(langID, "submit", "Einreichen")
MGangs.Language:AddTranslation(langID, "admin", "Admin")
MGangs.Language:AddTranslation(langID, "edit", "Editieren")
MGangs.Language:AddTranslation(langID, "cancel", "Abbrechen")
MGangs.Language:AddTranslation(langID, "leader", "Leiter")
MGangs.Language:AddTranslation(langID, "gang", "Gang")
MGangs.Language:AddTranslation(langID, "invite", "Einladen")
MGangs.Language:AddTranslation(langID, "general", "General")
MGangs.Language:AddTranslation(langID, "permissions", "Rechte")
MGangs.Language:AddTranslation(langID, "page", "Seite")
MGangs.Language:AddTranslation(langID, "deny", "Verweigern")
MGangs.Language:AddTranslation(langID, "join", "Beitreten")
MGangs.Language:AddTranslation(langID, "lvl", "Lvl")
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "deposit", "Einzahlen")
MGangs.Language:AddTranslation(langID, "withdraw", "Auszahlen")
MGangs.Language:AddTranslation(langID, "options", "Optionen")
MGangs.Language:AddTranslation(langID, "priority", "Priorität")

--[[---------
  PHRASES
-----------]]
MGangs.Language:AddTranslation(langID, "gang_icon_tootlip", "Es muss ein direkter Bildlink sein. (Beispiel: https://image.prntscr.com/image/XE850PF2RtCT0xNYOxucCA.png)")
MGangs.Language:AddTranslation(langID, "mustbe_number", "Es muss eine Nummer sein!")
MGangs.Language:AddTranslation(langID, "fix_errors_please", "Behebe die Fehler, bitte!")
MGangs.Language:AddTranslation(langID, "player_not_valid", "Der Spieler gibt es nicht!")
MGangs.Language:AddTranslation(langID, "player_ina_gang", "Dieser Spieler ist bereits in einer Gang!")
MGangs.Language:AddTranslation(langID, "you_cant_do_yet", "Du kannst dies nicht tun!")
MGangs.Language:AddTranslation(langID, "you_cant_join_gang", "Du kann dieser Gang nicht beitreten!")
MGangs.Language:AddTranslation(langID, "youre_already_ina_gang", "Du bist bereits in einer Gang!")
MGangs.Language:AddTranslation(langID, "youre_not_ina_gang", "Du bist in keiner Gang!")
MGangs.Language:AddTranslation(langID, "you_invited_to_thegang", "Du wurdest in die Gang %s eingeladen!")
MGangs.Language:AddTranslation(langID, "search_results", "%s Ergenis(se) für '%s'")
MGangs.Language:AddTranslation(langID, "search_results_took", "Es dauerte %s Sekunden")
MGangs.Language:AddTranslation(langID, "no_search_results", "Kein Ergebnis")
MGangs.Language:AddTranslation(langID, "search_for", "Suchen nach")
MGangs.Language:AddTranslation(langID, "enter_search_criteria", "Gib deine Suchtkriterien ein")
MGangs.Language:AddTranslation(langID, "no_gang", "Keine Gang")
MGangs.Language:AddTranslation(langID, "refresh_gangs", "Aktualiesiere Gangliste")
MGangs.Language:AddTranslation(langID, "search_gangs", "Suche Gangs")
MGangs.Language:AddTranslation(langID, "search_gangs_criteria", "Gib ein Gang Namen ein, eine Gangid, etc. und drücke Enter anschließend.")
MGangs.Language:AddTranslation(langID, "edit_gangs", "Editiere Gangs")
MGangs.Language:AddTranslation(langID, "deposit_amt", "Geld einzahlen")
MGangs.Language:AddTranslation(langID, "enter_deposit_amt", "Gebe dein Betrag ab um einzuzahlen.")
MGangs.Language:AddTranslation(langID, "cant_deposit_amt", "Du hast nicht soviel Geld, um es einzuzahlen!")
MGangs.Language:AddTranslation(langID, "withdraw_amt", "Geld abheben")
MGangs.Language:AddTranslation(langID, "enter_withdraw_amt", "Gebe dein Betrag ab um abzuheben")
MGangs.Language:AddTranslation(langID, "cant_withdraw_amt", "Deine Gang hat nicht so viel Geld, um es abzuheben!")
MGangs.Language:AddTranslation(langID, "gang_information", "Gang Information")
MGangs.Language:AddTranslation(langID, "must_wait_seconds", "Du musst %s Sekunden warten, bitte warte und steh nah an der Flagge!")
MGangs.Language:AddTranslation(langID, "you_want_to_do_this", "Bist du dir sicher dies zutun?")
MGangs.Language:AddTranslation(langID, "cant_afford_gang", "Du kannst es dir nicht leisten eine Gang zugründen!")

-- Gang Invites
MGangs.Language:AddTranslation(langID, "gang_invites", "Gang Einladungen")
MGangs.Language:AddTranslation(langID, "search_invites", "Suche nach Einladung")
MGangs.Language:AddTranslation(langID, "search_invites_criteria", "Gib ein Gang Namen ein, eine Gangid, etc. und drücke Enter anschließend.")

-- Gang Creation
MGangs.Language:AddTranslation(langID, "your_gang_created", "Deine Gang wurde erfolgreich erstellt!")
MGangs.Language:AddTranslation(langID, "gang_create_fail_noleader", "Gang erstellung fehlgeschlagen, es wurde keine Leitungsgruppe erkannt.")
MGangs.Language:AddTranslation(langID, "gang_create_fail", "Gang erstellung fehlgeschlagen.")
MGangs.Language:AddTranslation(langID, "gang_created_group", "You've created a group!")

--[[Phrases: Gang (Admin/general)]]
MGangs.Language:AddTranslation(langID, "members_online", "Mitglied(er) Online")
MGangs.Language:AddTranslation(langID, "members", "Mitglieder")
MGangs.Language:AddTranslation(langID, "search_members", "Suche Mitglieder")
MGangs.Language:AddTranslation(langID, "search_members_criteria", "Gebe Spielername ein, SteamID, etc. und drücke Enter anschließend.")

-- Gang Name
MGangs.Language:AddTranslation(langID, "gang_name", "Gang Name")
MGangs.Language:AddTranslation(langID, "gang_name_not_set_invalid", "Gang Name wurde nicht gesetzt, ungültiger Name.")
MGangs.Language:AddTranslation(langID, "gang_name_set", "Setzte Gang Name zu %s!")
MGangs.Language:AddTranslation(langID, "name_not_allowed", "Gang Name ist nicht erlaubt")
MGangs.Language:AddTranslation(langID, "enter_gang_name", "Gebe Gang Name ein")

-- Gang ID Copying
MGangs.Language:AddTranslation(langID, "copy_gang_id", "Copy Gang ID")
MGangs.Language:AddTranslation(langID, "copied_gang_id", "Kopiere Gang ID in die Zwischenablage!")

-- Gang Delete
MGangs.Language:AddTranslation(langID, "delete_this_gang_pmt", "Möchtest du wirklick diese Gang löschen?")
MGangs.Language:AddTranslation(langID, "gang_not_deleted", "Gang wurde nicht gelöscht.")
MGangs.Language:AddTranslation(langID, "gang_deleted", "Gang wurde gelöscht!")

-- Gang Icon URL
MGangs.Language:AddTranslation(langID, "icon_url", "Symbol URL")
MGangs.Language:AddTranslation(langID, "gang_icon_url", "Gang Symbol URL")
MGangs.Language:AddTranslation(langID, "invalid_icon_url", "Ungültige URL")
MGangs.Language:AddTranslation(langID, "enter_gang_icon_url", "Gebe eine URL ein (Beispiel https://image.prntscr.com/image/XE850PF2RtCT0xNYOxucCA.png)")
MGangs.Language:AddTranslation(langID, "gang_invalid_icon_url", "Gang Symbol URL wurde nicht gesetzt, ungültige URL.")
MGangs.Language:AddTranslation(langID, "gang_icon_url_set", "Setze Symbol URL zu %s!")

-- Gang EXP
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "set_exp", "Setze EXP")
MGangs.Language:AddTranslation(langID, "enter_exp", "Gebe das gewünschte EXP ein")
MGangs.Language:AddTranslation(langID, "gang_invalid_exp", "Gang EXP wurden icht gesetzt, ungültige EXP.")
MGangs.Language:AddTranslation(langID, "gang_exp_set", "Setze Gang EXP zu %s!")

-- Gang Level
MGangs.Language:AddTranslation(langID, "level", "Level")
MGangs.Language:AddTranslation(langID, "set_level", "Setze Level")
MGangs.Language:AddTranslation(langID, "enter_level", "Gebe das gewünschte Level ein")
MGangs.Language:AddTranslation(langID, "gang_invalid_level", "Gang Level wurde nicht gesetzt, ungültige Level.")
MGangs.Language:AddTranslation(langID, "gang_level_set", "Setze Gang Level zu %s!")
MGangs.Language:AddTranslation(langID, "gang_level_isnow", "Deine Gang ist nun Level %s!")

-- Gang Balance
MGangs.Language:AddTranslation(langID, "balance", "Balance")
MGangs.Language:AddTranslation(langID, "set_balance", "Set Balance")
MGangs.Language:AddTranslation(langID, "enter_balance", "Enter the desired balance")
MGangs.Language:AddTranslation(langID, "gang_invalid_balance", "Gang balance was not set, invalid Level.")
MGangs.Language:AddTranslation(langID, "gang_balance_set", "Set gang balance to %s!")

--[[Phrases: Player]]
-- Player Kick
MGangs.Language:AddTranslation(langID, "kick_from_gang", "Werfe aus der Gang heraus")
MGangs.Language:AddTranslation(langID, "kick_from_gang_pmt", "Werfe ihn aus der Gang raus?")
MGangs.Language:AddTranslation(langID, "kicked_from_gang", "%s wurde aus der Gang rausgeworfen!")
MGangs.Language:AddTranslation(langID, "not_kicked_from_gang", "%s wurde nicht aus der Gang geworfen.")

-- Player (Set As) Leader
MGangs.Language:AddTranslation(langID, "as_leader", "Setze als Anführer")
MGangs.Language:AddTranslation(langID, "set_as_leader_pmt", "Möchtest du ihn als Anführer setzten?")
MGangs.Language:AddTranslation(langID, "set_as_leader", "%s wurde als Anführer gesetzt!")
MGangs.Language:AddTranslation(langID, "not_set_as_leader", "%s wurde nicht als Anführer gesetzt.")

-- Player (Set) Gang
MGangs.Language:AddTranslation(langID, "set_gang", "Setze Gang")
MGangs.Language:AddTranslation(langID, "enter_gang_id", "Gebe Gang ID ein")
MGangs.Language:AddTranslation(langID, "player_added_to_gang", "%s fügte zur Gang %s hinzu!")
MGangs.Language:AddTranslation(langID, "player_not_added_to_gang", "%s wurde nicht zur Gang hinzugefügt!")

--[[Phrases: Admin]]
MGangs.Language:AddTranslation(langID, "back_to_admin", "Zurück zu Admin")

--[[Phrases: Settings]]
-- Groups
MGangs.Language:AddTranslation(langID, "group_name", "Gruppenname")
MGangs.Language:AddTranslation(langID, "group_priority", "Gruppenpriorität")
MGangs.Language:AddTranslation(langID, "enter_group_priority", "Gebe die Gruppenpriorität ein")
MGangs.Language:AddTranslation(langID, "enter_group_name", "Gebe den Gruppenname ein")
MGangs.Language:AddTranslation(langID, "create_group", "Erstell die Gruppe")
MGangs.Language:AddTranslation(langID, "edit_groups", "Editiere die Gruppe")
MGangs.Language:AddTranslation(langID, "save_groups", "Speicher die Gruppe")
MGangs.Language:AddTranslation(langID, "group_icon", "Gruppen Symbol")
MGangs.Language:AddTranslation(langID, "updated_gang_groups", "Aktualisierte Gang Gruppen!")
MGangs.Language:AddTranslation(langID, "gang_groups", "Gang Gruppen")
MGangs.Language:AddTranslation(langID, "select_group_icon", "Wähle ein Gang Symbol aus")

-- Players
MGangs.Language:AddTranslation(langID, "invite_players", "Spieler einladen")
MGangs.Language:AddTranslation(langID, "invite_player", "Spieler einladen")
MGangs.Language:AddTranslation(langID, "invite_failed", "Einladung konnte nicht erfolgreich gesendet werden, bitte kontaktiere einen Administrator!")
MGangs.Language:AddTranslation(langID, "invited_player", "%s wurde in die Gang eingeladen!")
MGangs.Language:AddTranslation(langID, "already_invited_player", "%s wurde bereits in die Gang eingeladen!")
MGangs.Language:AddTranslation(langID, "search_players", "Suche Spieler")
MGangs.Language:AddTranslation(langID, "search_players_pholder", "Gebe Namen ein, SteamID, Gang, etc. und gebe Enter ein anschließend")
MGangs.Language:AddTranslation(langID, "edit_players", "Editiere Spieler")

-- Misc
MGangs.Language:AddTranslation(langID, "back_to_settings", "Zurück zu Einstellungen")
MGangs.Language:AddTranslation(langID, "leave_gang", "Verlasse Gang")
MGangs.Language:AddTranslation(langID, "edit_gang", "Editiere Gang")
MGangs.Language:AddTranslation(langID, "edit_gang_information", "Editiere Gang Information")
MGangs.Language:AddTranslation(langID, "gang_administration", "Gang Administration")
MGangs.Language:AddTranslation(langID, "updated_gang_info", "Informationen zu Gang aktualisiert!!")

--[[Phrases: Gang Creation]]
MGangs.Language:AddTranslation(langID, "edit_default_groups", "Editiere Standardgruppen")
MGangs.Language:AddTranslation(langID, "edit_groups_after_creation", "Du kannst neue Gruppen erstellen/verwalten nachder Gang erstellung.")
MGangs.Language:AddTranslation(langID, "review_and_finish", "Vorschau & Fertig")
MGangs.Language:AddTranslation(langID, "finish_gang_creation", "Beende die Gang erstellung")
MGangs.Language:AddTranslation(langID, "create_your_gang", "Erstell deine Gang")
MGangs.Language:AddTranslation(langID, "previous_step", "Vorheriger Schritt")
MGangs.Language:AddTranslation(langID, "next_step", "Nächster Schritt")


--[[------------
  Module Translations
  - These are for the modules that come with MGangs 2
  - Any thirdparty modules translations will have to be translated within the module
--------------]]

--[[TERRITORIES]]
-- Territory Weapon/Creation
MGangs.Language:AddTranslation(langID, "territory_creator_info1_flag", "[Linksklick] Platziere Flagge")
MGangs.Language:AddTranslation(langID, "territory_creator_info1", "[Linksklick + Hold] Zeichne den Bereich ein")
MGangs.Language:AddTranslation(langID, "territory_creator_info2", "[Rechtsklick] Speicher den Bereich")
MGangs.Language:AddTranslation(langID, "territory_creator_info3", "[Reload] Setzen Sie den Bereich zurück")
MGangs.Language:AddTranslation(langID, "terr_doesnt_exist", "Territorium existiert nicht!")
MGangs.Language:AddTranslation(langID, "terr_created", "Territorium erstellt")
MGangs.Language:AddTranslation(langID, "terr_notcreated", "Löschen des Territorium fehlgeschlagen!")
MGangs.Language:AddTranslation(langID, "terr_deleted", "Territorium gelöscht!")
MGangs.Language:AddTranslation(langID, "terr_notdeleted", "Löschen des Territorium fehlgeschlagen!")
MGangs.Language:AddTranslation(langID, "terr_updated", "Territorium gelöscht!")
MGangs.Language:AddTranslation(langID, "terr_notupdated", "Löschen des Territorium fehlgeschlagen!")

-- Territory Flag
MGangs.Language:AddTranslation(langID, "someone_else_is_claiming", "Ein andere Gang nimmt gerade dieses Territorium ein!")
MGangs.Language:AddTranslation(langID, "cant_claim_own_territory", "Du kannst nicht deine eigenen Territoriums einnehmen!")
MGangs.Language:AddTranslation(langID, "cant_claim_territory", "Dieses Territorium kann nicht eingenommen werden!")
MGangs.Language:AddTranslation(langID, "claimed_territory_for", "Du hast das Territorium '%s' für deine Gang eingenommen!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Dein Gang Territorium '%s' wird gerade eingenommen!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Dein Gang Territorium '%s' wird gerade eingenommen!")
MGangs.Language:AddTranslation(langID, "t_notclaming_dead", "Du bist gestorben! Du nimmst nicht mehr das Territorium ein.")
MGangs.Language:AddTranslation(langID, "t_notclaming_toofar", "Du nimmst mehr das Territorium ein, weil du zu weit wegstehst.")
MGangs.Language:AddTranslation(langID, "terr_cantbuild", "Du kannst in diesen Territorium nicht bauen, ihr müsst es zuerst einnehmen!")

-- Menu
MGangs.Language:AddTranslation(langID, "territory", "Territoriums")
MGangs.Language:AddTranslation(langID, "territories", "Territoriums")
MGangs.Language:AddTranslation(langID, "search_territories", "Suche nach Territoriums")
MGangs.Language:AddTranslation(langID, "search_territories_criteria", "Tippe Name, Beschreibung, etc. ein und drücke Enter anschließend.")
MGangs.Language:AddTranslation(langID, "create_territory", "Erstellt Territorium")
MGangs.Language:AddTranslation(langID, "t_controlled_by", "Kontrolliert von '%s'")
MGangs.Language:AddTranslation(langID, "t_being_claimed_by", "Wird erobert von '%s'")
MGangs.Language:AddTranslation(langID, "t_currently_uncontrolled", "Derzeitig nicht kontrolliert!")
MGangs.Language:AddTranslation(langID, "claim_territory_for_rewards", "Nehme das Territorium ein für eine Belohnung!")
MGangs.Language:AddTranslation(langID, "edit_territories", "Editiere Territorium")

--[[GANGCHAT]]
MGangs.Language:AddTranslation(langID, "gc_message_wrongsize", "Nachricht überschreitet Maximum (%s) / Minimum (%s) Länge!")




--[[STASH]]




--[[ASSOCIATIONS]]




--[[RANKINGS]]




--[[UPGRADES]]




--[[ACHIEVEMENTS]]