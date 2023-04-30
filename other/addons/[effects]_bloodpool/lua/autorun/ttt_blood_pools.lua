--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[effects]_bloodpool/lua/autorun/ttt_blood_pools.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

-- blood poolz
-- now 100% more gamemode compatible

-- change the textures to your liking
BLOOD_POOL_TEXTURES = {
	-- humans, players
	[BLOOD_COLOR_RED] = {
		"decals/gm_bloodstains_001",
		"decals/gm_bloodstains_002",
		"decals/gm_bloodstains_003",
		"decals/gm_bloodstains_004",
		"decals/gm_bloodstains_005",
		"decals/gm_bloodstains_006"
	},
	-- aliens
	[BLOOD_COLOR_YELLOW] = {
		"decals/gm_bloodstains_002_yellow",
		"decals/gm_bloodstains_003_yellow",
		"decals/gm_bloodstains_004_yellow",
		"decals/gm_bloodstains_005_yellow"
	},
	-- zombies, headcrabs
	[BLOOD_COLOR_GREEN] = {
		"decals/gm_bloodstains_002_yellow",
		"decals/gm_bloodstains_003_yellow",
		"decals/gm_bloodstains_004_yellow",
		"decals/gm_bloodstains_005_yellow"
	}
}

function CreateBloodPoolForRagdoll(rag, boneid, color, flags)
	if BREACH.DisableBloodPools then return end
	if true then return end --заменил на стандартную кровь
	--if not IsValid(rag) then return end
	
	local boneid = boneid or 0
	local flags = flags or 0
	local color = color or BLOOD_COLOR_RED

	local effectdata = EffectData()
	effectdata:SetEntity(rag)
	effectdata:SetAttachment(boneid)
	effectdata:SetFlags(flags)
	effectdata:SetColor(color)
	effectdata:SetOrigin(rag:GetBonePosition(boneid))

	local Rec = RecipientFilter()
	Rec:AddAllPlayers()

	util.Effect("blood_pool", effectdata, true, Rec)
end

if CLIENT then
	CL_BLOOD_POOL_ITERATION = 1
	
	--[[
	CreateClientConVar("bloodpool_min_size", 35, true, false, "Minimum size for blood pools.", 0)
	CreateClientConVar("bloodpool_max_size", 60, true, false, "Maximum size for blood pools.", 0)
	CreateClientConVar("bloodpool_lifetime", 10000, true, false, "Time before blood pools are cleaned up. Does not apply to TTT.", 10)]]
	--CreateClientConVar("bloodpool_cheap", 0, true, false, "Ignore blood pool size limitations. WARNING: Will result in floating blood!")
end
-- this is all