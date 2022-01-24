-- [[------------------------]]
-- [[MGANGS Lang - RU - SHARED]]
-- [[Translated by ? (If you translated this, please contact me)]]
-- [[------------------------]]

-- Don't replace %s they are for replacement values.
-- WARNING: If you're translating, this is extremely long and may take you a while.

-- [[Register Language]]
local langID = "ru" -- Language ID/Name

MGangs.Language:Register(langID)

--[[---------
  WORDS
-----------]]
MGangs.Language:AddTranslation(langID, "yes", "Да")
MGangs.Language:AddTranslation(langID, "no", "Нет")
MGangs.Language:AddTranslation(langID, "name", "Имя")
MGangs.Language:AddTranslation(langID, "page", "Страница")
MGangs.Language:AddTranslation(langID, "set", "Набор")
MGangs.Language:AddTranslation(langID, "save", "Сохранить")
MGangs.Language:AddTranslation(langID, "settings", "Настройки")
MGangs.Language:AddTranslation(langID, "delete", "Удалить")
MGangs.Language:AddTranslation(langID, "submit", "Представлять")
MGangs.Language:AddTranslation(langID, "admin", "Админ")
MGangs.Language:AddTranslation(langID, "edit", "Редактировать")
MGangs.Language:AddTranslation(langID, "cancel", "Отмена")
MGangs.Language:AddTranslation(langID, "leader", "Лидер")
MGangs.Language:AddTranslation(langID, "gang", "Банда")
MGangs.Language:AddTranslation(langID, "invite", "Пригласить")
MGangs.Language:AddTranslation(langID, "general", "Общий")
MGangs.Language:AddTranslation(langID, "permissions", "Разрешения")
MGangs.Language:AddTranslation(langID, "page", "Страница")
MGangs.Language:AddTranslation(langID, "deny", "Отказать")
MGangs.Language:AddTranslation(langID, "join", "Вступить")
MGangs.Language:AddTranslation(langID, "lvl", "Уровень")
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "deposit", "Внести")
MGangs.Language:AddTranslation(langID, "withdraw", "Снять")
MGangs.Language:AddTranslation(langID, "options", "Опции")
MGangs.Language:AddTranslation(langID, "priority", "Приоритет")

--[[---------
  PHRASES
-----------]]
MGangs.Language:AddTranslation(langID, "gang_icon_tootlip", "Неправильная ссылка. (Пример: http://zephruz.net/img/mgangs2_logo.png)")
MGangs.Language:AddTranslation(langID, "mustbe_number", "Должно быть число!")
MGangs.Language:AddTranslation(langID, "fix_errors_please", "Исправьте ошибки, пожалуйста!")
MGangs.Language:AddTranslation(langID, "player_not_valid", "Игрок не действителен!")
MGangs.Language:AddTranslation(langID, "player_ina_gang", "Этот игрок находится в банде!")
MGangs.Language:AddTranslation(langID, "you_cant_do_yet", "Ты еще не можешь этого сделать!")
MGangs.Language:AddTranslation(langID, "you_cant_join_gang", "Вы не можете присоединиться к этой банде!")
MGangs.Language:AddTranslation(langID, "youre_already_ina_gang", "Ты уже в банде!")
MGangs.Language:AddTranslation(langID, "youre_not_ina_gang", "Ты не в банде!")
MGangs.Language:AddTranslation(langID, "you_invited_to_thegang", "Вас пригласили в банду %s!")
MGangs.Language:AddTranslation(langID, "search_results", "%s Result(s) for '%s'")
MGangs.Language:AddTranslation(langID, "search_results_took", "Потребовались  %s секунды")
MGangs.Language:AddTranslation(langID, "no_search_results", "нет результата")
MGangs.Language:AddTranslation(langID, "search_for", "Искать")
MGangs.Language:AddTranslation(langID, "enter_search_criteria", "Введите критерии поиска здесь")
MGangs.Language:AddTranslation(langID, "no_gang", "Нет Банды")
MGangs.Language:AddTranslation(langID, "refresh_gangs", "Обновить Банды")
MGangs.Language:AddTranslation(langID, "search_gangs", "Поиск Банды")
MGangs.Language:AddTranslation(langID, "search_gangs_criteria", "Введите имя, идентификатор банды и т.д и нажмите enter")
MGangs.Language:AddTranslation(langID, "edit_gangs", "Редактировать Банды")
MGangs.Language:AddTranslation(langID, "deposit_amt", "Сумма вклада")
MGangs.Language:AddTranslation(langID, "enter_deposit_amt", "Подтвердить сумму депозита")
MGangs.Language:AddTranslation(langID, "withdraw_amt", "Вывести сумму")
MGangs.Language:AddTranslation(langID, "enter_withdraw_amt", "Введите сумму вывода")
MGangs.Language:AddTranslation(langID, "gang_information", "Информация о Банде")
MGangs.Language:AddTranslation(langID, "must_wait_seconds", "Вы должны ждать %s секунд, пожалуйста, оставайтесь рядом с флагом!")
MGangs.Language:AddTranslation(langID, "you_want_to_do_this", "Вы уверены, что хотите сделать это?")
MGangs.Language:AddTranslation(langID, "cant_afford_gang", "Вы не можете позволить себе создание банды!")

