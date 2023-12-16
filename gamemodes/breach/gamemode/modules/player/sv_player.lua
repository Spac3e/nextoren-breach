local mply = FindMetaTable( "Player" )
local ment = FindMetaTable( "Entity" )

function mply:AddToMVP()
end

function mply:AddSpyDocument()
	self:SetNWInt("CollectedDocument", 1)
end

function mply:SetOnFire(time)
    if timer.Exists(self:SteamID64().."Fireing") then return end
    if self:Health() < 10 then
        self:SetMoveType(MOVETYPE_OBSERVER)
        self:SetNWEntity("NTF1Entity", self)
		self:SetNWBool("RXSEND_ONFIRE", true)
        self:SetForcedAnimation("mpf_idleonfire", 20)
        self:EmitSound("nextoren/charactersounds/hurtsounds/hg_onfire0"..math.random(1,4)..".wav", 75, 100, 1, CHAN_WEAPON)

        for _, v in pairs(self:LookupBonemerges()) do
            v:SetInvisible(true)
        end

        timer.Create(self:SteamID64().."Fireing", time, 1, function()
            self:StopParticles()
            self:SetNWEntity("NTF1Entity", NULL)
            self:SetNWAngle("ViewAngles", Angle(0, 0, 0))
            self:SetMoveType(MOVETYPE_WALK)
            self:SetModel("models/cultist/humans/corpse.mdl")
			self.burnttodeath = true
            self:Kill()
			timer.Simple(1,function()
			self:SetNWBool("RXSEND_ONFIRE", false)
			self.burnttodeath = false
			end)
        end)
    else
        self:TakeDamage(3.5, self, DMG_BURN)
        self:SetNWBool("RXSEND_ONFIRE", true)
        timer.Simple(1, function()
            self:SetNWBool("RXSEND_ONFIRE", false)
        end)
        self:EmitSound("nextoren/charactersounds/hurtsounds/fire/pl_burnpain0"..math.random(1,6)..".wav", 75, 100, 1, CHAN_WEAPON)
    end
end

function mply:LevelBar()
end

function mply:SetForcedAnimation(sequence, endtime, startcallback, finishcallback, stopcallback)
	if sequence == false then
		self:StopForcedAnimation()
		return
	end	
	  
	if isstring(sequence) then sequence = self:LookupSequence(sequence) end
	self:SetCycle(0)
	self.ForceAnimSequence = sequence
	
	time = endtime
	
	if endtime == nil then
		time = self:SequenceDuration(sequence)
	end		  
	
	net.Start("BREACH_SetForcedAnimSync")
	net.WriteEntity(self)
	net.WriteUInt(sequence, 20) -- seq cock
	net.Broadcast()
	
	if isfunction(startcallback) then startcallback() end
	
	self.StopFAnimCallback = stopcallback
	
	timer.Create("SeqF"..self:EntIndex(), time, 1, function()
		if (IsValid(self)) then
			self.ForceAnimSequence = nil
			
			net.Start("BREACH_EndForcedAnimSync")
			net.WriteEntity(self)
			net.Broadcast()
			
			self.StopFAnimCallback = nil
			
			if isfunction(finishcallback) then
			  finishcallback()
			end
		end
	end)
end

function mply:ClearBodyGroups()
    for _, v in pairs(self:GetBodyGroups()) do
        self:SetBodygroup(v.id, 0)
    end
end

function mply:AddToStatistics(reason,value)
end

function GM:PlayerSpray(ply)
    return !ply:IsSuperAdmin()
end

function mply:AddToAchievementPoint()
end

function GetAlivePlayers()
	local players = {}
	for k,v in pairs(player.GetAll()) do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() then
				table.ForceInsert(players, v)
			end
		end
	end
	return players
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

function mply:AddHealth(number)
	local health, max = self:Health(), self:GetMaxHealth()
	local new = health + number
	self:SetHealth(math.min(new, max))
end

function mply:AnimatedHeal(amount)
    local maxHealth = self:GetMaxHealth()
    local targetHealth = math.min(self:Health() + amount, maxHealth)
    local startTime = CurTime()
    local timerName = "AnimatedHeal_" .. self:EntIndex()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

    timer.Create(timerName, 0.1, 3 / 0.1, function()
        local elapsedTime = CurTime() - startTime

        local currentHealth = Lerp(elapsedTime / 3, self:Health(), targetHealth)

        self:SetHealth(math.min(math.Round(currentHealth), maxHealth))

        if elapsedTime >= 3 then
            timer.Remove(timerName)
        end
    end)
end

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

function mply:UnUseBro()
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

