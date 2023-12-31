--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   addons/[admin]_gmodadminsuite/lua/gmodadminsuite/modules/commands/lang/english.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

return {
	Name = "English",
	Flag = "flags16/gb.png",
	Phrases = function() return {

		module_name = "Command Manager",

		no_permission = "Sorry, you don't have permission to use this command.",
		commands = "Commands",
		command = "Command",
		action = "Action",
		help = "Help",
		new_command = "+ New command",
		wiki = "Wiki",
		run_command = "Run Command",
		edit_command = "Edit Command",
		form_help = "Help text... (optional)",
		form_help_tip = "This is the text that will be shown in the commands menu in the \"help\" column.",
		select_action = "Select action...",
		hide_in_chat = "Hide in chat?",
		hide_in_chat_tip = "If checked, the command will not show up in chat when somebody types it.",
		finished = "Finished",
		commands_case_insensitive = "All commands are case insensitive.",
		ok = "OK",
		cannot_create_command = "Cannot create command!",
		cancel = "Cancel",
		delete_command = "Delete Command",
		copy_command = "Copy Command",
		permissions = "Permissions",
		permissions_editor = "Open Permissions Editor",
		permissions_tip = "Allows you to whitelist and blacklist usergroups and teams/jobs.",
		can_access_command = "Can access command",
		teams = "Teams",
		usergroups = "Usergroups",
		anyone_can_access = "Anyone can access this command",
		whitelisted_only = "Only whitelisted can access this command",
		non_blacklisted_only = "Only non-blacklisted can access this command",
		whitelisted_and_blacklisted = "Only whitelisted (except blacklisted) can access this command",
		custom_usergroup = "+ Custom Usergroup",
		custom_usergroup_text = "Enter usergroup",
		custom_usergroup_placeholder = "Usergroup...",
		reason_usergroup_blacklisted = "Your usergroup is blacklisted from this command.",
		reason_usergroup_not_whitelisted = "Your usergroup is not whitelisted to this command.",
		reason_team_blacklisted = "Your team is blacklisted from this command.",
		reason_team_not_whitelisted = "Your team is not whitelisted to this command.",
		saved_exclamation = "Saved!",
		set_position = "Set position",
		position_set = "Position set!",
		set_position_instruction = "Go to the desired position and face in the desired direction",
		set_position_instruction_2 = "When finished, unpin the menu and the position and angle will then be saved",

		action_open_commands_menu = "Open commands menu",
		action_command = "Run console command",
		action_chat = "Say chat message",
		action_website = "Open website",
		action_lua_function_sv = "Serverside Lua Function",
		action_lua_function_cl = "Clientside Lua Function",
		action_gas_module = "Open GAS Module",
		action_teleport = "Teleport",

		form_action_command = "Console command to run",
		form_action_chat = "Chat message to say",
		form_action_website = "Website to open",
		form_action_lua_function_sv = "Lua function to run\nserverside",
		form_action_lua_function_cl = "Lua function to run\nclientside",
		form_action_gas_module = "GAS module to open",
		form_action_teleport = "Teleport",

		error_command_exists = "A command with this name already exists!",
		error_no_command = "You have not entered the command.",
		error_no_command_execute = "You have not entered the command to execute.",
		error_no_action = "You have not selected an action for this command.",
		error_invalid_website = "The website you have entered is not a valid URL.",
		error_no_lua_function = "You have not selected a Lua function to execute.",
		error_no_gas_module = "You have not selected a GAS module to open.",
		error_no_position_set = "You did not set a position and angle for this teleport.",

} end }