-- Gang Invites
MGangs.Language:AddTranslation(langID, "gang_invites", "Банды Приглашает")
MGangs.Language:AddTranslation(langID, "search_invites", "Поиск Приглашений")
MGangs.Language:AddTranslation(langID, "search_invites_criteria", "Введите имя банды, идентификатор банды и т.д и нажмите enter")

-- Gang Creation
MGangs.Language:AddTranslation(langID, "your_gang_created", "Ваша банда успешно создана!")
MGangs.Language:AddTranslation(langID, "gang_create_fail_noleader", "Создание банды не удалось, не выбран лидер группы")
MGangs.Language:AddTranslation(langID, "gang_create_fail", "Создание банды не удалось.")
MGangs.Language:AddTranslation(langID, "gang_created_group", "Вы создали группу!")

--[[Phrases: Gang (Admin/general)]]
MGangs.Language:AddTranslation(langID, "members_online", "Участники онлайн")
MGangs.Language:AddTranslation(langID, "members", "Участники")
MGangs.Language:AddTranslation(langID, "search_members", "Поиск Участников")
MGangs.Language:AddTranslation(langID, "search_members_criteria", "Введите имя игрока, SteamID, и т.д и нажмите enter")

-- Gang Name
MGangs.Language:AddTranslation(langID, "gang_name", "Имя Банды")
MGangs.Language:AddTranslation(langID, "gang_name_not_set_invalid", "Имя банды не было установлено, недопустимое имя")
MGangs.Language:AddTranslation(langID, "gang_name_set", "Название банды %s!")
MGangs.Language:AddTranslation(langID, "name_not_allowed", "Имя не разрешено")
MGangs.Language:AddTranslation(langID, "enter_gang_name", "Введите имя банды")

-- Gang ID Copying
MGangs.Language:AddTranslation(langID, "copy_gang_id", "Копировать ID Банды")
MGangs.Language:AddTranslation(langID, "copied_gang_id", "Скопированный Идентификатор банды в буфере обмена!")

-- Gang Delete
MGangs.Language:AddTranslation(langID, "delete_this_gang_pmt", "Удалить эту банду?")
MGangs.Language:AddTranslation(langID, "gang_not_deleted", "Банда не была удалена")
MGangs.Language:AddTranslation(langID, "gang_deleted", "Банды удалены!")

-- Gang Icon URL
MGangs.Language:AddTranslation(langID, "icon_url", "Icon URL")
MGangs.Language:AddTranslation(langID, "gang_icon_url", "Icon URL Банды")
MGangs.Language:AddTranslation(langID, "invalid_icon_url", "Недействительный icon URL")
MGangs.Language:AddTranslation(langID, "enter_gang_icon_url", "Войти банды icon URL")
MGangs.Language:AddTranslation(langID, "gang_invalid_icon_url", "Значок банда URL-адрес не был указан, неверный URL-адрес значка.")
MGangs.Language:AddTranslation(langID, "gang_icon_url_set", "Установлен URL значок банды %s!")