function GhostBoneMerge(entity, model, no_draw, skin, sub_material)
    local bnmrg = ents.Create("ent_bonemerged")
    entity.bonemerge_ent = bnmrg
    entity.bonemerge_ent:SetModel(model)
    entity.bonemerge_ent:SetSkin(entity:GetSkin())
    entity.bonemerge_ent:Spawn()
    entity.bonemerge_ent:SetParent(entity, 0)
    entity.bonemerge_ent:SetLocalPos(vector_origin)
    entity.bonemerge_ent:SetLocalAngles(angle_zero)
    entity.bonemerge_ent:AddEffects(EF_BONEMERGE)
    entity.bonemerge_ent:AddEffects(EF_NOSHADOW)
    entity.bonemerge_ent:AddEffects(EF_NORECEIVESHADOW)

    if skin then
        entity.bonemerge_ent:SetSkin(skin)
    end

    if not entity.BoneMergedEnts then
        entity.BoneMergedEnts = {}
    end

    if sub_material then
        entity.Sub_Material = sub_material
    end

    if no_draw then
        entity.no_draw = true
    end

	if model:find("/heads/") or model:find("/head/") or model:find("/funnyheads/") or model:find("goc/head") or model:find("balaclavas_new") or model:find("balaclavas") and !model:find("hair") then
        entity.HeadEnt = bnmrg
        if entity.Sub_Material then
            local sub_material_id = 0
            if CORRUPTED_HEADS[model] then
                sub_material_id = 1
            end
            entity.bonemerge_ent:SetSubMaterial(sub_material_id, entity.Sub_Material)
        end
    end

    if no_draw then
        entity.bonemerge_ent.no_draw = no_draw
    end

    entity.BoneMergedEnts[#entity.BoneMergedEnts + 1] = entity.bonemerge_ent

    return bnmrg
end

function Bonemerge(model, entity, skin, sub_material)
    local bnmrg = ents.Create("ent_bonemerged")
	entity.bonemerge_ent = bnmrg
    entity.bonemerge_ent:SetModel(model)
	entity.bonemerge_ent:Spawn()
	entity.bonemerge_ent:SetOwner( entity )
    entity.bonemerge_ent:SetParent( entity )
	entity.bonemerge_ent:SetLocalPos( vector_origin )
    entity.bonemerge_ent:SetLocalAngles( angle_zero )
    entity.bonemerge_ent:SetMoveType( MOVETYPE_NONE )
    entity.bonemerge_ent:AddEffects( EF_BONEMERGE )
    entity.bonemerge_ent:AddEffects( EF_BONEMERGE_FASTCULL )
    entity.bonemerge_ent:AddEffects( EF_PARENT_ANIMATES )

	if ( skin ) then
		entity.bonemerge_ent:SetSkin( skin )
	end
	
	
	if ( sub_material ) then
		entity.Sub_Material = sub_material
	end

	if ( !entity.BoneMergedEnts ) then
		entity.BoneMergedEnts = {}
	end

	if model:find("/heads/") or model:find("/head/") or model:find("/funnyheads/") or model:find("goc/head") or model:find("balaclavas_new") or model:find("balaclavas") and !model:find("hair") then
        entity.HeadEnt = bnmrg
        if entity.Sub_Material then
            local sub_material_id = 0
            if CORRUPTED_HEADS[model] then
                sub_material_id = 1
            end
            entity.bonemerge_ent:SetSubMaterial(sub_material_id, entity.Sub_Material)
        end
    end

	entity.BoneMergedEnts[ #entity.BoneMergedEnts + 1 ] = entity.bonemerge_ent

	return bnmrg
end

function mply:PrintTranslatedMessage( string )
	net.Start( "TranslatedMessage" )
		net.WriteString( string )
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

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:UnUseArmor()
	if self:GetUsingCloth() == "armor_goc" or self:GetModel():find("goc.mdl") or self:GetUsingCloth() == "" then return end
	self:SetModel(self.OldModel)
	self:SetSkin(self.OldSkin)
	self:SetupHands()

	for k,v in pairs(self:LookupBonemerges()) do
		if v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or v:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_full.mdl" then v:Remove() end
		v:SetInvisible(false)
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
	self:Flashlight( false )
	self:AllowFlashlight( false )
	self:StripWeapons()
	self:RemoveAllAmmo()
	self:SetRoleName(role.Spectator)
	self:SetTeam(TEAM_SPEC)
	self:SetGTeam(TEAM_SPEC)
	self:SetModel("models/props_junk/watermelon01.mdl")
	self:SetNoDraw(true)
	self:SetNoTarget(true)
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:InvalidatePlayerForSpectate()

	local plys = self:GetValidSpectateTargets()

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetObserverMode(OBS_MODE_ROAMING)
	else
		self:Spectate( OBS_MODE_CHASE )
		self:SetObserverMode(OBS_MODE_CHASE)
		self:SpectateEntity( plys[1] )
	end

	self.Active = true
	self.BaseStats = nil
	self.UsingArmor = nil
	self.canblink = false
	self.handsmodel = nil
	self.alreadyselectedscp = false
end


function mply:InvalidatePlayerForSpectate()
	local roam = #self:GetValidSpectateTargets() < 1

	for k, v in pairs( player.GetAll() ) do
		if v:GTeam() == TEAM_SPEC then

	if v != self then
		if v:GetObserverTarget() == self then
			if roam then
				v:UnSpectate()
				v:Spectate( OBS_MODE_ROAMING )
				v:SetObserverMode(OBS_MODE_CHASE)
			else
				v:SpectatePlayerNext()
			end
		end
	end
end
end
end

function mply:GetValidSpectateTargets( all )
	local plys = {}

	for k, v in pairs(player.GetAll()) do
		if all then
			table.insert( plys, v )
		else
			if v:GTeam() != TEAM_SPEC then
				table.insert( plys, v )
			end
		end
	end

	return plys
end

function mply:SpectatePlayerNext()
	if self:GTeam() != TEAM_SPEC then return end

	self:SetMoveType(MOVETYPE_NOCLIP)

	local plys = self:GetValidSpectateTargets()
	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #plys > 0 then
			self:Spectate( OBS_MODE_CHASE )
			self:SetObserverMode(OBS_MODE_CHASE)
		else
			return
		end
	end

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetObserverMode(OBS_MODE_ROAMING)
		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( plys ) do
			if v == cur_target then
				index = i + 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index > #plys then
		index = 1
	end

	local target = plys[index]

	if target != cur_target then
		self:SpectateEntity( target )
	end
end

function mply:SpectatePlayerPrev()
	if self:GTeam() != TEAM_SPEC then return end

	local plys = self:GetValidSpectateTargets()

	self:SetMoveType(MOVETYPE_NOCLIP)

	if self:GetObserverMode() == OBS_MODE_ROAMING then
		if #plys > 0 then
			self:Spectate( OBS_MODE_CHASE )
			self:SetObserverMode(OBS_MODE_CHASE)
		else
			return
		end
	end

	if #plys < 1 then
		self:UnSpectate()
		self:Spectate( OBS_MODE_ROAMING )
		self:SetObserverMode(OBS_MODE_ROAMING)
		return
	end

	local cur_target = self:GetObserverTarget()
	local index

	if !IsValid( cur_target ) then
		index = 1
	else
		for i, v in ipairs( plys ) do
			if v == cur_target then
				index = i - 1
				break
			end
		end
	end

	if !index then index = 1 end

	if index < 1 then
		index = #plys
	end

	local target = plys[index]

	if target != cur_target then
		self:SpectateEntity( target )
	end
end

function mply:ChangeSpectateMode()
	if self:GTeam() != TEAM_SPEC then return end

	local cur_mode = self:GetObserverMode()

	if #self:GetValidSpectateTargets() < 1 then
		if cur_mode != OBS_MODE_ROAMING then
			self:UnSpectate()
			self:Spectate( OBS_MODE_ROAMING )
			self:SetObserverMode(OBS_MODE_ROAMING)
		end
		return
	end

	if cur_mode == OBS_MODE_ROAMING then
		self:Spectate( OBS_MODE_CHASE )
		self:SetObserverMode(OBS_MODE_CHASE)
		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SpectatePlayerNext()
	elseif cur_mode == OBS_MODE_CHASE then
		self:Spectate( OBS_MODE_ROAMING )
		self:SetObserverMode(OBS_MODE_ROAMING)
	end
end

function GM:KeyPress( ply, key )
	if ply:GTeam() != TEAM_SPEC or ply:IsBot() then return end
	if key == IN_ATTACK then
		ply:SpectatePlayerNext()
		if ply:GetMoveType() != 8 then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	elseif key == IN_ATTACK2 then
		ply:SpectatePlayerPrev()
		if ply:GetMoveType() != 8 then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	elseif key == IN_RELOAD then
		ply:ChangeSpectateMode()
		if ply:GetMoveType() != 8 then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	end
end

function mply:SetSCP0082( hp, speed, spawn )
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

function UIUSpy_MakeDocuments()
    local igroki_s_documentami = {}

    for _, ply in ipairs(player.GetAll()) do
        if ply:GTeam() != TEAM_SCP or ply:GTeam() != TEAM_SPEC or ply:GetRoleName() != "UIU Spy" then
            table.insert(igroki_s_documentami, ply)
        end
    end

    if #igroki_s_documentami >= 3 then
        for i = 1, 3 do
            local index = math.random(1, #igroki_s_documentami)
            local target = igroki_s_documentami[index]
            
            target:Give("item_special_document")
            target:RXSENDNotify("Вы являетесь важным сотрудником фонда! При себе вы имеете важные документы, которые вы должны эвакуировать и не умереть.")
            target:SetNWBool("Have_docs", true)

            table.remove(igroki_s_documentami, index)
        end
    end
end

BREACH.ZombieTextureMaterials = {
	"models/all_scp_models/shared/arms_new",
	"models/all_scp_models/class_d/arms",
	"models/all_scp_models/class_d/arms_b",
	"models/all_scp_models/mog/skin_full_arm_wht_col",
	"models/all_scp_models/class_d/fatheads/fat_head",
	"models/all_scp_models/class_d/fatheads/fat_torso",
	"models/all_scp_models/class_d/body_b",
	"models/all_scp_models/class_d/prisoner_lt_head_d",
	"models/all_scp_models/shared/f_hands/f_hands_white",
	"models/all_scp_models/shared/heads/female/head_1",
	"models/all_scp_models/cultists/vrancis_head",
	"models/all_scp_models/cultists/footmale",
	"models/all_scp_models/sci/shirt_boss",
	"models/all_scp_models/sci/dispatch/dispatch_head",
	"models/all_scp_models/sci/dispatch/dispatch_face",
	"models/all_scp_models/sci/dispatch/skirt",
	"models/all_scp_models/special_sci/special_4/head_sci_4",
	"models/all_scp_models/special_sci/special_4/face_sci_4",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_head",
	"models/all_scp_models/special_sci/sci_3_materials/sci_3_face",
	"models/all_scp_models/special_sci/arms",
	"models/all_scp_models/special_sci/tex_0160_0",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_face",
	"models/all_scp_models/special_sci/sci_2_materials/sci_2_head",
	"models/all_scp_models/special_sci/special_1/face_sci_1",
	"models/all_scp_models/special_sci/special_1/head_sci_1",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_face",
	"models/all_scp_models/special_sci/sci_7_materials/sci_7_head",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_face",
	"models/all_scp_models/special_sci/sci_9_materials/sci_9_head",
	"models/all_scp_models/special_sci/mutantskin_diff",
	"models/all_scp_models/special_sci/zed_hans_d",
	"models/all_scp_models/special_sci/spes_head"
}

function ment:MakeZombieTexture()
	for i, material in pairs(self:GetMaterials()) do
		i = i -1
		if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
			if string.StartWith(material, "models/all_scp_models/") then
				local str = string.sub(material, #"models/all_scp_models//")
				str = "models/all_scp_models/zombies/"..str
				self:SetSubMaterial(i, str)
			end
		else
			self:SetSubMaterial(i, "!ZombieTexture")
		end
	end
end

function ment:MakeZombie()
	self:MakeZombieTexture()
	for _, bnmrg in pairs(self:LookupBonemerges()) do
		if bnmrg:GetModel():find("male_head") or bnmrg:GetModel():find("balaclava") then
			self.FaceTexture = "models/all_scp_models/zombies/shared/heads/head_1_1"
			if CORRUPTED_HEADS[bnmrg:GetModel()] then
				bnmrg:SetSubMaterial(1, self.FaceTexture)
			else
				bnmrg:SetSubMaterial(0, self.FaceTexture)
			end
		else
			bnmrg:MakeZombieTexture()
		end
	end
end

function mply:SetupZombie()
	local victim = self
	victim:SetNoDraw(false)
	victim:SetDSP(1)
	victim:SetNWEntity("NTF1Entity", victim)
	victim:SetGTeam(TEAM_SCP)
	victim.IsZombie = true
	victim:Freeze(true)
	victim.ScaleDamage = {
		["HITGROUP_HEAD"] = .35,
		["HITGROUP_CHEST"] = .35,
		["HITGROUP_LEFTARM"] = .35,
		["HITGROUP_RIGHTARM"] = .35,
		["HITGROUP_STOMACH"] = .35,
		["HITGROUP_GEAR"] = .35,
		["HITGROUP_LEFTLEG"] = .35,
		["HITGROUP_RIGHTLEG"] = .35
	}
	victim.Stamina = 100
	victim:SetMaxHealth(victim:GetMaxHealth() * 2)
	victim:SetHealth(victim:GetMaxHealth())
	victim:MakeZombie()
	victim:StripWeapons()
	victim:BreachGive("weapon_scp_049_2")
	timer.Create("Safe_WEAPON_SELECT_"..victim:SteamID64(), FrameTime(), 99999, function()
		if !IsValid(victim:GetActiveWeapon()) or victim:GetActiveWeapon():GetClass() != "weapon_scp_049_2" then
			victim:SelectWeapon("weapon_scp_049_2")
		else
			timer.Remove("Safe_WEAPON_SELECT_"..victim:SteamID64())
		end
	end)
	victim:SetForcedAnimation("breach_zombie_getup", victim:SequenceDuration(victim:LookupSequence("breach_zombie_getup")), nil, function()
		victim:SetMoveType(MOVETYPE_WALK)
		victim:Freeze(false)
		victim:SetNotSolid(false)
		victim:SetNWEntity("NTF1Entity", NULL)
	end)
end

function mply:SetStamina(float)
	net.Start("SetStamina", true)
	net.WriteFloat(float)
	net.WriteBool(false)
	net.Send(self)
end

function mply:AddStamina(float)
	net.Start("SetStamina", true)
	net.WriteFloat(float)
	net.WriteBool(true)
	net.Send(self)
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if ply.IsZombie == true then
		local vel = ply:GetVelocity():Length2DSqr()
		if ( vel > 22500 ) then
			if IsValid(ply:GetActiveWeapon()) then
				ply:EmitSound( "^nextoren/charactersounds/zombie/foot"..math.random(1,3)..".wav", 75, math.random( 100, 120 ), volume * .8 )
			else
				ply:EmitSound( "^nextoren/charactersounds/zombie/foot"..math.random(1,3)..".wav", 75, math.random( 100, 120 ), volume * .8 )
			end
		end
	end
end

function mply:SurvivorCleanUp()
	self:SetNamesurvivor("none")
    self:ClearBodyGroups()
    self:SetSkin(0)

	for k,v in pairs(self:LookupBonemerges()) do
		if CORRUPTED_HEADS[v:GetModel()] then
			v:SetSubMaterial(1, 0)
		else
			v:SetSubMaterial(0, 0)
		end
	   v:Remove()
    end

	for i, material in pairs(self:GetMaterials()) do
		i = i -1
		self:SetSubMaterial(i, 0)
	end

	self.IsZombie = false
	self:StripWeapons()
	self:StripAmmo()
	self:SetNW2Bool("Breach:CanAttach", false)
	self:SetUsingBag("")
	self:SetUsingCloth("")
	self:SetUsingArmor("")
	self:SetUsingHelmet("")
	self:SetStamina(200)
	self:SetNWBool("Have_docs", false)
	self:Flashlight(false)
	self:SetBoosted(false)
	self:SetForcedAnimation(false)
	self:SetMaxSlots(8)
	self:SetInDimension(false)

	self:SetSpecialMax(0)
	self:SetNWString("AbilityName", "")
	self.AbilityTAB = nil
	self:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")
end

function mply:SetupCISpy()
	local rand = math.random(1, 3)
	if rand == 1 then
			self:SetBodygroup(3, 7)
			self:SetBodygroup(4, 1)
			self:StripWeapons()
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[1].headgear, self)
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[1].weapons) do
				self:Give(v)
				self:Give("breach_keycard_security_1")
				self:Give("item_tazer")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
	elseif rand == 2 then
		    for k,v in pairs(self:LookupBonemerges()) do v:Remove() end
			self:SetBodygroup(3, 4)
			self:SetBodygroup(5, 2)
				Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].head, self)
				Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].headgear, self)
			self:StripWeapons()
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[3].weapons) do
				self:Give(v)
				self:Give("breach_keycard_security_2")
				self:Give("item_tazer")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
	elseif rand == 3 then 
		    for k,v in pairs(self:LookupBonemerges()) do v:Remove() end
			self:SetBodygroup(3, 5)
			self:SetBodygroup(5, 1)
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].head, self)
			Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].headgear, self)
			self:StripWeapons()
			for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[7].weapons) do
				self:Give(v)
				self:Give("item_tazer")
				self:Give("breach_keycard_security_2")
				self:StripAmmo()
				self:GetWeapon("item_tazer"):SetClip1(20)
		    end
	  end
