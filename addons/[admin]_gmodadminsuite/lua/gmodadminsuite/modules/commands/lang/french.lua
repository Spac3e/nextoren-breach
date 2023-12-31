--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/commands/lang/french.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

return {
	Name = "French",
	Flag = "flags16/fr.png",
	Phrases = function() return {

		module_name = "Command Manager",

		no_permission = "Désolé, mais vous n'avez pas la permission d'utiliser cette commande.",
		commands = "Commandes",
		command = "Commande",
		action = "Action",
		help = "Aide",
		new_command = "+ Nouvelle Commande",
		wiki = "Wiki",
		run_command = "Executer Commande",
		edit_command = "Modifier Commande",
		form_help = "Texte d'Assistance... (facultatif)",
		form_help_tip = "C'est le texte qui sera affiché dans le menu des commandes, dans le colonne \"Aide\".",
		select_action = "Selectionnez une Action...",
		hide_in_chat = "Masquer dans le chat ?",
		hide_in_chat_tip = "Si coché, le commande ne sera pas affiché dans le chat lorsque quelqu'un l'écrira.",
		finished = "Terminé",
		commands_case_insensitive = "Toutes les commandes ne sont pas sensibles aux majuscules.",
		ok = "OK",
		cannot_create_command = "Impossible de créer la commande !",
		cancel = "Annuler",
		delete_command = "Supprimer Commander",
		copy_command = "Copier Commande",
		permissions = "Permissions",
		permissions_editor = "Ouvrir l'Editeur de Permissions",
		permissions_tip = "Vous autorise à whitelister et blacklister les groupes d'utilisateurs et les équipes/métiers.",
		can_access_command = "Peu accéder à la commande",
		teams = "Equipes",
		usergroups = "Groupes d'Utilisateurs",
		anyone_can_access = "N'importe qui peut accéder à cette commande",
		whitelisted_only = "Seuls les membres whitelistés peuvent accéder à cette commande",
		non_blacklisted_only = "Seuls les membres non-blacklistés peuvent accéder à cette commande",
		whitelisted_and_blacklisted = "Seuls les membres whitelistés (excepté les blacklistés) peuvent accéder à cette commande",
		custom_usergroup = "+ Groupe d'Utilisateurs Custom",
		custom_usergroup_text = "Entrez groupe d'utilisateurs",
		custom_usergroup_placeholder = "Groupe d'Utilisateurs...",
		reason_usergroup_blacklisted = "Votre groupe d'utilisateurs est blacklisté sur cette commande.",
		reason_usergroup_not_whitelisted = "Votre group d'utilisateur n'est pas whitelisté sur cette commande.",
		reason_team_blacklisted = "Votre équipe est blacklistée sur cette commande.",
		reason_team_not_whitelisted = "Votre équipe n'est pas whitelistée sur cette commande.",
		saved_exclamation = "Sauvegardé !",
		set_position = "Définir Position",
		position_set = "Position Définie !",
		set_position_instruction = "Go to the desired position and face in the desired direction",
		set_position_instruction_2 = "When finished, unpin the menu and the position and angle will then be saved",

		action_open_commands_menu = "Ouvrir le menu des commandes",
		action_command = "Executer commande console",
		action_chat = "Envoyer un message textuel",
		action_website = "Ouvrir Site Web",
		action_lua_function_sv = "Fonction Lua Client",
		action_lua_function_cl = "Fonction Lua Serveur",
		action_gas_module = "Ouvrir Module GAS",
		action_teleport = "Téléportation",

		form_action_command = "Commande console à éxécuter",
		form_action_chat = "Message textuel à envoyer",
		form_action_website = "Site Web à ouvrir",
		form_action_lua_function_sv = "Fonction Lua à éxécuter\nCôté Serveur",
		form_action_lua_function_cl = "Fonction Lua à éxécuter\nCôté Client",
		form_action_gas_module = "Module GAS à ouvrir",
		form_action_teleport = "Téléportation",

		error_command_exists = "Une commande avec ce nom existe déjà !",
		error_no_command = "Vous n'avez entré aucune commande.",
		error_no_command_execute = "Vous n'avez pas entré la commande à éxécuter.",
		error_no_action = "Vous n'avez pas séléctionné d'action pour cette commande.",
		error_invalid_website = "Le site web spécifié n'est pas une adresse valide.",
		error_no_lua_function = "Vous n'avez pas séléctionné de Fonction Lua à éxécuter.",
		error_no_gas_module = "Vous n'avez pas séléctionné de module GAS à ouvrir.",
		error_no_position_set = "Vous n'avez pas spécifié de position et d'angle pour cette téléportation.",

} end }