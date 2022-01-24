-- [[------------------------]]
-- [[MGANGS Lang - FR - SHARED]]
-- [[Translated by ⌛ Տบ乃ɑ尺ป ⌛ :D]]
-- [[------------------------]]

-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.

-- [[Register Language]]
local langID = "fr" -- Language ID/Name

MGangs.Language:Register(langID)

--[[---------
  WORDS
-----------]]
MGangs.Language:AddTranslation(langID, "yes", "Oui")
MGangs.Language:AddTranslation(langID, "no", "Non")
MGangs.Language:AddTranslation(langID, "name", "Nom")
MGangs.Language:AddTranslation(langID, "page", "Page")
MGangs.Language:AddTranslation(langID, "set", "Définir")
MGangs.Language:AddTranslation(langID, "save", "Enregistrer")
MGangs.Language:AddTranslation(langID, "settings", "Paramètres")
MGangs.Language:AddTranslation(langID, "delete", "Supprimer")
MGangs.Language:AddTranslation(langID, "submit", "Soumettre")
MGangs.Language:AddTranslation(langID, "admin", "Admin")
MGangs.Language:AddTranslation(langID, "edit", "Modifier")
MGangs.Language:AddTranslation(langID, "cancel", "Annuler")
MGangs.Language:AddTranslation(langID, "leader", "Chef")
MGangs.Language:AddTranslation(langID, "gang", "Gang")
MGangs.Language:AddTranslation(langID, "invite", "Inviter")
MGangs.Language:AddTranslation(langID, "general", "Général")
MGangs.Language:AddTranslation(langID, "permissions", "Permissions")
MGangs.Language:AddTranslation(langID, "page", "Page")
MGangs.Language:AddTranslation(langID, "deny", "Décliner")
MGangs.Language:AddTranslation(langID, "join", "Rejoindre")
MGangs.Language:AddTranslation(langID, "lvl", "Niveau")
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "deposit", "Déposer")
MGangs.Language:AddTranslation(langID, "withdraw", "Retirer")
MGangs.Language:AddTranslation(langID, "options", "Paramètres")

--[[---------
  PHRASES
-----------]]
MGangs.Language:AddTranslation(langID, "mustbe_number", "Cela doit correspondre à un nombre !")
MGangs.Language:AddTranslation(langID, "fix_errors_please", "Veuillez corriger les erreurs !")
MGangs.Language:AddTranslation(langID, "player_not_valid", "Joueur non valide !")
MGangs.Language:AddTranslation(langID, "player_ina_gang", "Ce joueur est déjà dans un gang !")
MGangs.Language:AddTranslation(langID, "you_cant_do_yet", "Vous ne pouvez pas encore faire ça !")
MGangs.Language:AddTranslation(langID, "you_cant_join_gang", "Vous ne pouvez pas rejoindre ce gang !")
MGangs.Language:AddTranslation(langID, "youre_already_ina_gang", "Vous êtes déjà dans un gang !")
MGangs.Language:AddTranslation(langID, "youre_not_ina_gang", "Vous n'êtes pas dans un gang !")
MGangs.Language:AddTranslation(langID, "you_invited_to_thegang", "Vous avez été invité au gang %s!")
MGangs.Language:AddTranslation(langID, "search_results", "%s Résultat(s) pour '%s'")
MGangs.Language:AddTranslation(langID, "search_results_took", "Tâche effectuée en %s secondes")
MGangs.Language:AddTranslation(langID, "no_search_results", "Aucun résultat")
MGangs.Language:AddTranslation(langID, "search_for", "Recherche pour")
MGangs.Language:AddTranslation(langID, "enter_search_criteria", "Entrez vos critères de recherche ici")
MGangs.Language:AddTranslation(langID, "no_gang", "Pas de gang")
MGangs.Language:AddTranslation(langID, "refresh_gangs", "Actualiser les Gangs")
MGangs.Language:AddTranslation(langID, "search_gangs", "Rechercher des Gangs")
MGangs.Language:AddTranslation(langID, "search_gangs_criteria", "Tapez le nom, l'ID du gang, etc... et appuyez sur la touche Entrée")
MGangs.Language:AddTranslation(langID, "edit_gangs", "Modifier les Gangs")
MGangs.Language:AddTranslation(langID, "deposit_amt", "Montant du dépôt")
MGangs.Language:AddTranslation(langID, "enter_deposit_amt", "Entrez le montant du dépôt")
MGangs.Language:AddTranslation(langID, "withdraw_amt", "Retirer le montant")
MGangs.Language:AddTranslation(langID, "enter_withdraw_amt", "Entrer le montant du retrait")
MGangs.Language:AddTranslation(langID, "gang_information", "Information du Gang")
MGangs.Language:AddTranslation(langID, "must_wait_seconds", "Vous devez attendre %s secondes, veuillez rester près du drapeau !")
MGangs.Language:AddTranslation(langID, "you_want_to_do_this", "Êtes-vous sûr de vouloir faire cela ?")
MGangs.Language:AddTranslation(langID, "cant_afford_gang", "Vous ne pouvez pas vous permettre de créer un gang !")

