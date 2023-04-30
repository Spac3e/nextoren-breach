--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/item_deffib_medic.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/medic_kit.png" )

end

SWEP.PrintName		= "Дефибриллятор"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.WorldModel = "models/cultist/items/defib/w_defib.mdl"
SWEP.ViewModel = "models/cultist/items/defib/v_defib.mdl"
SWEP.HoldType		= "slam"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.teams					= {2,3,4,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands				= true

function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )
	self.NextThinkt = CurTime() + 2

end

function SWEP:Think()

	if ( ( self.NextThinkt || 0 ) <= CurTime() ) then

		self:SendWeaponAnim( ACT_VM_IDLE )

	end

end

function SWEP:RevivePlayer( ply, body )

	if !IsValid(ply) or CLIENT then return end

	if body.__Team == TEAM_SCP then return end

	if body.DieWhen + 30 <= CurTime() then self.Owner:RXSENDNotify("Тело пролежало достаточно долго и его нельзя возродить.") return end

	if body.KilledByWeapon and body.LastHit == HITGROUP_HEAD then self.Owner:RXSENDNotify("Данный игрок был убит в голову, ", Color(255,0,0), "возрождение невозможно.") return end

	self.Owner:BrProgressBar("Возраждаем...", 2,"nextoren/gui/icons/medic_kit.png", body, false, nil, nil, function() self.Owner:StopForcedAnimation() end)

	self.Owner:SetForcedAnimation("l4d_defibrillate_incap_standing", 2, function() self.Owner:SetNWEntity("NTF1Entity", self.Owner) end, function()

		self:Remove()

		self.Owner:SetNWEntity("NTF1Entity", NULL)

		if ply:GTeam() != TEAM_SPEC and ply:Health() > 0 then return end

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if CLIENT then return end
		timer.Remove( "PlayerDeathFromBleeding" .. ply:SteamID64() )

		ply:SetupNormal()
		ply:SetModel(body:GetModel())
		ply:SetSkin(body:GetSkin())
		ply:SetGTeam(body.__Team)
		ply:SetRoleName(body.Role)
		ply:SetMaxHealth(body.__Health)
		ply:SetHealth(ply:GetMaxHealth() * .3)
		ply:SetUsingCloth(body.Cloth)
		ply:SetNamesurvivor(body.__Name)
		ply.OldSkin = body.OldSkin
		ply.OldModel = body.OldModel
		ply.OldBodygroups = body.OldBodygroups
		ply:SetWalkSpeed(body.WalkSpeed)
		ply:SetRunSpeed(body.RunSpeed)
		ply:SetupHands()
		ply:SetNWAngle("ViewAngles", ply:GetAngles())
		--ply:StripWeapons()
		--ply:StripAmmo()
		ply:SetMoveType(MOVETYPE_OBSERVER)
		ply:Freeze(true)

		if istable(body.AmmoData) then
			for ammo, amount in pairs(body.AmmoData) do
				ply:SetAmmo(amount, ammo)
			end
		end

		if body.AbilityTable != nil then
			ply:SetNWString("AbilityName", body.AbilityTable[1])
			net.Start("SpecialSCIHUD")
		        net.WriteString(body.AbilityTable[1])
			    net.WriteUInt(body.AbilityTable[2], 9)
			    net.WriteString(body.AbilityTable[3])
			    net.WriteString(body.AbilityTable[4])
			    net.WriteBool(body.AbilityTable[5])
		    net.Send(ply)

		    ply:SetSpecialCD(body.AbilityCD)
		    ply:SetSpecialMax(body.AbilityMax)

		end
		--ply:Give("br_holster")

		PrintTable(body.vtable.Weapons)

		--if body.vtable and body.vtable.Weapons then
			for _, v in pairs(body.vtable.Weapons) do
				ply:Give(v)
			end
		--else
			ply:Give("br_holster")
		--end

		for _, bnmrg in pairs(body:LookupBonemerges()) do
			local bnmrg_ent = Bonemerge(bnmrg:GetModel(), ply)
			bnmrg_ent:SetSubMaterial(0, bnmrg:GetSubMaterial(0))
		end

		for i = 0, 9 do
			ply:SetBodygroup(i, body:GetBodygroup(i))
		end

		ply:SetPos( Vector(body:GetPos().x, body:GetPos().y, GroundPos(body:GetPos()).z) )
		ply:SetAngles( body:GetAngles() )

		ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		ply:SetForcedAnimation( ply:LookupSequence("l4d_Defib_Jolt"), 8, function() ply:GodEnable() ply:ScreenFade(SCREENFADE.IN, color_white, 4, 0) ply:SetNWEntity("NTF1Entity", ply) end, function()

			ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			ply:SetForcedAnimation( ply:LookupSequence("l4d_Defib_Revive"), ply:SequenceDuration(ply:LookupSequence("l4d_Defib_Revive")), nil, function()

				ply:GodDisable()

				ply:ScreenFade(SCREENFADE.IN, color_black, 1, 0.5)

				ply:SetNWAngle("ViewAngles", Angle(0,0,0))

				ply:SetDSP( 1 )
				ply:Freeze( false )
				ply:SetMoveType(MOVETYPE_WALK)
				ply:SetNWEntity("NTF1Entity", NULL)

			end )

		end )

		timer.Simple( .2, function()

			body:Remove()

			if ( ply && ply:IsValid() ) then

				ply:SetNoDraw( false )

			end

		end )

		ply:SetNotSolid( false )

	end, function() self.Owner:SetNWEntity("NTF1Entity", NULL) end)

end

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

	self.NextThinkt = CurTime() + 2

  self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )

	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if ( ent && ent:IsValid() && ent:GetClass() == "prop_ragdoll" && !ent.NOREVIVE ) then

		self:RevivePlayer( ent:GetOwner(), ent )

	end

  --[[timer.Simple( .9, function()

	  self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

  end )]]

end

function SWEP:SecondaryAttack()

  return false

end