-- Gang EXP
MGangs.Language:AddTranslation(langID, "exp", "EXP")
MGangs.Language:AddTranslation(langID, "set_exp", "Установить EXP")
MGangs.Language:AddTranslation(langID, "enter_exp", "Введите желаемое EXP")
MGangs.Language:AddTranslation(langID, "gang_invalid_exp", "Банда опыта не было установлено, поврежденных ЕХР.")
MGangs.Language:AddTranslation(langID, "gang_exp_set", "Установить gang EXP на %s!")

-- Gang Level
MGangs.Language:AddTranslation(langID, "level", "Уровень")
MGangs.Language:AddTranslation(langID, "set_level", "Установить Уровень")
MGangs.Language:AddTranslation(langID, "enter_level", "Введите желаемый уровень")
MGangs.Language:AddTranslation(langID, "gang_invalid_level", "Уровень банды не был установлен, недопустимый уровень")
MGangs.Language:AddTranslation(langID, "gang_level_set", "Уровень банды %s!")
MGangs.Language:AddTranslation(langID, "gang_level_isnow", "Уровень вашей банды %s!")

-- Gang Balance
MGangs.Language:AddTranslation(langID, "balance", "Баланс")
MGangs.Language:AddTranslation(langID, "set_balance", "Установить Баланс")
MGangs.Language:AddTranslation(langID, "enter_balance", "Введите желаемый баланс")
MGangs.Language:AddTranslation(langID, "gang_invalid_balance", "Баланс банды не был установлен, недопустимый уровень.")
MGangs.Language:AddTranslation(langID, "gang_balance_set", "Установите баланс банды на %s!")

--[[Phrases: Player]]
-- Player Kick
MGangs.Language:AddTranslation(langID, "kick_from_gang", "Выгнать с Банды")
MGangs.Language:AddTranslation(langID, "kick_from_gang_pmt", "Выгнать с Банды?")
MGangs.Language:AddTranslation(langID, "kicked_from_gang", "%s был выгнан с банды!")
MGangs.Language:AddTranslation(langID, "not_kicked_from_gang", "%s не был выгнан с банды.")

-- Player (Set As) Leader
MGangs.Language:AddTranslation(langID, "as_leader", "Лидер")
MGangs.Language:AddTranslation(langID, "set_as_leader_pmt", "Установить в качестве лидера банды?")
MGangs.Language:AddTranslation(langID, "set_as_leader", "%s стал лидером!")
MGangs.Language:AddTranslation(langID, "not_set_as_leader", "%s не был установлен в качестве лидера.")

-- Player (Set) Gang
MGangs.Language:AddTranslation(langID, "set_gang", "Набор Банды")
MGangs.Language:AddTranslation(langID, "enter_gang_id", "Enter Gang ID")
MGangs.Language:AddTranslation(langID, "player_added_to_gang", "%s добавлен в банду %s!")
MGangs.Language:AddTranslation(langID, "player_not_added_to_gang", "%s не был добавлен в банду!")

--[[Phrases: Admin]]
MGangs.Language:AddTranslation(langID, "back_to_admin", "Вернуться к администратору")

--[[Phrases: Settings]]
-- Groups
MGangs.Language:AddTranslation(langID, "group_name", "Имя группы")
MGangs.Language:AddTranslation(langID, "group_priority", "Приоритет Группы")
MGangs.Language:AddTranslation(langID, "enter_group_priority", "Введите приоритет группы")
MGangs.Language:AddTranslation(langID, "enter_group_name", "Введите имя группы")
MGangs.Language:AddTranslation(langID, "create_group", "Создать группу")
MGangs.Language:AddTranslation(langID, "edit_groups", "Редактировать Группу")
MGangs.Language:AddTranslation(langID, "save_groups", "Сохранить Группу")
MGangs.Language:AddTranslation(langID, "group_icon", "Значок группы")
MGangs.Language:AddTranslation(langID, "updated_gang_groups", "Обновленные бандитские группы!")
MGangs.Language:AddTranslation(langID, "gang_groups", "Бандитские Группы")
MGangs.Language:AddTranslation(langID, "select_group_icon", "Выберите значок группы")

