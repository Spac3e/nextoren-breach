AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

MsgC( Color(0,255,0),"---------------Loading Map Config----------------\n" )
if file.Exists( GM.FolderName .. "/gamemode/mapconfigs" .. "/" .. game.GetMap() .. ".lua", "LUA" ) then
	local relpath = "mapconfigs/" .. game.GetMap() .. ".lua"
	if SERVER then
		AddCSLuaFile( relpath )
	end
	include( relpath )
	MsgC( Color(0,255,0), "# Loading config for map " .. game.GetMap().."\n" )
	MAP_LOADED = true
else
	MsgC( Color(0,255,0), "----------------Loading Complete-----------------\n" )
	error( "Unsupported map " .. game.GetMap() .. "!" )
end

local DISABLED_MODULES = {
}

local vsego = 0
-- Load modules...
local function LoadModules()
	local fol = GM.FolderName.."/gamemode/modules/"
	local files, folders = file.Find(fol .. "*", "LUA")
	for k,v in pairs(files) do
		include(fol .. v)
	end
	MsgC( Color(255,0,255), "[NextOren Breach] Legend: ", Color(0,255,255), "Server ", Color(147,112,219), "Shared ", Color(255,165,0), "Client\n" )
	
	--AddCSLuaFile(fol.. 'faction_module' .. "/" ..'sh_faction.lua')
	--include(fol.. 'faction_module' .. "/" ..'sh_faction.lua')
	--include(fol.. 'misc_module' .. "/" ..'sv_globaldata.lua')
	
	for _, folder in SortedPairs(folders, true) do
		if folder == "." or folder == ".." then continue end
		if DISABLED_MODULES[folder] then continue end
		for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
			MsgC( Color(255,100,0), "[NextOren Breach] Pooling CLIENT file: " .. File .. "\n" )
			AddCSLuaFile(fol.. folder .. "/" ..File)
			vsego = vsego + 1
		end
	end
	Msg("======================================================================\n")
	for _, folder in SortedPairs(folders, true) do
		if folder == "." or folder == ".." then continue end
		if DISABLED_MODULES[folder] then continue end
		for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
			MsgC( Color(255,255,0), "[NextOren Breach] Loading + Pooling SHARED file: " .. File .. "\n" )
			AddCSLuaFile(fol..folder .. "/" ..File)
			include(fol.. folder .. "/" ..File)
			vsego = vsego + 1
		end
	end
	Msg("======================================================================\n")
	
	for _, folder in SortedPairs(folders, true) do
		if folder == "." or folder == ".." then continue end
		if DISABLED_MODULES[folder] then continue end
		for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
			MsgC( Color(0,255,255), "[NextOren Breach] Loading SERVER file: " .. File .. "\n" )
			include(fol.. folder .. "/" ..File)
			vsego = vsego + 1
		end
	end
	Msg("======================================================================\n")
	MsgC( Color(255,0,255), "[NextOren Breach] Legend: ", Color(0,255,255), "Server ", Color(255,255,0), "Shared ", Color(255,100,0), "Client\n" )
	
	--[[Lua-Refresh Things]]--
	MsgC(Color(0,255,0), "[NextOren Breach] Loading Complete!\n")
	MsgC(Color(0,255,0), "[NextOren Breach] Total LUA Files: "..vsego.."\n")
end	

LoadModules()
