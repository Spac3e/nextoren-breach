
local mply = FindMetaTable( "Player" )

function mply:AddToMVP()
end

local pastenames = http.Fetch("https://pastebin.com/m1m01KFd")

function mply:Namesurvivor(ply)
	if !self:IsFemale() then
	  local namesurvivormale = table.Random.(pastenames.malename)
	  local namesurvivorlastmale = table.Random(pastenames.malelast)
	 self:SetNamesurvivor(namesurvivormale.." "..namesurvivorlastmale)
  elseif
	self:IsFemale() then
	  local femnamesurv = table.Random(pastenames.femname)
	  local femnamesurvlast = table.Random(pastenames.femlast)
	 self:SetNamesurvivor(femnamesurv.." "..femnamesurvlast)
  end
  if self:GTeam() == TEAM_SPECIAL then
	  local namesurvivorlastmale = table.Random(malelast)
	  local femnamesurvlast = table.Random(femlast)
	  if self:GetRoleName() == role.SCI_SPECIAL_HEALER then
		  self:SetNamesurvivor("Matilda".." "..femnamesurvlast)
	  end
  if self:GetRoleName() == role.SCI_SPECIAL__SLOWER then
		  self:SetNamesurvivor("Speedwone".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_DAMAGE then
		  self:SetNamesurvivor("Kelen".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_VISION then
		  self:SetNamesurvivor("Hedwig".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_MINE then
		  self:SetNamesurvivor("Feelon".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_INVISIBLE then
		  self:SetNamesurvivor("Ruprecht".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_SPEED then
		  self:SetNamesurvivor("Lomao".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_SHIELD then
		  self:SetNamesurvivor("Shieldmeh".." "..namesurvivorlastmale)
	  end
	  if self:GetRoleName() == role.SCI_SPECIAL_BOOSTER then
		  self:SetNamesurvivor("Georg".." "..namesurvivorlastmale)
	  end
  end
end

function mply:ClearBodyGroups(ply, ent)
	for k, v in pairs(self:GetBodyGroups()) do
		self:SetBodygroup(v.id, 0)
	end
end

function GetTableOverride( tab )
	local metatable = {
		__add = function( left, right )
			return AddTables( left, right )
		end
	}
	setmetatable( tab, metatable )
	return tab
end

function mply:AddToStatistics(ply, ent) -- надо сделать новую exp систему nextoren like, u know?
end

function GM:PlayerSpray()
   return self:IsSuperAdmin()
end

local ScaleDamage = ScaleDamage || {}
function ScaleDamage()
	ScaleDamage()
end

function mply:AddToAchievementPoint()
end

function mply:LevelBar()
end

function mply:TakeHealth(number)
	local hp = self:Health()
	local new = hp - number
	if new <= 0 then
		self:Kill()
		return
	end
	self:SetHealth(new)
end

function mply:AnimatedHeal()
	local health, max = self:Health(), self:GetMaxHealth()
	local new = health + number
	self:SetHealth(math.min(new, max))
end

function mply:AddHealth(number)
	local health, max = self:Health(), self:GetMaxHealth()
	local new = health + number
	self:SetHealth(math.min(new, max))
end

net.Receive( "DropBag", function( len, ply )
    if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
        if ply:GetUsingBag() != "" then
            ply:SetMaxSlots(8)
            ply:UnUseBag()
        end
    end
end)

net.Receive( "DropBro", function( len, ply )
    if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
        if ply:GetUsingArmor() != "" then
            ply:UnUseBro()
        end
    end
end)

net.Receive( "DropHat", function( len, ply )
    if ply:GTeam() != TEAM_SPEC and ( ply:GTeam() != TEAM_SCP) and ply:Alive() then
        if ply:GetUsingHelmet() != "" then
            ply:UnUseHat()
        end
    end
end)

function mply:UnUseBag()
   	if self:GetUsingBag() == "" then return end
   	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
   	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
		print(bonemerge:GetModel())
		if bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_big.mdl" or bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_small.mdl" then
			bonemerge:Remove()
		end
    local item = ents.Create( self:GetUsingBag(self:GetClass()) )
    if IsValid( item ) then
        item:Spawn()
        item:SetPos( self:GetPos() )
    end
    self:SetUsingBag("")
	end
end

function mply:Bro()
	if self:GetUsingArmor() == "" then return end
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
		print(bonemerge:GetModel())
		if bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/heavy_armor.mdl" or bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/light_armor.mdl" then
			bonemerge:Remove()
		end
	local item = ents.Create( self:GetUsingArmor(self:GetClass()) )
    if IsValid( item ) then
        item:Spawn()
        item:SetPos( self:GetPos() )
    end
    self:SetUsingArmor("")
	end
end

function mply:UnUseHat()
	if self:GetUsingHelmet() == "" then return end
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
		print(bonemerge:GetModel())
		if bonemerge:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or bonemerge:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" then
			bonemerge:Remove()
		end
		local item = ents.Create( self:GetUsingHelmet(self:GetClass()) )
		if IsValid( item ) then
			item:Spawn()
			item:SetPos( self:GetPos() )
		end
		self:SetUsingHelmet("")
	end
end

function GhostBoneMerge(ply, ent, model, skin)
    local ent = ents.Create("ent_bonemerged")
    ent:SetModel(model)
    ent:AddEffects( bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL) )
    ent:SetOwner(ply)
    ent:SetParent(ply)
    ent:Spawn()
    if ( !ent.BoneMergedEnts ) then
        ent.BoneMergedEnts = {}
    end
    ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = ent
end

function Bonemerge(model, ply)
    local ent = ents.Create("ent_bonemerged")
    ent:SetModel(model)
    ent:AddEffects( bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL) )
    ent:SetOwner(ply)
    ent:SetParent(ply)
    ent:Spawn()
    if ( !ent.BoneMergedEnts ) then
        ent.BoneMergedEnts = {}
    end
    ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = ent
end

function mply:Bonemerge(model, ply)
    local ent = ents.Create("ent_bonemerged")
    ent:SetModel(model)
    ent:AddEffects( bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL) )
    ent:SetOwner(ply)
    ent:SetParent(ply)
    ent:Spawn()
    if ( !ent.BoneMergedEnts ) then
        ent.BoneMergedEnts = {}
    end
    ent.BoneMergedEnts[ #ent.BoneMergedEnts + 1 ] = ent
end

function mply:PrintTranslatedMessage( string )
	net.Start( "TranslatedMessage" )
		net.WriteString( string )
		//net.WriteBool( center or false )
	net.Send( self )
end

function mply:ForceDropWeapon( class )
	if self:HasWeapon( class ) then
		local wep = self:GetWeapon( class )
		if IsValid( wep ) and IsValid( self ) then
			if self:GTeam() == TEAM_SPEC then return end
			local atype = wep:GetPrimaryAmmoType()
			if atype > 0 then
				wep.SavedAmmo = wep:Clip1()
			end	
			if wep:GetClass() == nil then return end
			if wep.droppable != nil and !wep.droppable then return end
			self:DropWeapon( wep )
			self:ConCommand( "lastinv" )
		end
	end
end

function mply:DropAllWeapons( strip )
	if GetConVar( "br_dropvestondeath" ):GetInt() != 0 then
		self:UnUseArmor()
	end
	if #self:GetWeapons() > 0 then
		local pos = self:GetPos()
		for k, v in pairs( self:GetWeapons() ) do
			local candrop = true
			if v.droppable != nil then
				if v.droppable == false then
					candrop = false
				end
			end
			if candrop then
				local class = v:GetClass()
				local wep = ents.Create( class )
				if IsValid( wep ) then
					wep:SetPos( pos )
					wep:Spawn()
					if class == "br_keycard" then
						local cardtype = v.KeycardType or v:GetNWString( "K_TYPE", "safe" )
						wep:SetKeycardType( cardtype )
					end
					local atype = v:GetPrimaryAmmoType()
					if atype > 0 then
						wep.SavedAmmo = v:Clip1()
					end
				end
			end
			if strip then
				v:Remove()
			end
		end
	end
end

// just for finding a bad spawns :p
function mply:FindClosest(tab, num)
	local allradiuses = {}
	for k,v in pairs(tab) do
		table.ForceInsert(allradiuses, {v:Distance(self:GetPos()), v})
	end
	table.sort( allradiuses, function( a, b ) return a[1] < b[1] end )
	local rtab = {}
	for i=1, num do
		if i <= #allradiuses then
			table.ForceInsert(rtab, allradiuses[i])
		end
	end
	return rtab
end

function mply:GiveRandomWep(tab)
	local mainwep = table.Random(tab)
	self:Give(mainwep)
	local getwep = self:GetWeapon(mainwep)
	if getwep.Primary == nil then
		print("ERROR: weapon: " .. mainwep)
		print(getwep)
		return
	end
	getwep:SetClip1(getwep.Primary.ClipSize)
	self:SelectWeapon(mainwep)
	self:GiveAmmo((getwep.Primary.ClipSize * 4), getwep.Primary.Ammo, false)
end

function mply:GiveNTFwep()
	self:GiveRandomWep({"cw_ump45", "cw_mp5"})
end

function mply:GiveMTFwep()
	self:GiveRandomWep({"cw_ar15", "cw_ump45", "cw_mp5"})
end

function mply:GiveCIwep()
	self:GiveRandomWep({"cw_ak74", "cw_scarh", "cw_g36c"})
end

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:ApplyArmor(name)
end

function mply:UnUseArmor()
	if self:GetUsingCloth() == "armor_goc" or self:GetModel():find("goc.mdl") or self:GetUsingCloth() == "" then return end
	self:SetModel(self.OldModel)
	self:SetSkin(self.OldSkin)
	self:SetupHands()
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self )
   	for i = 1, #tbl_bonemerged do
		local bonemerge = tbl_bonemerged[ i ]
		bonemerge:SetInvisible(false)
	end
	self:SetBodyGroups(self.OldBodygroups)
	local item = ents.Create( self:GetUsingCloth(self:GetClass()) )
	if IsValid( item ) then
		item:Spawn()
		item:SetPos( self:GetPos() )
	end
	self:SetUsingCloth("")
end

function mply:SetSpectator()
	self:SetNamesurvivor("Spectator")
	self:Flashlight( false )
	self:AllowFlashlight( false )
	self.handsmodel = nil
	self:Spectate( OBS_MODE_CHASE )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetGTeam(TEAM_SPEC)
	self:SetNoDraw(true)
	if self.SetRoleName then self:SetRoleName(role.Spectator) end
	self.Active = true
	print("adding " .. self:Nick() .. " to spectators")
	self.canblink = false
	self:SetNoTarget( true )
	self.BaseStats = nil
	self.UsingArmor = nil
	timer.Simple(0.1, function()
	self:SetMoveType(MOVETYPE_NOCLIP)
	end)
	//self:Spectate(OBS_MODE_IN_EYE)
end

function mply:SetSCP0082( hp, speed, spawn )
	self:Flashlight( false )
	self.handsmodel = nil
	self:UnSpectate()
	self:GodDisable()
	if spawn then
		self:Spawn()
	end
	self:SetModel("models/player/zombie_classic.mdl")
	self:SetGTeam(TEAM_SCP)
	self:SetHealth(hp)
	self:SetMaxHealth(hp)
	self:SetArmor(0)
	self:SetWalkSpeed(speed)
	self:SetRunSpeed(speed)
	self:SetMaxSpeed(speed)
	self:SetJumpPower(200)
	self:SetNoDraw(false)
	self:SetRoleName(role.SCP0082)
	self.Active = true
	print("adding " .. self:Nick() .. " to zombies")
	self:SetupHands()
	if !spawn then
		WinCheck()
	end
	self.canblink = false
	self.noragdoll = false
	self:AllowFlashlight( false )
	self.WasTeam = TEAM_SCP
	self:SetNoTarget( true )
	net.Start("RolesSelected")
	net.Send(self)
	self:Give("weapon_br_zombie_infect")
	self:SelectWeapon("weapon_br_zombie_infect")
	self.BaseStats = nil
	self.UsingArmor = nil
	self:SetupHands()
end

function mply:SetInfectD()
end

function mply:SetInfectMTF()
end

function mply:SetupNormal()
	self.BaseStats = nil
	self.UsingArmor = nil
	self.handsmodel = nil
	self:UnSpectate()
	self:Spawn()
	self:GodDisable()
	self:SetNoDraw(false)
	self:SetNoTarget(false)
	self:SetupHands()
	self:RemoveAllAmmo()
	self:StripWeapons()
	self.canblink = true
	self.noragdoll = false
	self.scp1471stacks = 1
end

function mply:SetupAdmin()
end

function mply:SurvivorCleanUp()
	self:ClearBodyGroups()
	local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", self ) || {} if self:GTeam() != TEAM_SCP then for i = 1, #tbl_bonemerged do local bonemerge = tbl_bonemerged[ i ] bonemerge:Remove() end
	self:StripWeapons()
	self:SetSkin(0)
	self:StripAmmo()
	self:SetNW2Bool("Breach:CanAttach", false)
	self:SetUsingCloth("")
	self:SetUsingHelmet("")
	self:SetUsingArmor("")
	self:SetUsingBag("")
    end
end

function mply:SelectAsCISpy()
	local chage = math.random( 1, 3 )
	local pvtci = BREACH_ROLES.SECURITY.security.roles[1].weapons
	local oficerci = BREACH_ROLES.SECURITY.security.roles[3].weapons
	local specici = BREACH_ROLES.SECURITY.security.roles[7].weapons
	if chage == 1 then
	timer.Simple(0.1, function()
	self:SetBodygroup(3,7)
	self:SetBodygroup(4,1)
	self:SetBodygroup(5,2)
	self:SetBodygroup(6,1)
	self:Bonemerge("models/cultist/heads/male/male_head_"..math.random(1,210)..".mdl",self)
	self:Bonemerge(BREACH_ROLES.SECURITY.security.roles[1].headgear, self)
	self:StripWeapons()
	for k, v in pairs( pvtci ) do
	self:BreachGive( v ) 
	end 
	end)
	elseif chage == 2 then
	timer.Simple(0.1, function()
	self:SetBodygroup(3,4)
	self:SetBodygroup(5,2)
	timer.Simple(0.1, function()
	self:Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].head, self)
	self:Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].headgear, self)
	end)
	self:StripWeapons()
	for k, v in pairs( oficerci ) do
	self:BreachGive( v ) 
	end 
	end)
	elseif chage == 3 then
	timer.Simple(0.1, function()
	self:SetBodygroup(3,5)
	self:SetBodygroup(5,1)
	self:Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].head, self)
	self:Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].headgear, self)
	self:StripWeapons()
	for k, v in pairs( specici ) do
	self:BreachGive( v ) 
	end 
	end)
	end