-- Gang Invites
MGangs.Language:AddTranslation(langID, "gang_invites", "Invitation au gang")
MGangs.Language:AddTranslation(langID, "search_invites", "Rechercher des invitations")
MGangs.Language:AddTranslation(langID, "search_invites_criteria", "Tapez le nom du gang, son ID, etc... et appuyez sur la touche Entrée")

-- Gang Creation
MGangs.Language:AddTranslation(langID, "your_gang_created", "Votre gang a été créé avec succès !")
MGangs.Language:AddTranslation(langID, "gang_create_fail_noleader", "La création du gang a échoué, vous n'avez pas défini de chef.")
MGangs.Language:AddTranslation(langID, "gang_create_fail", "La création du gang a échoué.")
MGangs.Language:AddTranslation(langID, "gang_created_group", "Vous avez créé un groupe !")

--[[Phrases: Gang (Admin/general)]]
MGangs.Language:AddTranslation(langID, "members_online", "Membre(s) en Ligne")
MGangs.Language:AddTranslation(langID, "members", "Membres")
MGangs.Language:AddTranslation(langID, "search_members", "Rechercher des Membres")
MGangs.Language:AddTranslation(langID, "search_members_criteria", "Tapez le nom du joueur, son SteamID, etc... et appuyez sur la touche Entrée")

-- Gang Name
MGangs.Language:AddTranslation(langID, "gang_name", "Nom du Gang")
MGangs.Language:AddTranslation(langID, "gang_name_not_set_invalid", "Le nom du gang n'a pas été défini, nom non valide.")
MGangs.Language:AddTranslation(langID, "gang_name_set", "Définir le nom du groupe à %s!")
MGangs.Language:AddTranslation(langID, "name_not_allowed", "Nom non autorisé")
MGangs.Language:AddTranslation(langID, "enter_gang_name", "Entez un nom de Gang")

-- Gang ID Copying
MGangs.Language:AddTranslation(langID, "copy_gang_id", "Copier l'ID du Gang")
MGangs.Language:AddTranslation(langID, "copied_gang_id", "ID du Gang copié dans le presse-papier !")

-- Gang Delete
MGangs.Language:AddTranslation(langID, "delete_this_gang_pmt", "Supprimer ce gang ?")
MGangs.Language:AddTranslation(langID, "gang_not_deleted", "Le gang n'a pas été supprimé.")
MGangs.Language:AddTranslation(langID, "gang_deleted", "Gang supprimé !")

-- Gang Icon URL
MGangs.Language:AddTranslation(langID, "icon_url", "URL de l'icône")
MGangs.Language:AddTranslation(langID, "gang_icon_url", "URL de l'icône du gang")
MGangs.Language:AddTranslation(langID, "invalid_icon_url", "URL de l'icône non valide")
MGangs.Language:AddTranslation(langID, "enter_gang_icon_url", "Entrez l'URL de l'icône du groupe")
MGangs.Language:AddTranslation(langID, "gang_invalid_icon_url", "L'URL de l'icône de groupe n'a pas été définie, l'URL de l'icône n'est pas valide.")
MGangs.Language:AddTranslation(langID, "gang_icon_url_set", "Définir l'URL de l'icône de groupe à %s!")

-- Gang EXP
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "set_exp", "Définir l'EXP")
MGangs.Language:AddTranslation(langID, "enter_exp", "Entrez l'EXP souhaitée")
MGangs.Language:AddTranslation(langID, "gang_invalid_exp", "L'EXP du Gang n'a pas été défini, EXP non valide.")
MGangs.Language:AddTranslation(langID, "gang_exp_set", "Définir l'EXP du Gang à %s!")

-- Gang Level
MGangs.Language:AddTranslation(langID, "level", "Niveau")
MGangs.Language:AddTranslation(langID, "set_level", "Définir le niveau")
MGangs.Language:AddTranslation(langID, "enter_level", "Entrez le niveau désiré")
MGangs.Language:AddTranslation(langID, "gang_invalid_level", "Le niveau du Gang n'a pas été défini, niveau invalide.")
MGangs.Language:AddTranslation(langID, "gang_level_set", "Définir le niveau du Gang à %s!")
MGangs.Language:AddTranslation(langID, "gang_level_isnow", "Votre Gang est maintenant au niveau %s!")

