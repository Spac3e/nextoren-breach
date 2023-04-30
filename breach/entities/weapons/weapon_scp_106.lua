--[[
Server Name: Breach 2.6.0 [Alpha]
Server IP:   94.26.255.7:27415
File Path:   gamemodes/breach/entities/weapons/weapon_scp_106.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


SWEP.AbilityIcons = {

	{

		Name = "Ghost mode",
		Description = "None provided",
		Cooldown = 10,
		KEY = _G[ "KEY_R" ],
		Icon = "nextoren/gui/special_abilities/special_invisible.png"

	},
	--[[
	{

		Name = "Dimension Travel",
		Description = "None provided",
		Cooldown = 15,
		KEY = _G[ "KEY_T" ],
		Icon = "nextoren/gui/special_abilities/scp_106_trap.png"

	},]]
	--[[
	{

		Name = "Shadow attack",
		Description = "None provided",
		Cooldown = 5,
		KEY = _G[ "KEY_J" ],
		Icon = "nextoren/gui/special_abilities/scp_106_dimensionteleport.png"

	}]]

}

SWEP.TeleportPosition = Vector(3679.350830, -14774.952148, -3055.968750)

SWEP.PrintName = "SCP-106"
SWEP.HoldType = "scp106"
SWEP.Base = "breach_scp_base"

SWEP.ViewModel = ""
SWEP.WorldModel = "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "GhostMode" )
	self:NetworkVar( "Bool", 1, "InDimension" )

	self:SetGhostMode( false )
	self:SetInDimension( false )

end

if ( SERVER ) then

	util.AddNetworkString( "DimensionSequence" )

	function SWEP:TeleportSequence( victim )

		if ( !( victim && victim:IsValid() ) ) then return end

		victim:SetForcedAnimation( 5324, 1.25, function()

			victim:SetMoveType( MOVETYPE_OBSERVER )
			victim:SetNWEntity( "NTF1Entity", victim )
			victim:SetInDimension( true )

			timer.Simple( .25, function()

				if ( victim && victim:IsValid() && victim:Health() > 0 && victim:GTeam() != TEAM_SPEC ) then

					victim:ScreenFade( SCREENFADE.OUT, color_black, .1, 2.25 )

				end

			end )

		end, function()

			victim:SetMoveType( MOVETYPE_WALK )
			victim:SetNWEntity( "NTF1Entity", NULL )
			victim:SetPos(self.TeleportPosition)

		end )

	end

	function SWEP:OwnerTeleport( b_origin, b_leave )

		net.Start( "ThirdPersonCutscene" )

			net.WriteUInt( !b_origin && 7 || 4.25, 4 )
			net.WriteBool( false )

		net.Send( self.Owner )

		if ( !b_origin ) then

			self.Owner:SetForcedAnimation( "0_106_new_despawn_1", 2, function()

				self.Owner:Freeze( true )
				self.Owner:SetNotSolid( true )

				if ( !self:GetInDimension() ) then

					self.DimensionEnterPosition = self.Owner:GetPos()
					self:SetInDimension( true )
					self.Owner:SetInDimension( true )

				end

				self:DrawTeleportDecal( self.Owner )

				timer.Simple( 1.8, function()

					if ( self && self:IsValid() ) then

						self.Owner:ScreenFade( SCREENFADE.OUT, color_black, .1, 1.1 )

					end

				end )

			end, function()

				if ( !b_leave ) then

					CheckLabirintRandom( self.Owner )

				else

					self.Owner:SetPos( self.DimensionEnterPosition )
					self.DimensionEnterPosition = nil

				end

				self:DrawTeleportDecal( self.Owner )

				self.Owner:SetForcedAnimation( "0_106_new_spawn_1", 4.25, function()

					self:EmitSound( "nextoren/scp/106/decay0.ogg", 75, 100, 1, CHAN_STATIC )
					self.Owner:EmitSound( "nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE )

				end, function()

					if ( b_leave ) then

						self.Owner:SetInDimension( false )
						self.Owner:SetNotSolid( false )
						self:SetInDimension( false )

						for i = 1, 3 do

							self:ForbidAbility( i, false )

						end

					else

						self.Owner:SetNotSolid( true )

					end

					self.Owner:Freeze( false )

				end )

			end )

		else

			self:DrawTeleportDecal( self.Owner )

			self.Owner:ScreenFade( SCREENFADE.OUT, color_black, .1, 1 )

			self.Owner:SetForcedAnimation( "0_106_new_spawn_1", 4.25, function()

				self:SetGhostMode( false )
				self:SetInDimension( true )

				timer.Simple( 7, function()

					if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

						self.Owner:SetRunSpeed( 125 )
						self.Owner:SetWalkSpeed( 125 )

					end

				end )

				sound.Play( "nextoren/scp/106/decay0.ogg", self:GetPos() + vector_up * 24, 80, math.random( 90, 100 ), 1 )

				self.Owner:EmitSound( "nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE )
				self.Owner:SetNoDraw( false )

			end, function()

				self.Owner:Freeze( false )
				self.Owner:SetNotSolid( false )

				self:SetInDimension( false )

				self.Owner.Block_Use = nil

				for i = 1, 3 do

					self:ForbidAbility( i, false )

				end

			end )

		end

	end

	function SWEP:DrawTeleportDecal( origin_ent, offset, with_trap, distant_attack )

		if ( !origin_ent:IsPlayer() ) then return end

		--print( origin_ent:GetShootPos() + offset )

		local trace = {}
		trace.start = origin_ent:GetShootPos() + ( offset || vector_origin )
		trace.endpos = trace.start - ( vector_up * 36200 )
		trace.filter = origin_ent
		trace.mask = MASK_SHOT

		if ( distant_attack ) then

			local decal_origin = trace.start

			local check_trace = {}
			check_trace.start = decal_origin - origin_ent:GetForward() * 64
			check_trace.endpos = check_trace.start + origin_ent:GetForward() * 70
			check_trace.filter = origin_ent
			check_trace.mask = MASK_SHOT

			check_trace = util.TraceLine( check_trace )

			if ( check_trace.HitWorld || ( check_trace.Entity && check_trace.Entity:IsValid() ) && check_trace.Entity:GetClass():find( "door" ) ) then

				timer.Remove( "SCP106_RangeAttack" )

				return
			end

			trace = util.TraceLine( trace )

			local shadoweffect = EffectData()
			shadoweffect:SetOrigin( trace.HitPos + trace.HitNormal )

			local recipients = RecipientFilter()
			recipients:AddAllPlayers()
			util.Effect( "scp106_shadowattack", shadoweffect, true, recipients )

			if ( with_trap ) then

				local ents_withinadecal = ents.FindInSphere( decal_origin, 30 )

				for i = 1, #ents_withinadecal do

					local ent = ents_withinadecal[ i ]

					if ( ent:IsPlayer() && !( ent:GTeam() == TEAM_SPEC || ent:GTeam() == TEAM_SCP ) && !ent.Teleported ) then

						ent.Teleported = true
						self:TeleportSequence( ent )

						util.Decal( "Decal106", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal, ent )

					end

				end

			end

		else

			trace = util.TraceLine( trace )

			util.Decal( "Decal106", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal, origin_ent )

		end

		sound.Play( "nextoren/scp/106/decay" .. math.random( 1, 3 ) .. ".ogg", trace.HitPos + vector_up * 18, 75, math.random( 90, 100 ), 1 )

	end

	function SWEP:Think()

		if ( self:GetGhostMode() && !self.Owner:GetNoDraw() ) then

			self.Owner:SetNoDraw( true )

		end

	end

else -- ( CLIENT )

	function SWEP:CalcViewModelView()

		if ( !self:GetInDimension() ) then return end

		local dynamic_light = DynamicLight( self:EntIndex() )

		if ( dynamic_light ) then

			dynamic_light.Pos = self:GetPos() + self:GetUp() * 64
			dynamic_light.r = 140
			dynamic_light.g = 0
			dynamic_light.b = 0
			dynamic_light.Brightness = 4
			dynamic_light.Size = 280
			dynamic_light.Decay = 2500
			dynamic_light.DieTime = CurTime() + .1

		end

	end

	function SWEP:DrawWorldModel()

		if ( !self:GetInDimension() ) then return end

		local dynamic_light = DynamicLight( self:EntIndex() )

		if ( dynamic_light ) then

			dynamic_light.Pos = self:GetPos() + self:GetUp() * 64
			dynamic_light.r = 140
			dynamic_light.g = 0
			dynamic_light.b = 0
			dynamic_light.Brightness = 4
			dynamic_light.Size = 280
			dynamic_light.Decay = 2500
			dynamic_light.DieTime = CurTime() + .1

		end

	end

	function SWEP:Think()

		if ( self:GetGhostMode() && !self.Tip_Received ) then

			self.Tip_Received = true
			BREACH.Player:ChatPrint( true, true, "Активирован режим \"Призрака\"." )
			BREACH.Player:ChatPrint( true, true, "Ваша скорость передвижения увеличена в два раза." )
			BREACH.Player:ChatPrint( true, true, "В этом режиме Вы не можете никого атаковать. Люди, в свою очередь, никаким образом не смогут Вас увидеть." )
			BREACH.Player:ChatPrint( true, true, "Вы можете покинуть этот режим, нажав кнопку \"R\". Ваш персонаж появится на текущей позиции." )

		end

		if ( self.Owner:GetInDimension() && !self.Tip_Received_2 ) then

			self.Tip_Received_2 = true

			BREACH.Player:ChatPrint( true, true, "Теперь Вы находитесь в своём измерении." )
			BREACH.Player:ChatPrint( true, true, "С помощью клавиши \"H\" Вы можете вернуться на свою старую позицию, откуда был произведён вход в собственное измерение." )
			BREACH.Player:ChatPrint( true, true, "Вы можете продолжать телепортироваться по случайным точкам измерения с помощью способности на клавишу \"T\"." )

		end

	end

	local exit_icon = Material( "nextoren/gui/special_abilities/scp_106_trap.png" )
	local clrgray = Color( 198, 198, 198 )
	local darkgray = Color( 105, 105, 105 )

end

local prim_maxs =  Vector( 12, 4, 32 )

function SWEP:PrimaryAttack()

	if ( self:GetGhostMode() ) then return end

	self:SetNextPrimaryFire( CurTime() + 1 )

	if ( CLIENT ) then return end

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 90
	trace.filter = self.Owner
	trace.mins = -prim_maxs
	trace.maxs = prim_maxs

	trace = util.TraceHull( trace )

	local hit_ent = trace.Entity

	if ( hit_ent:IsPlayer() && hit_ent:GTeam() != TEAM_SCP && hit_ent:GetMoveType() != MOVETYPE_OBSERVER ) then

		hit_ent.BodyOrigin = hit_ent:GetPos()
		hit_ent:SetInDimension( true )

		self:DrawTeleportDecal( hit_ent )
		self:TeleportSequence( hit_ent )

	end

end

function SWEP:CanSecondaryAttack() return false end

function SWEP:Deploy()

	self.Owner.ignorecollide106 = true

	hook.Add( "PlayerButtonDown", "SCP106_DimensionTeleport", function( caller, button )

		if ( caller:GetNClass() != "SCP106" ) then return end

		local wep = caller:GetActiveWeapon()

		if ( wep == NULL || !wep.AbilityIcons ) then return end
		--[[
		if ( button == KEY_T && !( ( wep.AbilityIcons[ 2 ].CooldownTime || 0 ) > CurTime() || self.AbilityIcons[ 2 ].Forbidden ) ) then

			wep.AbilityIcons[ 2 ].CooldownTime = CurTime() + wep.AbilityIcons[ 2 ].Cooldown

			if ( SERVER ) then

				for i = 1, 3, 2 do

					self:ForbidAbility( i, true )

				end

				wep:OwnerTeleport()
				caller:SetInDimension( true )

			else

				timer.Simple( .25, function()

					hook.Add( "PreDrawOutlines", "SCP106_DimensionVision", function()

						local client = LocalPlayer()

						if ( client:Health() <= 0 || client:GetNClass() != "SCP106" || !client:GetInDimension() ) then

							hook.Remove( "PreDrawOutlines", "SCP106_DimensionVision" )

							return
						end

						local to_draw = {}

						local players = player.GetAll()

						for i = 1, #players do

							local player = players[ i ]

							if ( player && player:IsValid() && player != client && player:Health() > 0 && player:GTeam() != TEAM_SPEC && player:GetInDimension() ) then

								to_draw[ #to_draw + 1 ] = player

							end

						end

						if ( #to_draw > 0 ) then

							outline.Add( to_draw, color_white, OUTLINE_MODE_BOTH )

						end

					end )

				end )

			end

		elseif ( button == KEY_J && !( ( wep.AbilityIcons[ 3 ].CooldownTime || 0 ) > CurTime() || self.AbilityIcons[ 3 ].Forbidden ) ) then

			wep.AbilityIcons[ 3 ].CooldownTime = CurTime() + wep.AbilityIcons[ 3 ].Cooldown

			if ( CLIENT ) then return end

			for i = 1, 2 do

				self:ForbidAbility( i, true )

			end

			wep:DistantAttack()

		elseif ( button == KEY_H && caller:GetInDimension() && !( ( wep.AbilityIcons[ 2 ].CooldownTime || 0 ) > CurTime() ) ) then

			wep.AbilityIcons[ 3 ].CooldownTime = CurTime() + wep.AbilityIcons[ 3 ].Cooldown

			if ( CLIENT ) then return end

			for i = 1, 3 do

				self:ForbidAbility( i, true )

			end

			wep:OwnerTeleport( false, true )

		end]]

	end )

	if ( self.AbilityIcons ) then

		for i = 1, #self.AbilityIcons do

			self.AbilityIcons[ i ].CooldownTime = CurTime() + 10

		end

	end

	if ( SERVER ) then

		self:DrawTeleportDecal( self.Owner )

		self.Owner:Freeze( true )
		self.Owner:EmitSound( "nextoren/scp/106/decay0.ogg", 75, 100, 1, CHAN_STATIC )
		self.Owner:ScreenFade( SCREENFADE.OUT, color_black, .1, 2.5 )

		timer.Simple( 1.25, function()

			if ( !( self && self:IsValid() ) ) then return end

			self.Owner:SetForcedAnimation( "0_106_new_spawn_1", 4.25, function()

				net.Start( "ThirdPersonCutscene" )

					net.WriteUInt( 4, 4 )
					net.WriteBool( false )

				net.Send( self.Owner )

				self:SetInDimension( true )

			end, function()

				self:SetInDimension( false )

				self.Owner:SetMoveType( MOVETYPE_WALK )
				self.Owner:SetCustomCollisionCheck( true )
				self.Owner:Freeze( false )

			end )

		end )

	else

		local material_clr = Material( "pp/colour" )

		hook.Add( "RenderScreenspaceEffects", "SCP106_GhostModeProccessing", function()

			local client = LocalPlayer()

			if ( client:Health() <= 0 || client:GTeam() != TEAM_SCP || client:GetNClass() != "SCP106" ) then

				if ( client.CustomRenderHook ) then

					client.CustomRenderHook = nil

				end

				hook.Remove( "RenderScreenspaceEffects", "SCP106_GhostModeProccessing" )

				return
			end

			local wep = client:GetActiveWeapon()

			if ( wep == NULL ) then return end

			if ( !wep:GetGhostMode() ) then

				if ( client.CustomRenderHook ) then

					client.CustomRenderHook = nil

				end

				return
			end

			if ( !client.CustomRenderHook ) then

				client.CustomRenderHook = true

			end

			render.UpdateScreenEffectTexture()

			material_clr:SetFloat( "$pp_colour_brightness", .1 )
			material_clr:SetFloat( "$pp_colour_contrast", 1 )
			material_clr:SetFloat( "$pp_colour_colour", .1 )
			material_clr:SetFloat( "$pp_colour_addr", .1 )

			render.SetMaterial( material_clr )
			render.DrawScreenQuad()

		end )

	end

end

function SWEP:Reload()

	if ( self.AbilityIcons && ( ( self.AbilityIcons[ 1 ].CooldownTime || 0 ) > CurTime() || self.AbilityIcons[ 1 ].Forbidden ) ) then return end

	self.AbilityIcons[ 1 ].CooldownTime = CurTime() + self.AbilityIcons[ 1 ].Cooldown

	local is_ghostmode = self:GetGhostMode()

	if ( is_ghostmode ) then

		local check_trace = {}
		check_trace.start = self.Owner:GetShootPos()
		check_trace.endpos = check_trace.start + self.Owner:GetAimVector() * 16
		check_trace.mask = MASK_SHOT
		check_trace.filter = self.Owner

		check_trace = util.TraceLine( check_trace )

		if ( check_trace.Entity && check_trace.Entity:IsValid() ) then

			if !check_trace.Entity:IsPlayer() then

				if ( CLIENT ) then

					BREACH.Player:ChatPrint( true, true, "Вы не можете выйти из режима \"Призрака\" в этом месте." )

				end

				self.AbilityIcons[ 1 ].CooldownTime = CurTime() + 3

				return
			end--[[
			else
				if SERVER then
					check_trace.Entity.BodyOrigin = check_trace.Entity:GetPos()
					check_trace.Entity:SetInDimension( true )

					self:DrawTeleportDecal( check_trace.Entity )
					self:TeleportSequence( check_trace.Entity )
				end

				self.AbilityIcons[ 1 ].CooldownTime = CurTime() + 45

				--return
			end]]
		end

	end



	local userstotake = ents.FindInSphere(self.Owner:GetPos(), 55)

	local performcd = false

	for _, ply in pairs(userstotake) do
		if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC then
			performcd = true
			ply.BodyOrigin = ply:GetPos()
			ply:SetInDimension( true )
			self:DrawTeleportDecal( ply )
			self:TeleportSequence( ply )
		end
	end

	if performcd and SERVER then
		self.AbilityIcons[1].CooldownTime = CurTime() + 130
		self.Owner:SendLua("LocalPlayer():GetActiveWeapon().CooldownTime = CurTime() + 130")
	end


	if ( CLIENT ) then return end

	self:DrawTeleportDecal( self.Owner )
	self.Owner:EmitSound( "nextoren/scp/106/laugh.ogg", 75, 100, 1, CHAN_VOICE )

	if ( !is_ghostmode ) then

		for i = 2, 3 do

			self:ForbidAbility( i, true )

		end

		local unique_id = "DecalDraw" .. self.Owner:SteamID()
		local i = 1

		timer.Create( unique_id, .75, 2, function()

			if ( !( self && self:IsValid() ) ) then

				timer.Remove( unique_id )

				return
			end

			self:DrawTeleportDecal( self.Owner, self.Owner:GetAimVector() * ( 24 * i ) )

			i = i + 1

		end  )

		self.Owner:SetForcedAnimation( "0_106_new_despawn_2", 3, function()

			self.Owner:Freeze( true )

			net.Start( "ThirdPersonCutscene" )

				net.WriteUInt( 3, 4 )
				net.WriteBool( false )

			net.Send( self.Owner )

			self.Owner:ScreenFade( SCREENFADE.OUT, color_black, 2.25, 1.25 )

		end, function()

			self.Owner:SetNoDraw( true )
			self.Owner:SetNotSolid( true )
			self.Owner:Freeze( false )
			self.Owner.Block_Use = true -- Prevent Player_Use hook from call
			self.Owner:SetRunSpeed( 220 )
			self.Owner:SetWalkSpeed( 220 )

			self:SetGhostMode( true )

		end )

	else

		self.Owner:Freeze( true )

		self.Owner:SetRunSpeed( 165 )
		self.Owner:SetWalkSpeed( 165 )

		self:OwnerTeleport( true )

	end

end

function SWEP:OnRemove()

	local players = player.GetAll()

	local scp106_exists

	for i = 1, #players do

		local player = players[ i ]

		if ( player:GetNClass() == "SCP106" ) then

			scp106_exists = true

			break
		end

	end

	if ( !scp106_exists ) then

		hook.Remove( "PlayerButtonDown", "SCP106_DimensionTeleport" )

	end

end

if SERVER then
	hook.Add("PlayerUse", "SCP_106_Prevent_Use", function(activator)
		if activator.Block_Use then return false end
	end)
end