include("shared.lua")

-------------------------[LOADING BREACH]-------------------------
-- Load modules..
local function LoadModules()
	MsgC( Color(255,0,255), "[NextOren Breach] Legend: ", Color(0,255,255), "Server ", Color(147,112,219), "Shared ", Color(255,165,0), "Client\n" )

	Msg("======================================================================\n")
	local root = GM.FolderName.."/gamemode/modules/"

	local _, folders = file.Find(root.."*", "LUA")

	for _, folder in SortedPairs(folders, true) do
		if folder == "." or folder == ".." then continue end
		for _, File in SortedPairs(file.Find(root .. folder .."/sh_*.lua", "LUA"), true) do
			MsgC( Color(255,255,0), "[NextOren Breach] Loading SHARED file: " .. File .. "\n" )
			include(root.. folder .. "/" ..File)
		end
		Msg("======================================================================\n")
	end

	for _, folder in SortedPairs(folders, true) do
		for _, File in SortedPairs(file.Find(root .. folder .."/cl_*.lua", "LUA"), true) do
			MsgC( Color(0,255,255), "[NextOren Breach] Loading CLIENT file: " .. File .. "\n" )
			include(root.. folder .. "/" ..File)
		end
		Msg("======================================================================\n")
	end
	MsgC( Color(255,0,255), "[NextOren Breach] Legend: ", Color(0,255,255), "Server ", Color(255,255,0), "Shared ", Color(255,100,0), "Client\n" )
end

LoadModules()