end

function SetupRadio(ply,gteam,role)
	timer.Simple(0.1,function()
	net.Start("SetFrequency")
	net.WriteEntity(ply:GetWeapon("item_radio"))
	net.WriteFloat(Radio_GetChannel(gteam,role))
	net.Send(ply)
	ply:GetWeapon("item_radio").Channel = Radio_GetChannel(gteam,role)
	end)
end

function mply:ApplyRoleStats(role)
	self:SetRoleName( role.name )
	self:SetGTeam( role.team )

	self.kills = 0
	self.teamkills = 0
	self.TempValues = {}

	local isblack = math.random(1,5) == 1
	if role.white == true then isblack = false end
	local HeadModel = istable(role["head"]) and table.Random(role["head"]) or role["head"]

	if role.models and role.fmodels then
		local selfmodel
	
		if math.random(0, 1) == 0 then
			selfmodel = role.fmodels
		else
			selfmodel = role.models
		end
	
		local finalselfmodel = selfmodel[math.random(1, #selfmodel)]
	
		self:SetModel(finalselfmodel)
	else
		if role.models then
			local finalselfmodel = role.models[math.random(1, #role.models)]
			self:SetModel(finalselfmodel)
		elseif role.fmodels then
			local finalselfmodel = role.fmodels[math.random(1, #role.fmodels)]
			self:SetModel(finalselfmodel)
		end
	end

    self:SurvivorCleanUp()

	if role.head then Bonemerge(HeadModel,self) end

	if role["usehead"] then
		if role["randomizehead"] then
			if self:GetRoleName() == "Class-D Bor" then return end
			if !self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64()), self)
			elseif self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64(), true), self)
			end
		else
			Bonemerge("models/cultist/heads/male/male_head_1.mdl", self)
		end
	end

	if role["randomizeface"] or !role["white"] then
		for k,v in pairs(self:LookupBonemerges()) do
			if CORRUPTED_HEADS[v:GetModel()] then v:SetSubMaterial(1, PickFaceSkin(isblack,self:SteamID64(),false)) end
			if v:GetModel():find("fat_heads") or v:GetModel():find("bor_heads") then continue end
			if v:GetModel():find("heads") or v:GetModel():find("balaclavas_new") then
				if !self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),false))
			elseif
			  self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),true))
			  end
			end
		end
	end

	local HairModel = nil
	if math.random(1, 5) > 1 then
		if isblack and !self:IsFemale() and role["blackhairm"] then
			HairModel = role["blackhairm"][math.random(1, #role["blackhairm"])]
		elseif role["hairm"] and !self:IsFemale() then
			HairModel = role["hairm"][math.random(1, #role["hairm"])]
		elseif role["hairf"] and self:IsFemale() then
			HairModel = role["hairf"][math.random(1, #role["hairf"])]
		end
	end
 
    if HairModel then
		if self:GetRoleName() == "Medic" and !self:IsFemale() then return end
		Bonemerge(HairModel,self)
	end
   	
	if isblack and self:GetModel():find("class_d") then
		self:SetSkin(1)
	end

	if isblack and self:GetRoleName() == "Class-D Bor" then
		for k,v in pairs(self:LookupBonemerges()) do
			if v:GetModel():find("bor_heads") then
				v:SetSkin(1)
			end
		end
	end

	if role.skin then
		self:SetSkin(role.skin)
	elseif !isblack then
		self:SetSkin(0)
	end
	
	if role.headgear then Bonemerge(role.headgear, self) end
	if role.hackerhat then Bonemerge(role.hackerhat, self) end
	if role.bodygroups then self:SetBodyGroups( role.bodygroups ) end

	for i = 0, 9 do
        local bodygroupKey = "bodygroup" .. i
        if role[bodygroupKey] then
            self:SetBodygroup(i, role[bodygroupKey])
        end
    end
	
	if role.cispy then
		self:SetupCISpy()
	end

    if role.weapons and role.weapons ~= "" then
        for _, weapon in pairs(role.weapons) do
            self:Give(weapon)
			if weapon == "item_radio" then
				SetupRadio(self,self:GTeam(),self:GetRoleName())
			end	
			if weapon == "item_tazer" then
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
        end
    end

	if role.keycard and role.keycard != "" then 
		self:Give("breach_keycard_"..role.keycard)
	end 

    self:StripAmmo()

    if role.ammo and role.ammo ~= "" then
        for _, ammo in pairs(role.ammo) do
            self:GiveAmmo(ammo[2], self:GetWeapon(ammo[1]):GetPrimaryAmmoType(), true)
        end
    end

	self:Namesurvivor()
    
	if role.damage_modifiers then
		self.HeadResist = role.damage_modifiers["HITGROUP_HEAD"]
		self.GearResist = role.damage_modifiers["HITGROUP_CHEST"]
		self.StomachResist = role.damage_modifiers["HITGROUP_STOMACH"]
		self.ArmResist = role.damage_modifiers["HITGROUP_RIGHTARM"]
		self.LegResist = role.damage_modifiers["HITGROUP_RIGHTLEG"]
	end

	if role.ability then
		net.Start("SpecialSCIHUD")
		net.WriteString(role["ability"][1])
		net.WriteUInt(role["ability"][2], 9)
		net.WriteString(role["ability"][3])
		net.WriteString(role["ability"][4])
		net.WriteBool(role["ability"][5])
		net.Send(self)
		self:SetNWString("AbilityName", (role["ability"][1]))
		self:SetSpecialCD(0)
	end

    if role.ability_max then
		self:SetSpecialMax( role["ability_max"] )
    end

	self:SetHealth(role.health)
	self:SetMaxHealth(role.health)

	--[[
	if role.walkspeed then
		self:SetWalkSpeed(100 * (role.walkspeed or 1))
    else
  		self:SetWalkSpeed(100)
	end
	--]]

	if role.walkspeed then
		self:SetWalkSpeed(91)
	end

	if role.runspeed then
		self:SetRunSpeed(195 * (role.runspeed or 1))
	else
		self:SetRunSpeed(195)
	end
	
	if self:GetRoleName() == "Class-D Fast" then
		self:SetRunSpeed(231)
	end
	
	if role.jumppower then
		self:SetJumpPower(190 * (role.jumppower or 1))
    else
  		self:SetJumpPower(190)
	end
	
	if role.stamina then 
		self:SetStaminaScale(role.stamina)
	end

	if role.maxslots then 
		self:SetMaxSlots(role.maxslots) 
	end

	if self:GTeam() == TEAM_CLASSD and self:IsPremium() then
        self:SetBodygroup(0, math.random(0, 4))
    end
	
	self:Flashlight( false )
	net.Start("RolesSelected")
	net.Send(self)

	self:SetupHands()

	if self:GetRoleName() == "UIU Spy" and timer.Exists("RoundTime") then
		UIUSpy_MakeDocuments()
	end

end

function mply:IsActivePlayer()
	return self.Active
end

function mply:SaveExp()
	self:SetPData( "breach_exp", self:GetExp() )
end

function mply:SaveLevel()
	self:SetPData( "breach_level", self:GetLevel() )
end

function mply:AddExp(amount, msg)
	--amount = amount * GetConVar("br_expscale"):GetInt()
	--if self.Premium == true then
		--amount = amount * GetConVar("br_premium_mult"):GetFloat()
	--end
	amount = math.Round(amount)
	--if not self.GetNEXP then
	--	player_manager.RunClass( self, "SetupDataTables" )
	--end
	self:SetNEXP( self:GetNEXP() + amount )
	self:SetPData( "breach_exp", self:GetExp() )

	local xp = self:GetNEXP()
	local lvl = self:GetNLevel()

	if xp > (680 * math.max(1, self:GetNLevel())) then
		self:SetNEXP(xp - (680 * math.max(1, self:GetNLevel())))
		self:SetNLevel( self:GetNLevel() + 1 )
		self:SetPData( "breach_level", self:GetNLevel() )
	end

	if self:GetNEXP() < 0 then
		self:SetNEXP(1)
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

hook.Add( "SetupMove", "StanceSpeed", function( ply, mv, cmd )
	local velLength = ply:GetVelocity():Length2DSqr()
	--[[

	if ( mv:KeyReleased( IN_SPEED ) || mv:KeyDown( IN_SPEED ) && velLength < .25 ) then
		ply.Run_fading = true
	end

	if ( mv:KeyDown( IN_SPEED ) && velLength > .25 || ply.SprintMove && !ply.Run_fading ) then

		if ( ply:IsLeaning() ) then
			ply:SetNW2Int( "LeanOffset", 0 )
			ply.OldStatus = nil
		end

		if ( !ply.SprintMove ) then
			ply.Run_fading = nil
			ply.SprintMove = true
			ply.Sprint_Speed = ply:GetWalkSpeed()
		end

		ply.Sprint_Speed = math.Approach( ply.Sprint_Speed, ply:GetRunSpeed(), FrameTime() * 128 )

		mv:SetMaxClientSpeed( ply.Sprint_Speed )
		mv:SetMaxSpeed( ply.Sprint_Speed )

	elseif ( ply.SprintMove && ply.Run_fading ) then
		local walk_Speed = ply:GetWalkSpeed()

		ply.Sprint_Speed = math.Approach( ply.Sprint_Speed, walk_Speed, FrameTime() * 128 )

		mv:SetMaxClientSpeed( ply.Sprint_Speed )
		mv:SetMaxSpeed( ply.Sprint_Speed )

		if ( ply.Sprint_Speed == walk_Speed ) then
			ply.SprintMove = nil
			ply.Sprint_Speed = nil
		end
	end


	if ( ply:Crouching() ) then
		local walk_speed = ply:GetWalkSpeed()

		mv:SetMaxClientSpeed( walk_speed * .5 )
		mv:SetMaxSpeed( walk_speed * .5 )
	end


	local wep = ply:GetActiveWeapon()

	if ( wep != NULL && wep.CW20Weapon && wep.dt.State == CW_AIMING ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * .5 )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * .5 )
	end

	if ( ply:IsLeaning() ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * .75 )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * .75 )
	end

	if ( ply.SpeedMultiplier ) then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed() * ply.SpeedMultiplier )
		mv:SetMaxSpeed( mv:GetMaxSpeed() * ply.SpeedMultiplier )
	end--]]
end)

local ment = FindMetaTable('Entity')

function mply:Make409Statue()

	if self.Used500 then return end

	local ragdoll

	if self:HasWeapon("item_special_document") then
		local document = ents.Create("item_special_document")
		document:SetPos(self:GetPos() + Vector(0,0,20))
		document:Spawn()
		document:GetPhysicsObject():SetVelocity(Vector(table.Random({-100,100}),table.Random({-100,100}),175))
	end

	if !self.DeathAnimation then
		ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(self:GetModel())
		ragdoll:SetSkin(self:GetSkin())

		ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		for i = 0, 9 do
			ragdoll:SetBodygroup(i, self:GetBodygroup(i))
		end
		ragdoll:SetPos(self:GetPos())
		ragdoll:Spawn()
		
		ragdoll:SetMaterial("nextoren/ice_material/icefloor_01_new")

		if ( ragdoll && ragdoll:IsValid() ) then

				for i = 1, ragdoll:GetPhysicsObjectCount() do

					local physicsObject = ragdoll:GetPhysicsObjectNum( i )
					local boneIndex = ragdoll:TranslatePhysBoneToBone( i )
					local position, angle = self:GetBonePosition( boneIndex )

					if ( physicsObject && physicsObject:IsValid() ) then

						physicsObject:SetPos( position )
						physicsObject:SetMass( 65 )
						physicsObject:SetAngles( angle )
						physicsObject:EnableMotion(false)
						physicsObject:Wake()

				end
			end

		end

		local bonemerges = ents.FindByClassAndParent("ent_bonemerged", self)
		if istable(bonemerges) then
			for _, bnmrg in pairs(bonemerges) do
				if IsValid(bnmrg) and !bnmrg:GetNoDraw() then
					local bnmrg_rag = Bonemerge(bnmrg:GetModel(), ragdoll)
					bnmrg_rag:SetMaterial("nextoren/ice_material/icefloor_01_new")
				end
			end
		end

	end

	self:AddToStatistics("l:scp409_death", -100)
	self:LevelBar()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	self:SetupNormal()
	self:SetSpectator()

	return ragdoll
end


function mply:SCP409Infect()
	self.Infected409 = true

	self:Make409Statue()

	timer.Simple(1, function()
		self.Infected409 = nil
	end)
	
end

function mply:Start409Infected()
	if !IsValid(self) and !self:IsPlayer() then return end
	self.Infected409 = true
	print("заразився 409 "..self:Name())
	self:SetBottomMessage("l:scp409_1st_stage")
	timer.Create("MEGAINFECTEDMESSAGE"..self:SteamID(), math.random(30,35), 1, function()
		self:SetBottomMessage("l:scp409_2st_stage")
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 0.5, 0.5 )
		timer.Remove("MEGAINFECTEDMESSAGE"..self:SteamID())
	end)
	timer.Create("INFECTED"..self:SteamID(), math.random(134,146), 1, function()
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 16, 10 )

		net.Start("ForcePlaySound")
		net.WriteString("nextoren/others/freeze_sound.ogg")
		net.Send(self)

		timer.Simple(16, function()
		evacuate(self,"vse",-200,"l:scp409_death")
		self:Make409Statue()

		self.Infected409 = nil
		timer.Remove("INFECTED"..self:SteamID())
		end)
	end)
end

util.AddNetworkString("Shaky_TipSend")

function mply:BrTip(icontype, str1, col1, str2, col2)
  net.Start("Shaky_TipSend", true)
	net.WriteUInt(icontype, 2)
	net.WriteString(str1)
	net.WriteColor(col1)
	net.WriteString(str2)
	net.WriteColor(col2)
  net.Send(self)
end

function mply:StopGestureSlot(slot)
    self:AnimRestartGesture(slot, self:AnimTranslateGestureSlot(slot, self:AnimLookupGestureSlot(slot)))
end

function mply:bSendLua(code)
	net.Start("bettersendlua")
	net.WriteString(code)
	net.Send(self)
end