-- Players
MGangs.Language:AddTranslation(langID, "invite_players", "Пригласить Игроков")
MGangs.Language:AddTranslation(langID, "invite_player", "Пригласить Игрока")
MGangs.Language:AddTranslation(langID, "invite_failed", "Не удалось отправить инвайт, обратитесь к администратору.")
MGangs.Language:AddTranslation(langID, "invited_player", "Успешно приглашен %s в банду!")
MGangs.Language:AddTranslation(langID, "already_invited_player", "%s уже приглашен!")
MGangs.Language:AddTranslation(langID, "search_players", "Поиск Игроков")
MGangs.Language:AddTranslation(langID, "search_players_pholder", "Введите имя, SteamID, банды и нажмите enter")
MGangs.Language:AddTranslation(langID, "edit_players", "Редактирование Игроков")

-- Misc
MGangs.Language:AddTranslation(langID, "back_to_settings", "Настройки")
MGangs.Language:AddTranslation(langID, "leave_gang", "Покинуть Банду")
MGangs.Language:AddTranslation(langID, "edit_gang", "Редактировать Банду")
MGangs.Language:AddTranslation(langID, "edit_gang_information", "Изменить Информацию о Банде")
MGangs.Language:AddTranslation(langID, "gang_administration", "Администрация Банды")
MGangs.Language:AddTranslation(langID, "updated_gang_info", "Обновленная информация о банде!")

--[[Phrases: Gang Creation]]
MGangs.Language:AddTranslation(langID, "edit_default_groups", "Изменить Группы по Умолчанию")
MGangs.Language:AddTranslation(langID, "edit_groups_after_creation", "После создания банды можно добавить новые группы и изменить разрешения группы.")
MGangs.Language:AddTranslation(langID, "review_and_finish", "Review & Finish")
MGangs.Language:AddTranslation(langID, "finish_gang_creation", "Закончить Создание Банды")
MGangs.Language:AddTranslation(langID, "create_your_gang", "Создайть Свою Банду")
MGangs.Language:AddTranslation(langID, "previous_step", "предыдущие действия")
MGangs.Language:AddTranslation(langID, "next_step", "следующий шаг")


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
MGangs.Language:AddTranslation(langID, "someone_else_is_claiming", "Кто то уже владеет этим!")
MGangs.Language:AddTranslation(langID, "cant_claim_own_territory", "Вы не можете претендовать на свою собственную территорию!")
MGangs.Language:AddTranslation(langID, "cant_claim_territory", "Эта территория не может быть захвачена!")
MGangs.Language:AddTranslation(langID, "claimed_territory_for", "Вы захватили территорию '%s'!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Территория вашей банды '%s' была захвачена!")
MGangs.Language:AddTranslation(langID, "territory_is_being_claimed", "Территория вашей банды '%s' была захвачена!")
MGangs.Language:AddTranslation(langID, "t_notclaming_dead", "Ты умер! Ты больше не захватываешь территорию..")
MGangs.Language:AddTranslation(langID, "t_notclaming_toofar", "Ты больше не учавствуешь в захвате, ты вышел за пределы")
MGangs.Language:AddTranslation(langID, "terr_cantbuild", "Вы не можете строить на этой территории!")

-- Menu
MGangs.Language:AddTranslation(langID, "territory", "Территория")
MGangs.Language:AddTranslation(langID, "territories", "Территории")
MGangs.Language:AddTranslation(langID, "search_territories", "Поиск Территории")
MGangs.Language:AddTranslation(langID, "search_territories_criteria", "Введите имя и нажмите enter")
MGangs.Language:AddTranslation(langID, "create_territory", "Создать Территорию")
MGangs.Language:AddTranslation(langID, "t_controlled_by", "Контролируется '%s'")
MGangs.Language:AddTranslation(langID, "t_being_claimed_by", "Требует '%s'")
MGangs.Language:AddTranslation(langID, "t_currently_uncontrolled", "В настоящее время неконтролируемая")
MGangs.Language:AddTranslation(langID, "claim_territory_for_rewards", "Claim for rewards!")
MGangs.Language:AddTranslation(langID, "edit_territories", "Редактировать Территории")

--[[GANGCHAT]]
MGangs.Language:AddTranslation(langID, "gc_message_wrongsize", "Сообщение превышает (%s) / минимум (%s)!")




--[[STASH]]




--[[ASSOCIATIONS]]




--[[RANKINGS]]




--[[UPGRADES]]




--[[ACHIEVEMENTS]]