-- Gang Balance
MGangs.Language:AddTranslation(langID, "balance", "Solde")
MGangs.Language:AddTranslation(langID, "set_balance", "Définir un Solde")
MGangs.Language:AddTranslation(langID, "enter_balance", "Entrer le Solde désiré")
MGangs.Language:AddTranslation(langID, "gang_invalid_balance", "Le Solde du Gang n'a pas été défini, niveau invalide.")
MGangs.Language:AddTranslation(langID, "gang_balance_set", "Définir le Solde du Gang à %s!")

--[[Phrases: Player]]
-- Player Kick
MGangs.Language:AddTranslation(langID, "kick_from_gang", "Kicker du Gang")
MGangs.Language:AddTranslation(langID, "kick_from_gang_pmt", "Kicker du Gang ?")
MGangs.Language:AddTranslation(langID, "kicked_from_gang", "%s a été kické du votre Gang !")
MGangs.Language:AddTranslation(langID, "not_kicked_from_gang", "%s n'a pas été kické du votre Gang.")

-- Player (Set As) Leader
MGangs.Language:AddTranslation(langID, "as_leader", "Comme Chef")
MGangs.Language:AddTranslation(langID, "set_as_leader_pmt", "Définir comme chef du Gang ?")
MGangs.Language:AddTranslation(langID, "set_as_leader", "%s a été défini comme Chef !")
MGangs.Language:AddTranslation(langID, "not_set_as_leader", "%s n'a pas été défini comme Chef.")

-- Player (Set) Gang
MGangs.Language:AddTranslation(langID, "set_gang", "Définir le Gang")
MGangs.Language:AddTranslation(langID, "enter_gang_id", "Enter Gang ID")
MGangs.Language:AddTranslation(langID, "player_added_to_gang", "%s a été ajouté au Gang %s!")
MGangs.Language:AddTranslation(langID, "player_not_added_to_gang", "%s n'a pas été ajouté au Gang !")

--[[Phrases: Admin]]
MGangs.Language:AddTranslation(langID, "back_to_admin", "Retour au Panel Admin")

--[[Phrases: Settings]]
-- Groups
MGangs.Language:AddTranslation(langID, "group_name", "Nom du groupe")
MGangs.Language:AddTranslation(langID, "group_priority", "Priorité du groupe")
MGangs.Language:AddTranslation(langID, "enter_group_priority", "Entrez la priorité du groupe")
MGangs.Language:AddTranslation(langID, "enter_group_name", "Entrez le nom du groupe")
MGangs.Language:AddTranslation(langID, "create_group", "Créer le groupe")
MGangs.Language:AddTranslation(langID, "edit_groups", "Modifier le(s) groupe(s)")
MGangs.Language:AddTranslation(langID, "save_groups", "Enregistrer le groupe")
MGangs.Language:AddTranslation(langID, "group_icon", "Icône du groupe")
MGangs.Language:AddTranslation(langID, "updated_gang_groups", "Groupes de gang mis à jour !")
MGangs.Language:AddTranslation(langID, "gang_groups", "Groupes de gangs")
MGangs.Language:AddTranslation(langID, "select_group_icon", "Sélectionnez une icône de groupe")

-- Players
MGangs.Language:AddTranslation(langID, "invite_players", "Inviter des joueurs")
MGangs.Language:AddTranslation(langID, "invite_player", "Inviter le joueur")
MGangs.Language:AddTranslation(langID, "invite_failed", "Invitation échouée, veuillez contacter un administrateur.")
MGangs.Language:AddTranslation(langID, "invited_player", "%s a été invité avec succès au Gang !")
MGangs.Language:AddTranslation(langID, "already_invited_player", "%s a déjà été invité !")
MGangs.Language:AddTranslation(langID, "search_players", "Rechercher des joueurs")
MGangs.Language:AddTranslation(langID, "search_players_pholder", "Tapez un nom, un SteamID, etc... et appuyez sur la touche Entrée")
MGangs.Language:AddTranslation(langID, "edit_players", "Modifier les joueurs")

-- Misc
MGangs.Language:AddTranslation(langID, "back_to_settings", "Retour aux paramètres")
MGangs.Language:AddTranslation(langID, "leave_gang", "Quitter le Gang")
MGangs.Language:AddTranslation(langID, "edit_gang", "Modifier le Gang")
MGangs.Language:AddTranslation(langID, "edit_gang_information", "Modifier les informations du Gang")
MGangs.Language:AddTranslation(langID, "gang_administration", "Administration du Gang")
MGangs.Language:AddTranslation(langID, "updated_gang_info", "Information du Gang mis à jour !")

