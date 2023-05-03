--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_scp_062.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

SWEP.AbilityIcons = {

	{

		["Name"] = "Consume",
		["Description"] = "Evolute by consuming the body's blood.",
		["Cooldown"] = 15,
		["CooldownTime"] = 0,
		["bodies"] = 0,
		["KEY"] = _G["KEY_R"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_cannibal.png"

	},

	{

		["Name"] = "Rage",
		["Description"] = "Evolute by consuming the body's blood.",
		["Cooldown"] = 65,
		["CooldownTime"] = 0,
		["bodies"] = 5,
		["KEY"] = _G["KEY_G"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_682_speedup.png"

	},

	{

		["Name"] = "Special #2",
		["Description"] = "Make a loud scream that will affect people nearby.",
		["Cooldown"] = 55,
		["CooldownTime"] = 0,
		["bodies"] = 10,
		["KEY"] = _G["KEY_2"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_level2.png"

	},

	{

		["Name"] = "Special #3",
		["Description"] = "Use a special view to see the people you damaged before.",
		["Cooldown"] = 75,
		["CooldownTime"] = 0,
		["bodies"] = 15,
		["KEY"] = _G["KEY_3"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_level3.png"

	},

	{

		["Name"] = "Special #4",
		["Description"] = "Make a high jump to get closer to the enemy",
		["Cooldown"] = 35,
		["CooldownTime"] = 0,
		["bodies"] = 20,
		["KEY"] = _G["KEY_4"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_level4.png"

	},

	{

		["Name"] = "Special #4",
		["Description"] = "Become invisible for a short time using special technique",
		["Cooldown"] = 80,
		["CooldownTime"] = 0,
		["bodies"] = 25,
		["KEY"] = _G["KEY_5"],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_062_fr_level5.png"

	},

}

SWEP.ViewModelFOV	= 120
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cultist/scp/c_arms_062fr.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-062-FR"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "scp062fr"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.Base = "breach_scp_base"

SWEP.DamagedPlayers = {}

SWEP.droppable				= false

SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false

local prim_maxs = Vector( 12, 2, 32 )

function SWEP:DrawWorldModel()

	return false

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "Bodies" )

end

function SWEP:OnRemove()

	hook.Remove( "PlayerButtonDown", "SCP_062_ABILITY" )

end

function SWEP:Initialize()

	hook.Add( "PlayerButtonDown", "SCP_062_ABILITY", function( activator, butt )

		if activator:GetNClass() != "SCP062FR" then return end

		local self = activator

		if self:GetMoveType() == MOVETYPE_OBSERVER then return end

		if self:GetNoDraw() then return end

		local wep = activator:GetActiveWeapon()

		if wep.Charging then return end

		if butt == KEY_R and !wep:IsCooldown(1) then

			if SERVER then

				local trace = {}
				trace.start = self:GetShootPos()
				trace.endpos = trace.start + self:GetAimVector() * 135
				trace.filter = self
				trace.mins = -prim_maxs
				trace.maxs = prim_maxs

				trace = util.TraceHull( trace )

				local tar = trace.Entity

				if IsValid(tar) and tar:GetClass() == "prop_ragdoll" and tar.BloodConsumed == nil then

					self:SetMoveType(MOVETYPE_OBSERVER)
					self:SetNWAngle( "ViewAngles", self:GetAngles() )
					self:EmitSound( "nextoren/scp/scp_hunter/eating.mp3" , 89, 100, 1, CHAN_VOICE, 0, 0 )
					net.Start("ThirdPersonCutscene")
			        net.WriteUInt(self:SequenceDuration(13), 4)
			        net.WriteBool(false)
			        net.Send(self)

			        wep:Cooldown(1, self:SequenceDuration(13))

					activator:SetForcedAnimation(13, activator:SequenceDuration(13), nil, function()
						self:SetHealth(math.Approach(self:Health(), self:GetMaxHealth(), 235))
						--wep:Cooldown(1, 15)
						wep:SetBodies(wep:GetBodies() + 1)
						tar.BloodConsumed = true
						self:SetNWEntity("NTF1Entity", self)

						local wep_bodies = wep:GetBodies()

						if wep_bodies == 5 or wep_bodies == 10 or wep_bodies == 15 or wep_bodies == 20 or wep_bodies == 25 then

							self:RXSENDNotify(Color(0,255,0,200), "Поздравляю!", color_white, " Вы открыли новую стадию, теперь у вас доступна новая способность.")
							self:EmitSound( "nextoren/scp/scp_hunter/evolve.mp3" , 89, 200, 1.2, CHAN_VOICE, 0, 0 )

							self:SetMaxHealth(activator:GetMaxHealth() + 1000)
							self:SetHealth(activator:Health() + 1000)

							self:SetWalkSpeed(math.Approach(activator:GetWalkSpeed(), 350, 65))
							self:SetRunSpeed(activator:GetWalkSpeed())

							self:SetForcedAnimation(7, self:SequenceDuration(7), nil, function()
								self:SetMoveType(MOVETYPE_WALK)
								self:SetNWAngle( "ViewAngles", Angle(0,0,0) )
								self:SetNWEntity("NTF1Entity", NULL)
							end, function()
								self:SetMoveType(MOVETYPE_WALK)
								self:SetNWAngle( "ViewAngles", Angle(0,0,0) )
								self:SetNWEntity("NTF1Entity", NULL)
							end)

						else

							self:SetMoveType(MOVETYPE_WALK)
							self:SetNWAngle( "ViewAngles", Angle(0,0,0) )
							self:SetNWEntity("NTF1Entity", NULL)

						end
					end, function()
						self:SetMoveType(MOVETYPE_WALK)
						self:SetNWAngle( "ViewAngles", Angle(0,0,0) )
						self:SetNWEntity("NTF1Entity", NULL)
					end)

				end

			end

		elseif butt == KEY_G and !wep:IsCooldown(2) then

			if SERVER then

				wep:Cooldown(2, wep.AbilityIcons[2].Cooldown)

				wep.savespeed = self:GetRunSpeed()

				self:SetRunSpeed( 400 )
				self:SetWalkSpeed( 400 )

				wep.Charging = true

				self:ConCommand( "+forward" )

				timer.Simple(5, function()
					if wep.Charging then
						self:SetRunSpeed( wep.savespeed )
						self:SetWalkSpeed( wep.savespeed )
						self:ConCommand( "-forward" )
						wep.Charging = nil
					end
				end)

			end

		elseif butt == KEY_3 and !wep:IsCooldown(4) then

			if SERVER then
				wep:Cooldown(4, wep.AbilityIcons[4].Cooldown)
				self:EmitSound( "nextoren/scp/scp_hunter/vision.mp3", 89, 100, 1, CHAN_VOICE, 0, 0 )
			end

			if CLIENT then

				hook.Add("HUDPaint", "SCP_062_VISION", function()

					local client = LocalPlayer()

					if client:GetNClass() != "SCP062FR" then
						hook.Remove("HUDPaint", "SCP_062_VISION")
						return
					end

					local plys = player.GetAll()

					local todraw = {}

					for i = 1, #plys do
						local ply = plys[i]
						if ply:GTeam() == TEAM_SPEC then continue end
						if ply:GTeam() == TEAM_SCP then continue end
						if ply:Health() <= 0 then continue end
						if ply:GetPos():DistToSqr(client:GetPos()) > 700000 then continue end
						todraw[#todraw + 1] = ply
					end

					outline.Add(todraw, Color(255,255,0), OUTLINE_MODE_BOTH )

				end)

				timer.Simple(6, function()
					hook.Remove("HUDPaint", "SCP_062_VISION")
				end)

			end

		elseif butt == KEY_4 and !wep:IsCooldown(5) then

			if SERVER then

				wep:Cooldown(5, wep.AbilityIcons[5].Cooldown)

				self:SetVelocity(Vector(0,0,360))
				timer.Simple(0.6, function()

					if !IsValid(self) then return end

					self:SetVelocity(self:GetAimVector() * 1000)
					self:PlayGestureSequence(self:LookupSequence("jump_melee2"), GESTURE_SLOT_ATTACK_AND_RELOAD)

					self.FallDamageImmunity = true

					self:GodEnable()

				end)

			end

		elseif butt == KEY_5 and !wep:IsCooldown(6) then

			if SERVER then

				wep:Cooldown(6, wep.AbilityIcons[6].Cooldown)

				self:SetNoDraw(true)

				timer.Simple(20, function()
					if IsValid(self) and self:GTeam() == TEAM_SPEC then
						self:SetNoDraw(false)
					end
				end)

			end

		elseif butt == KEY_2 and !wep:IsCooldown(3) then

			if SERVER then
				wep:Cooldown(3, wep.AbilityIcons[3].Cooldown)

				self:EmitSound( "nextoren/scp/scp_hunter/evolve.mp3" , 89, 150, 1, CHAN_VOICE, 0, 0 )

				local Ents = ents.FindInSphere(self:GetPos(), 520)

				for _, ply in ipairs(Ents) do

					if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and ply:Health() > 0 then

						ply:Freeze(true)
						ply:ScreenFade(SCREENFADE.IN, color_white, 7, 0)

						timer.Simple(7, function()
							ply:Freeze(false)
						end)

					end

				end

			end

		end

	end )

end

function SWEP:Deploy()

	self:SetHoldType( self.HoldType )

end

if ( SERVER ) then

	function SWEP:Holster()

		hook.Remove( "PlayerButtonDown", "SCP_062_ABILITY" )

	end

end

function SWEP:Think()

	local bodies = self:GetBodies()

	if SERVER then

		if self.Owner.FallDamageImmunity then
			if self.Owner:OnGround() then
				timer.Simple(0.1, function()
					self.Owner:GodDisable()
				end)
				self.Owner.FallDamageImmunity = nil
			end
		end

		if self.Charging then
			local trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + self.Owner:GetAimVector() * 80
			trace.filter = self.Owner
			trace.mins = -prim_maxs
			trace.maxs = prim_maxs

			trace = util.TraceHull( trace )

			local tar = trace.Entity

			if IsValid(tar) and tar:IsPlayer() and tar:GTeam() != TEAM_SCP then

				self:Cooldown(2, 125)

				self.Owner:PlayGestureSequence(self.Owner:LookupSequence("attack_2"), GESTURE_SLOT_ATTACK_AND_RELOAD)

				self.Charging = nil
				self.Owner:ConCommand("-forward")
				self.Owner:SetRunSpeed(self.savespeed)
				self.Owner:SetWalkSpeed(self.savespeed)

				self.dmginfo = DamageInfo()
			    self.dmginfo:SetDamageType( DMG_SLASH )
			    self.dmginfo:SetDamage( tar:Health() * 1.15 )
			    self.dmginfo:SetDamageForce( tar:GetAimVector() * 25 )
			    self.dmginfo:SetInflictor( self )
			    self.dmginfo:SetAttacker( self.Owner )

			    self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
			    self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() )

			    tar:MeleeViewPunch( self.dmginfo:GetDamage() )
			    tar:TakeDamageInfo( self.dmginfo )

			end
		end
	end

	for i = 1, #self.AbilityIcons do
		local tab = self.AbilityIcons[i]
		if bodies < tab.bodies then
			tab.CooldownTime = CurTime() + (tab.bodies - bodies)
		end
	end

end

function SWEP:Reload()

end

function SWEP:PrimaryAttack()

	if self:GetMoveType() == MOVETYPE_OBSERVER then return end

	if self.Charging then return end

	self:SetNextPrimaryFire( CurTime() + .7 )

	if self.Owner:GetNoDraw() then
		self.Owner:SetNoDraw(false)
	end

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80
	trace.filter = self.Owner
	trace.mins = -prim_maxs
	trace.maxs = prim_maxs

	trace = util.TraceHull( trace )

	local tar = trace.Entity

	if ( CLIENT ) then
		if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then
			local effectData = EffectData()
			effectData:SetOrigin( trace.HitPos )
			effectData:SetEntity( target )
			util.Effect( "BloodImpact", effectData )
		end
		return
	end

	if SERVER then

	    self.Owner:PlayGestureSequence(self.Owner:LookupSequence("attack_"..math.random(0,2)), GESTURE_SLOT_ATTACK_AND_RELOAD)

	    self.Owner:EmitSound( "nextoren/scp/scp_hunter/attack_"..math.random(1,6)..".mp3" , 89, 100, 1, CHAN_VOICE, 0, 0 )

	end

	if ( IsValid(tar) && tar:IsPlayer() && tar:Health() > 0 && tar:GTeam() != TEAM_SCP ) then

	    self.dmginfo = DamageInfo()
	    self.dmginfo:SetDamageType( DMG_SLASH )
	    self.dmginfo:SetDamage( math.random(70,80) )
	    self.dmginfo:SetDamageForce( tar:GetAimVector() * 25 )
	    self.dmginfo:SetInflictor( self )
	    self.dmginfo:SetAttacker( self.Owner )

	    self.DamagedPlayers[#self.DamagedPlayers + 1] = {tar:GetName(), tar}

	    self.Owner:EmitSound( "npc/antlion/shell_impact4.wav" )
	    self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() )

	    tar:MeleeViewPunch( self.dmginfo:GetDamage() )
	    tar:TakeDamageInfo( self.dmginfo )

	else

		self.Owner:MeleeViewPunch( 40 )

	end

end

function SWEP:SecondaryAttack()
	--self:PrimaryAttack()
end