end

function mply:ApplyRoleStats( role )
	self:SurvivorCleanUp()
	self:SetRoleName( role.name )
	self:SetGTeam( role.team )
	if role.cispy == true then self:SelectAsCISpy() end
	timer.Simple(0.1, function() if role.weapons and role.weapons != "" then for k,v in pairs(role.weapons) do self:Give(v) end end if role.keycard and role.keycard != "" then self:Give("breach_keycard_"..role.keycard) end end)
	timer.Simple(0.2, function() self:StripAmmo() if role.ammo then end end)
	local selfmodel = {role.models}
	local finalselfmodel = selfmodel[math.random(1, #selfmodel)]
	self:ClearBodyGroups()
	if role.models and role.fmodels then
		selfmodel = {role.fmodels, role.models}
		finalselfmodel = selfmodel[math.random(1, #selfmodel)]
		if finalselfmodel == role.fmodels then
		self:SetModel(table.Random(role.fmodels))
		else
		selfmodel = {role.models}
		self:SetModel(table.Random(role.models))
		end
	else
		selfmodel = {role.models}
		self:SetModel(table.Random(role.models))
	end
	if role.maxslots then
		self:SetMaxSlots(role.maxslots)
	end
	self:Namesurvivor()
	if role.usehead and finalselfmodel != role.fmodels and role.randomizehead != nil and role.randomizehead != true then
		self:Bonemerge("models/cultist/heads/male/male_head_1.mdl",self)
   elseif finalselfmodel == role.fmodels then 
	   self:Bonemerge("models/cultist/heads/female/female_head_1.mdl",self)
   end
    if role.randomizehead and finalselfmodel != role.fmodels and role.randomizehead != nil then
		 self:Bonemerge("models/cultist/heads/male/male_head_"..math.random(1,210)..".mdl",self)
	elseif finalselfmodel == role.fmodels then 
		self:Bonemerge("models/cultist/heads/female/female_head_"..math.random(1,52)..".mdl",self)
    end
	if role.hackerhat then
		self:Bonemerge(role.hackerhat, self)
	end
	--if role.damage_modifiers then
	--	self:ScaleDamage(role.damage_modifiers[hitgroup])
	--end
	if role.skin then self:SetSkin(role.skin) end
	if role.head and (finalselfmodel != role.fmodels) then self:Bonemerge(role.head, self) end
	if role.hair and (finalselfmodel != role.fmodels) then self:Bonemerge(table.Random(role.hair), self) end
	if role.headgear then self:Bonemerge(role.headgear, self) end
	if role.hairm and (finalselfmodel != role.fmodels) then self:Bonemerge(table.Random(role.hairm), self) end
	if role.hairf and (finalselfmodel == role.fmodels) then self:Bonemerge(table.Random(role.hairf), self) end
	if role.bodygroups then self:SetBodyGroups( role.bodygroups ) end
	self:SetNWString("AbilityName", "")
	self.AbilityTAB = nil
	self:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")
	self:SetSpecialMax(0)
	self:SetSpecialCD(10)
	if role.ability then
        net.Start("SpecialSCIHUD")
        net.WriteString(role["ability"][1])
        net.WriteUInt(role["ability"][2], 9)
        net.WriteString(role["ability"][3])
        net.WriteString(role["ability"][4])
        net.WriteBool(role["ability"][5])
        net.Send(self)
        self:SetNWString("AbilityName", (role["ability"][1]))
	end
    if role.ability_max then
	   self:SetSpecialMax( role["ability_max"] )
    end
	self:SetHealth(role.health)
	self:SetMaxHealth(role.health)
	if role.walkspeed then self:SetWalkSpeed(100 * role.walkspeed or 100 * 1) end
	if role.runspeed then self:SetRunSpeed(210 * role.runspeed or 210 * 1) end
	if role.jumppower then self:SetJumpPower(190 * role.jumppower or 190 * 1) end
	if role.bodygroup0 then self:SetBodygroup(0, role.bodygroup0)end
	if role.bodygroup1 then self:SetBodygroup(1, role.bodygroup1)end
	if role.bodygroup2 then self:SetBodygroup(2, role.bodygroup2)end
	if role.bodygroup3 then self:SetBodygroup(3, role.bodygroup3)end
	if role.bodygroup4 then self:SetBodygroup(4, role.bodygroup4)end
	if role.bodygroup5 then self:SetBodygroup(5, role.bodygroup5)end
	if role.bodygroup6 then self:SetBodygroup(6, role.bodygroup6) end
	if role.bodygroup7 then self:SetBodygroup(7, role.bodygroup7) end
	if role.bodygroup8 then self:SetBodygroup(8, role.bodygroup8) end
	if role.bodygroup9 then self:SetBodygroup(9, role.bodygroup9) end
	if role.maxslots then self:SetMaxSlots(role.maxslots) end
	timer.Simple(2,function() if self:GTeam() == TEAM_CLASSD then self:SetSkin(math.random(1,7)) end end)
	self:Flashlight( false )
	net.Start("RolesSelected")
	net.Send(self)
	self:SetupHands()
end

function mply:SetSecurityI1()
	local thebestone = nil
	local usechaos = false
	if math.random(1,6) == 6 then usechaos = true end
	for k,v in pairs(BREACH_ROLES["security"]["roles"]) do
		if v.importancelevel == 1 then
			local skip = false
			if usechaos == true then
				if v.team == TEAM_GUARD then
					skip = true
				end
			else
				if v.team == TEAM_CHAOS then
					skip = true
				end
			end
			if skip == false then
				local can = true
				if v.customcheck != nil then
					if v.customcheck(self) == false then
						can = false
					end
				end
				local using = 0
				for _,pl in pairs(player.GetAll()) do
					if pl:GetRoleName() == v.name then
						using = using + 1
					end
				end
				if using >= v.max then can = false end
				if can == true then
					if self:GetLevel() >= v.level then
						if thebestone != nil then
							if thebestone.sorting < v.sorting then
								thebestone = v
							end
						else
							thebestone = v
						end
					end
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = BREACH_ROLES["security"]["roles"][1]
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end

function mply:SetClassD()
	self:SetRoleBestFrom("classd")
end

function mply:SetResearcher()
	self:SetRoleBestFrom("sci")
end

function mply:SetRoleBestFrom(role)
	local thebestone = nil
	for k,v in pairs(BREACH_ROLES[role]["roles"]) do
		local can = true
		if v.customcheck != nil then
			if v.customcheck(self) == false then
				can = false
			end
		end
		local using = 0
		for _,pl in pairs(player.GetAll()) do
			if pl:GetRoleName() == v.name then
				using = using + 1
			end
		end
		if using >= v.max then can = false end
		if can == true then
			if self:GetLevel() >= v.level then
				if thebestone != nil then
					if thebestone.level < v.level then
						thebestone = v
					end
				else
					thebestone = v
				end
			end
		end
	end
	if thebestone == nil then
		thebestone = BREACH_ROLES.CLASSD[role]["roles"][1]
	end
	if thebestone == BREACH_ROLES.CLASSD["classd"]["roles"][4] and #player.GetAll() < 4 then
		thebestone = BREACH_ROLES.CLASSD["classd"]["roles"][3]
	end
	if ( GetConVar("br_dclass_keycards"):GetInt() != 0 ) then
		if thebestone == BREACH_ROLES.CLASSD["classd"]["roles"][1] then thebestone = BREACH_ROLES.CLASSD["classd"]["roles"][2] end
	else
		if thebestone == BREACH_ROLES.CLASSD["classd"]["roles"][2] then thebestone = BREACH_ROLES.CLASSD["classd"]["roles"][1] end
	end
	self:SetupNormal()
	self:ApplyRoleStats(thebestone)
end

function mply:IsActivePlayer()
	return self.Active
end

hook.Add( "KeyPress", "keypress_spectating", function( ply, key )
	if ply:GTeam() != TEAM_SPEC or ply:GetRoleName() == role.ADMIN then return end
	if ( key == IN_ATTACK ) then
		ply:SpectatePlayerLeft()
	elseif ( key == IN_ATTACK2 ) then
		ply:SpectatePlayerRight()
	elseif ( key == IN_RELOAD ) then
		ply:ChangeSpecMode()
	end
end )

function mply:SpectatePlayerRight()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly - 1
	if self.SpecPly < 1 then
		self.SpecPly = #allply 
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
		end
	end
end

function mply:SpectatePlayerLeft()
	if !self:Alive() then return end
	if self:GetObserverMode() != OBS_MODE_IN_EYE and
	   self:GetObserverMode() != OBS_MODE_CHASE 
	then return end
	self:SetNoDraw(true)
	local allply = GetAlivePlayers()
	if #allply == 1 then return end
	if not self.SpecPly then
		self.SpecPly = 0
	end
	self.SpecPly = self.SpecPly + 1
	if self.SpecPly > #allply then
		self.SpecPly = 1
	end
	for k,v in pairs(allply) do
		if k == self.SpecPly then
			self:SpectateEntity( v )
		end
	end
end

function mply:ChangeSpecMode()
	if !self:Alive() then return end
	if !(self:GTeam() == TEAM_SPEC) then return end
	self:SetNoDraw(true)
	local m = self:GetObserverMode()
	local allply = #GetAlivePlayers()
	if allply < 2 then
		self:Spectate(OBS_MODE_ROAMING)
		return
	end
	/*
	if m == OBS_MODE_CHASE then
		self:Spectate(OBS_MODE_IN_EYE)
	else
		self:Spectate(OBS_MODE_CHASE)
	end
	*/
	
	if m == OBS_MODE_IN_EYE then
		self:Spectate(OBS_MODE_CHASE)	
	elseif m == OBS_MODE_CHASE then
		if GetConVar( "br_allow_roaming_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_ROAMING)
		elseif GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
		else
			self:SpectatePlayerLeft()
		end	
	elseif m == OBS_MODE_ROAMING then
		if GetConVar( "br_allow_ineye_spectate" ):GetInt() == 1 then
			self:Spectate(OBS_MODE_IN_EYE)
			self:SpectatePlayerLeft()
		else
			self:Spectate(OBS_MODE_CHASE)
			self:SpectatePlayerLeft()
		end
	else
		self:Spectate(OBS_MODE_ROAMING)
	end
end

function mply:SaveExp()
	self:SetPData( "breach_exp", self:GetExp() )
end

function mply:SaveLevel()
	self:SetPData( "breach_level", self:GetLevel() )
end

function mply:AddExp(amount, msg)
	amount = amount * GetConVar("br_expscale"):GetInt()
	if self.Premium == true then
		amount = amount * GetConVar("br_premium_mult"):GetFloat()
	end
	amount = math.Round(amount)
	if not self.GetNEXP then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNEXP and self.SetNEXP then
		self:SetNEXP( self:GetNEXP() + amount )
		if msg != nil and self:GTeam() == TEAM_SPEC then
			self:BrTip( 0, "[VAULT]", Color(255,0,0, 210), " Вы получили " .. amount .. " Опыта, Текущий опыт: " .. self:GetNEXP(), color_white )
		end
		self:SetPData( "breach_exp", self:GetExp() )
	else
		if self.SetNEXP then
			self:SetNEXP( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNEXP invalid" )
		end
		local xp = self:GetNEXP()
		local lvl = self:GetNLevel()
		if lvl == 0 then
			if xp >= 3000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 3000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 1! Congratulations!")
			end
		elseif lvl == 1 then
			if xp >= 5000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 5000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 2! Congratulations!")
			end
		elseif lvl == 2 then
			if xp >= 7500 then
				self:AddLevel(1)
				self:SetNEXP(xp - 7500)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 3! Congratulations!")
			end
		elseif lvl == 3 then
			if xp >= 11000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 11000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 4! Congratulations!")
			end
		elseif lvl == 4 then
			if xp >= 14000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 14000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level 5! Congratulations!")
			end
		elseif lvl == 5 then
			if xp >= 25000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 25000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level OMNI! Congratulations!")
			end
		elseif lvl == 6 then
			if xp >= 100000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 100000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " is a now a Veteran! Congratulations!")
			end
		elseif lvl > 6 then
			if xp >= 100000 then
				self:AddLevel(1)
				self:SetNEXP(xp - 100000)
				self:SaveLevel()
				PrintMessage(HUD_PRINTTALK, self:Nick() .. " reached level "..lvl.."! Congratulations!")
		end
		self:SetPData( "breach_exp", self:GetExp() )
	else
		if self.SetNEXP then
			self:SetNEXP( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNEXP invalid" )
		end
      end
    end
end

function mply:AddLevel(amount)
	if not self.GetNLevel then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNLevel and self.SetNLevel then
		self:SetNLevel( self:GetNLevel() + amount )
		self:SetPData( "breach_level", self:GetNLevel() )
	else
		if self.SetNLevel then
			self:SetNLevel( 0 )
		else
			ErrorNoHalt( "Cannot set the exp, SetNLevel invalid" )
		end
	end
end

function mply:SurvivorSetRoleName(name)
	local rl = nil
	for k,v in pairs(BREACH_ROLES) do
		for _,role in pairs(v.roles) do
			if role.name == name then
				rl = role
			end
		end
	end
	if rl != nil then
		self:ApplyRoleStats(rl)
	end
end

function mply:SetActive( active )
	self.ActivePlayer = active
	self:SetNActive( active )
	if !gamestarted then
		CheckStart()
	end
end

function mply:ToggleAdminModePref()
	if self.admpref == nil then self.admpref = false end
	if self.admpref then
		self.admpref = false
		if self.AdminMode then
			self:ToggleAdminMode()
			self:SetSpectator()
		end
	else
		self.admpref = true
		if self:GetRoleName() == role.Spectator then
			self:ToggleAdminMode()
			self:SetupAdmin()
		end
	end
end

function mply:ToggleAdminMode()
	if self.AdminMode == nil then self.AdminMode = false end
	if self.AdminMode == true then
		self.AdminMode = false
		self:SetActive( true )
		self:DrawWorldModel( true ) 
	else
		self.AdminMode = true
		self:SetActive( false )
		self:DrawWorldModel( false ) 
	end
end