--[[Phrases: Gang Creation]]
MGangs.Language:AddTranslation(langID, "edit_default_groups", "Modifier les groupes par défaut")
MGangs.Language:AddTranslation(langID, "edit_groups_after_creation", "Vous pouvez ajouter de nouveaux groupes et modifier l'autorisation de groupe après la création de ce dernier.")
MGangs.Language:AddTranslation(langID, "review_and_finish", "Revoir et terminer")
MGangs.Language:AddTranslation(langID, "finish_gang_creation", "Terminer la création du Gang")
MGangs.Language:AddTranslation(langID, "create_your_gang", "Créez votre Gang")
MGangs.Language:AddTranslation(langID, "previous_step", "Étape précédente")
MGangs.Language:AddTranslation(langID, "next_step", "Étape suivante")


--[[------------
  Module Translations
  - These are for the modules that come with MGangs 2
  - Any thirdparty modules translations will have to be translated within the module
--------------]]

--[[TERRITORIES]]
-- Territory Weapon/Creation
MGangs.Language:AddTranslation(langID, "territory_creator_info1", "[Clic-Gauche + Maintenir] Dessinez la zone")
MGangs.Language:AddTranslation(langID, "territory_creator_info2", "[Clic-Droit] Enregistrer la zone")
MGangs.Language:AddTranslation(langID, "territory_creator_info3", "[Recharger] Réinitialiser la zone")
MGangs.Language:AddTranslation(langID, "terr_doesnt_exist", "Le territoire n'existe pas !")
MGangs.Language:AddTranslation(langID, "terr_created", "Territoire créé !")
MGangs.Language:AddTranslation(langID, "terr_notcreated", "Échec de la suppression du territoire !")
MGangs.Language:AddTranslation(langID, "terr_deleted", "Territoire supprimé !")
MGangs.Language:AddTranslation(langID, "terr_notdeleted", "Échec de la suppression du territoire !")
MGangs.Language:AddTranslation(langID, "terr_updated", "Territoire supprimé !")
MGangs.Language:AddTranslation(langID, "terr_notupdated", "Échec de la suppression du territoire !")

-- Territory Flag
MGangs.Language:AddTranslation(langID, "someone_else_is_claiming", "Quelqu'un d'autre revendique ceci !")
MGangs.Language:AddTranslation(langID, "cant_claim_own_territory", "Vous ne pouvez pas revendiquer le territoire de votre propre gang !")
MGangs.Language:AddTranslation(langID, "cant_claim_territory", "Ce territoire ne peut être revendiqué !")
MGangs.Language:AddTranslation(langID, "claimed_territory_for", "Vous avez revendiqué le territoire '%s' pour votre Gang !")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Le territoire de votr Gang '%s' est entrain d'être revendiqué !")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Le territoire de votr Gang '%s' est entrain d'être revendiqué !")
MGangs.Language:AddTranslation(langID, "t_notclaming_dead", "Vous êtes mort ! Vous ne revendiquez plus le territoire.")
MGangs.Language:AddTranslation(langID, "t_notclaming_toofar", "Vous ne revendiquez plus le territoire, vous vous êtes trop éloigné.")
MGangs.Language:AddTranslation(langID, "terr_cantbuild", "Vous ne pouvez pas construire dans ce territoire, votre Gang doit le posséder !")

-- Menu
MGangs.Language:AddTranslation(langID, "territory", "Territoire")
MGangs.Language:AddTranslation(langID, "territories", "Territoires")
MGangs.Language:AddTranslation(langID, "search_territories", "Rechercher des Territoires")
MGangs.Language:AddTranslation(langID, "search_territories_criteria", "Tapez un nom, description, etc... et appuyez sur la touche Entrée")
MGangs.Language:AddTranslation(langID, "create_territory", "Créer un Territoire")
MGangs.Language:AddTranslation(langID, "t_controlled_by", "Contrôlé par '%s'")
MGangs.Language:AddTranslation(langID, "t_being_claimed_by", "En cours de revendication par '%s'")
MGangs.Language:AddTranslation(langID, "t_currently_uncontrolled", "Actuellement non contrôlé ")
MGangs.Language:AddTranslation(langID, "claim_territory_for_rewards", "Réclamez pour avoir des récompenses !")
MGangs.Language:AddTranslation(langID, "edit_territories", "Modifier des Territoires")

--[[GANGCHAT]]
MGangs.Language:AddTranslation(langID, "gc_message_wrongsize", "Le message dépasse la longueur maximum (%s) / minimum (%s) !")




--[[STASH]]




--[[ASSOCIATIONS]]




--[[RANKINGS]]




--[[UPGRADES]]




--[[ACHIEVEMENTS]]
