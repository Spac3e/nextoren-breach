local RunConsoleCommand = RunConsoleCommand;
local FindMetaTable = FindMetaTable;
local CurTime = CurTime;
local pairs = pairs;
local string = string;
local table = table;
local timer = timer;
local hook = hook;
local math = math;
local pcall = pcall;
local unpack = unpack;
local tonumber = tonumber;
local tostring = tostring;
local ents = ents;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local util = util
local net = net
local player = player
local mply = FindMetaTable( "Player" )
local ment = FindMetaTable( "Entity" )

function mply:IsPremium()
	if self:IsSuperAdmin() then return true end
	if self:GetUserGroup() == "premium" then return true end
	if self:GetNWBool("Shaky_IsPremium") then return true end

	return false
end

function mply:GetEDP()
	if !self.GetNEscapes then
		return "N/A"
	end
	if !self.GetNDeaths then
		return "N/A"
	end

	local escapes = self:GetNEscapes()
	local deaths = self:GetNDeaths()
	local total = escapes + deaths
	
	if deaths == 0 then --на нолик делить нельзя
		deaths = 1
	end
	
	return (escapes / deaths) * total
end

function mply:GetAverageElo()
	local average = 0
	local count = 0

	for k, v in ipairs(player.GetAll()) do
		if !v.GetElo then
			continue
		end
		
		if v:GTeam() == TEAM_SPEC then
			continue
		end

		if v == self then
			continue
		end

		average = average + v:GetElo()
		count = count + 1
	
	end
	
	if count == 0 then
		count = 1
	end
	
	return average / count
end
function GM:OnEntityCreated( ent )



	ent:SetShouldPlayPickupSound( false )



	if ( ent:GetClass() == "prop_ragdoll" ) then



		ent:InstallDataTable()

		ent:NetworkVar( "String", 0, "DeathName" )

		ent:NetworkVar( "String", 1, "DeathReason" )

		ent:NetworkVar( "Int", 0, "VictimHealth" )

		ent:NetworkVar( "Bool", 0, "IsVictimAlive" )



	elseif ( ent:GetClass() == "prop_physics" ) then



		ent.RenderGroup = RENDERGROUP_OPAQUE



	end



end

function mply:CalculateElo(k_factor, escape)
	if !self.GetElo then
		return 0
	end
	
	if BREACH.DisableElo then
		return 0
	end

	local score = 0 --0 = if died, 1 = if escaped
	local expected_score = 0
	local current_rating = self:GetElo() or 0
	local average_rating = self:GetAverageElo() or 0
	
	if escape then
		score = 1
	end
	
	if score == 0 then
		k_factor = k_factor / 4 --divide by 4 if death
	end
	
	local expected_score = 1 / (1 + 10^((average_rating - current_rating) / 400))
	
	return math.Round(k_factor * (score - expected_score), 1)
end


function mply:CanEscapeHand()
	return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_GUARD or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL 
end

function mply:CanEscapeChaosRadio()
	return self:GTeam() == TEAM_CLASSD
end

function mply:CanEscapeCar()
	return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL
end

function mply:CanEscapeFBI()
	return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_GUARD or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL
end

function mply:CanEscapeO5()
	return self:GTeam() == TEAM_SECURITY or self:GTeam() == TEAM_CLASSD or self:GTeam() == TEAM_SCI or self:GTeam() == TEAM_SPECIAL
end

function mply:SetEscapeEXP(name, n)
	self:AddToStatistics(name, n * tonumber("1."..tostring(self:GetNLevel() * 2)) )
end

function mply:RequiredEXP()
	return 680 * math.max(1, self:GetNLevel())
end


local util_TraceLine = util.TraceLine
local util_TraceHull = util.TraceHull

local temp_attacker = NULL
local temp_attacker_team = -1
local temp_pen_ents = {}
local temp_override_team

local function MeleeTraceFilter( ent )

	if ( ent == temp_attacker || ent:Team() == temp_attacker:Team() ) then

		return false

	end

	return true

end

local function CheckFHB( tr )

	if ( tr.Entity.FHB && tr.Entity:IsValid() ) then

		tr.Entity = tr.Entity:GetParent()

	end

end

local function InvalidateCompensatedTrace( tr, start, distance )

	if ( tr.Entity:IsValid() && tr.Entity:IsPlayer() && tr.HitPos:DistToSqr( start ) > distance * distance + 144 ) then

		tr.Hit = false
		tr.HitNonWorld = false
		tr.Entity = NULL

	end

end

local melee_trace = { filter = MeleeTraceFilter, mask = MASK_SOLID, mins = Vector(), maxs = Vector() }

function mply:MeleeTrace( distance, size, start, dir, hit_team_members, override_team, override_mask )

	start = start || self:GetShootPos()
	dir = dir || self:GetAimVector()
	hit_team_members = hit_team_members || "None"

	local tr

	temp_attacker = self
	temp_attacker_team = self:Team()
	temp_override_team = override_team
	melee_trace.start = start
	melee_trace.endpos = start + dir * distance
	melee_trace.mask = override_mask || MASK_SOLID
	melee_trace.mins.x = -size
	melee_trace.mins.y = -size
	melee_trace.mins.z = -size
	melee_trace.maxs.x = size
	melee_trace.maxs.y = size
	melee_trace.maxs.z = size
	melee_trace.filter = self

	tr = util_TraceLine( melee_trace )
	CheckFHB( tr )

	if ( tr.Hit ) then

		return tr

	end

	return util_TraceHull( melee_trace )

end

function mply:CompensatedMeleeTrace( distance, size, start, dir, hit_team_members, override_team )

	start = start || self:GetShootPos()
	dir = dir || self:GetAimVector()

	self:LagCompensation( true )

	local tr = self:MeleeTrace( distance, size, start, dir, hit_team_members, override_team )
	CheckFHB( tr )
	self:LagCompensation( false )

	InvalidateCompensatedTrace( tr, start, distance )

	return tr

end

function mply:PenetratingMeleeTrace( distance, size, start, dir, hit_team_members )

	start = start || self:GetShootPos()
	dir = dir || self:GetAimVector()
	hit_team_members = hit_team_members || "None"

	local tr, ent

	team_attacker = self
	team_pen_ents = {}
	melee_trace.start = start
	melee_trace.endpos = start + dir * distance
	melee_trace.mask = MASK_SOLID
	melee_trace.mins.x = -size
	melee_trace.mins.y = -size
	melee_trace.mins.z = -size
	melee_trace.maxs.x = size
	melee_trace.maxs.y = size
	melee_trace.maxs.z = size
	melee_trace.filter = self

	local t = {}
	local onlyhitworld;

	for i = 1, 50 do

		tr = util_TraceLine( melee_trace )

		if ( !tr.Hit ) then

			tr = util_TraceHull( melee_trace )

		end

		if ( !tr.Hit ) then break end

		if ( tr.HitWorld ) then

			table.insert( t, tr )
			break

		end

		if ( onlyhitworld ) then return end

		CheckFHB( tr )
		ent = tr.Entity

		if ( ent:IsValid() ) then

			if ( !ent:IsPlayer() ) then

				melee_trace.mask = MASK_SOLID_BRUSHONLY
				onlyhitworld = true

			end

			table.insert( t, tr )
			temp_pen_ents[ent] = true

		end

	end

	temp_pen_ents = {}

	return t, onlyhitworld

end

local function InvalidateCompensatedTrace( tr, start, distance )

	if ( tr.Entity:IsValid() && tr.Entity:IsPlayer() && tr.HitPos:DistToSqr( start ) > distance * distance + 144 ) then

		tr.Hit = false
		tr.HitNonWorld = false
		tr.Entity = NULL

	end

end

function mply:CompensatedZombieMeleeTrace( distance, size, start, dir, hit_team_members )

	start = start || self:GetShootPos()
	dir = dir || self:GetAimVector()

	self:LagCompensation( true )

	local hit_entities = {}

	local t, hitprop = self:PenetratingMeleeTrace( distance, size, start, dir, hit_team_members )
	local t_legs = self:PenetratingMeleeTrace( distance, size, self:WorldSpaceCenter(), dir, hit_team_members )

	if ( !t ) then return end

	for _, tr in pairs( t ) do

		hit_entities[ tr.Entity ] = true

	end

	if ( !hitprop ) then

		for _, tr in pairs( t_legs ) do

			if ( !hit_entities[ tr.Entity ] ) then

				t[ #t + 1 ] = tr

			end

		end

	end

	for _, tr in pairs( t ) do

		InvalidateCompensatedTrace( tr, tr.StartPos, distance )

	end

	self:LagCompensation( false )

	return t

end

function ment:LookupBonemerges()

	local entstab = ents.FindByClassAndParent("ent_bonemerged", self)
	local newtab = {}

	if istable(entstab) then
		for _, v in ipairs(entstab) do
			if IsValid(v) then newtab[#newtab + 1] = v end
		end
	end
	
	return newtab

end

function mply:GetPrimaryWeaponAmount()
	local count = 0
	for _, v in ipairs( self:GetWeapons() ) do
		if ( !( v.UnDroppable || v.Equipableitem ) ) then
			count = count + 1
		end
	end
	return count
end

hook.Add( "StartCommand", "LockMovement", function( ply, cmd )

	if ( cmd:KeyDown( IN_ALT1 ) ) then

		cmd:ClearButtons()

	end

	if ( cmd:KeyDown( IN_ALT2 ) ) then

		cmd:ClearButtons()

	end

end )

function mply:IsFemale()

	if ( string.find( string.lower( self:GetModel() ), "female" ) || self:GetFemale() ) then
  
	  return true;
  
	end
	
	if self:GetNClass() == ROLES.ROLE_DISPATCHER then
		return true
	end

	if self:GetNClass() == ROLES.ROLE_SPECIALRES then
		return true
	end
  
	return false;
  
end

function mply:CanSee( ent )

	local trace = {}
	trace.start = self:GetEyeTrace().StartPos
	trace.endpos = ent:EyePos()
	trace.filter = { self, ent }
	trace.mask = MASK_BULLET
	local tr = util.TraceLine( trace )
  
	if ( tr.Fraction == 1.0 ) then
  
	  return true;
  
	end
  
	return false;
  
end

local vec_up = Vector( 0, 0, 32768 )

function GroundPos( pos )
	local trace = { }
	trace.start = pos;
	trace.endpos = trace.start - vec_up
	trace.mask = MASK_BLOCKLOS

	local tr = util.TraceLine( trace )

	if ( tr.Hit ) then
		return tr.HitPos
	end

	return pos

end
---- Инвентарь

net.Receive( "hideinventory", function()

	HideEQ( net.ReadBool() )

end )

BREACH = BREACH || {}

EQHUD = {}

function BetterScreenScale()

	return math.max( math.min( ScrH(), 1080 ) / 1080, .851 )
  
end

if ( IsValid( BREACH.Inventory ) ) then

	BREACH.Inventory:Remove()

	local client = LocalPlayer()

	if ( client.MovementLocked ) then

		client.MovementLocked = nil

	end

	gui.EnableScreenClicker( false )

end

local clrgreyinspect2 = Color( 198, 198, 198 )
local clrgreyinspect = ColorAlpha( clrgreyinspect2, 140 )

local friendstable = {
	[TEAM_GUARD] = {TEAM_SECURITY, TEAM_SCI, TEAM_SPECIAL, TEAM_NTF, TEAM_QRT},
	[TEAM_SECURITY] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_NTF, TEAM_QRT},
	[TEAM_NTF] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_QRT},
	[TEAM_QRT] = {TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_NTF},
	[TEAM_SCI] = {TEAM_SPECIAL, TEAM_SECURITY, TEAM_GUARD, TEAM_NTF, TEAM_QRT},
	[TEAM_SPECIAL] = {TEAM_SCI, TEAM_SECURITY, TEAM_GUARD, TEAM_NTF, TEAM_QRT},
	[TEAM_CHAOS] = {TEAM_CLASSD},
	[TEAM_CLASSD] = {TEAM_CHAOS},
}

local friendsgrufriendly = {
	TEAM_GUARD, TEAM_SCI, TEAM_SPECIAL, TEAM_SECURITY, TEAM_QRT
}

function IsTeamKill(victim, attacker)
	if !IsValid(victim) or !IsValid(attacker) then return false end
	local vteam = victim:GTeam()
	local ateam = attacker:GTeam()
	if victim == attacker then return false end
	if vteam == ateam then return true end
	if ateam == TEAM_GRU and table.HasValue(friendsgrufriendly, vteam) and GRU_Objective == GRU_Objectives["MilitaryHelp"] then return true end
	if table.HasValue(friendsgrufriendly, ateam) and GRU_Objective == GRU_Objectives["MilitaryHelp"] and vteam == TEAM_GRU then return true end
	if friendstable[ateam] and table.HasValue(friendstable[ateam], vteam) then return true end
	return false
end

sound.Add( {

	name = "character.inventory_interaction",
	volume = .1,
	channel = CHAN_STATIC,
	sound = "nextoren/charactersounds/inventory/nextoren_inventory_select.ogg"

} )

local function DrawInspectWindow( wep, customname, id )

	if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

		BREACH.Inventory.InspectWindow:Remove()

	end

	local client = LocalPlayer()

	if ( ( BREACH.Inventory.NextSound || 0 ) < CurTime() ) then

		BREACH.Inventory.NextSound = CurTime() + FrameTime() * 33
		client:EmitSound( "character.inventory_interaction" )

	end

	BREACH.Inventory.SelectedID = id

	surface.SetFont( "BudgetNewSmall2" )
	local swidth, sheight = surface.GetTextSize( customname || GetLangWeapon(wep.ClassName) || "ERROR!" )

	BREACH.Inventory.InspectWindow = vgui.Create( "DPanel" )
	BREACH.Inventory.InspectWindow:SetSize( swidth + 8, sheight + 4 )
	BREACH.Inventory.InspectWindow:SetText( "" )
	BREACH.Inventory.InspectWindow:SetPos( gui.MouseX() + 15, gui.MouseY() )
	BREACH.Inventory.InspectWindow.OnRemove = function()

		if ( IsValid( BREACH.Inventory ) ) then

			BREACH.Inventory.SelectedID = nil

		end

	end
	BREACH.Inventory.InspectWindow.Paint = function( self, w, h )

		if ( !vgui.CursorVisible() ) then

			self:Remove()

		end

		self:SetPos( gui.MouseX() + 15, gui.MouseY() )
		DrawBlurPanel( self )
		draw.RoundedBox( 0, 0, 0, w, h, clrgreyinspect )
		draw.OutlinedBox( 0, 0, w, h, 2, color_black )

		if ( !customname ) then

			self:SetSize( swidth + 8, sheight + 4 )
			draw.SimpleText( customname || GetLangWeapon(wep.ClassName) || "ERROR!", "BudgetNewSmall2", 5, 2, clrgreyinspect2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
			draw.SimpleText( customname || GetLangWeapon(wep.ClassName) || "ERROR!", "BudgetNewSmall2", 4, 0, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	



		else

			self:SetSize( swidth + 8, sheight + 4 )
			draw.SimpleText( customname || GetLangWeapon(wep.ClassName) || "ERROR!", "BudgetNewSmall2", 6, 2, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
			draw.SimpleText( customname || GetLangWeapon(wep.ClassName) || "ERROR!", "BudgetNewSmall2", 4, 0, ColorAlpha( color_white, 210 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
			
		end

	end

end

local frame = Material( "nextoren_hud/inventory/whitecount.png" )
local backgroundmat = Material( "nextoren_hud/inventory/menublack.png" )
local modelbackgroundmat = Material( "nextoren_hud/inventory/texture_blanc.png" )
local missing = Material( "nextoren/gui/icons/missing.png" )

local SquareHead = {

	["19201080"] = .5,
	["12801024"] = .7,
	["1280960"] = .7,
	["1152864"] = .7,
	["1024768"] = .76

}

local boxclr = Color( 128, 128, 128, 144 )
local clr_green = Color( 0, 180, 0, 210 )
local team_spec_index = TEAM_SPEC

local clr_red = Color( 130, 0, 0, 210 )

local angle_front = Angle( 0, 90, 0 )

--[[local button_translation = {

	[ "MOUSE1" ] = "ПКМ",
	[ "MOUSE2" ] = "ЛКМ"

}]]

--[[
concommand.Add("SetZombie2", function()

	for _, ply in ipairs(player.GetAll()) do

		SetZombie1( ply )

	end
end)
--]]

function TakeWep(entid, weaponname)
	net.Start( "LC_TakeWep" )
		net.WriteEntity( LocalPlayer():GetEyeTrace().Entity )
		net.WriteString( weaponname )
	net.SendToServer()
end

local function DrawNewInventory( notvictim, vtab )

	local client = LocalPlayer()

	if ( client:Health() <= 0 ) then return end

	local client_team = client:GTeam()

	if ( client_team == team_spec_index || client_team == TEAM_SCP ) then return end

	if ( IsValid( BREACH.Inventory ) ) then

		BREACH.Inventory:Remove()

	end

	local mainsize = .6

	local screenwidth = math.min( ScrW(), 1920 )
	local screenheight = math.min( ScrH(), 1080 )

	local str_resolution = tostring( screenwidth .. screenheight )

	for k, v in pairs( SquareHead ) do

		if ( k == str_resolution ) then

			mainsize = v

		end

	end

	local inv_width = math.max( screenwidth * mainsize, 960 )
	local realheight = ScrH()

	BREACH.Inventory = vgui.Create( "DPanel" )
	BREACH.Inventory:SetPos( ScrW() / 2 - ( ( inv_width * BetterScreenScale() ) / 2 ), realheight / 4 )
	BREACH.Inventory:SetSize( inv_width * BetterScreenScale(), 512 )
	BREACH.Inventory:SetText( "" )
	local old_count = #client:GetWeapons()
	BREACH.Inventory.Paint = function( self, w, h )

		if ( client:Health() <= 0 || client:IsFrozen() || client.StartEffect || !vgui.CursorVisible() || client:GTeam() == team_spec_index || client.MovementLocked && !vtab ) then

			HideEQ()

			return
		end

		surface.SetDrawColor( color_white )
		surface.SetMaterial( backgroundmat )
		surface.DrawTexturedRect( 0, 0, w, h )

		if ( notvictim ) then

			draw.SimpleText( client:GetName(), "BudgetNewSmall", w / 2, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		else

			if ( vtab.Entity:GetPos():DistToSqr( client:GetPos() ) > 4900 ) then

				HideEQ()

			end

			draw.SimpleText( vtab.Name, "MainMenuDescription", w / 2, 32, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		end

		if ( notvictim ) then

			if ( #client:GetWeapons() != old_count ) then

				for _, weapon in ipairs( client:GetWeapons() ) do

					if ( !weapon.Equipableitem && !weapon.UnDroppable && !table.HasValue( EQHUD.weps, weapon ) ) then

						EQHUD.weps[ #EQHUD.weps + 1 ] = weapon

					elseif ( weapon.Equipableitem && !table.HasValue( EQHUD.weps.Equipable, weapon ) ) then

						EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = weapon

					elseif ( weapon.UnDroppable && !table.HasValue( EQHUD.weps.UndroppableItem, weapon ) ) then

						EQHUD.weps.UndroppableItem[ #EQHUD.weps.UndroppableItem + 1 ] = weapon

					end

				end

				old_count = #client:GetWeapons()

			end

		end

		draw.OutlinedBox( 0, 0, w, h, 2, color_white )

	end

	BREACH.Inventory.Slot 				= {}
	BREACH.Inventory.Items 				= {}
	BREACH.Inventory.Model			 	= {}
	BREACH.Inventory.Clothes 			= {}
	BREACH.Inventory.Undroppable 	= {}

	if ( notvictim ) then

		local modelpanel_height = 188 * BetterScreenScale()

		BREACH.Inventory.Model = vgui.Create( "DPanel", BREACH.Inventory )
		BREACH.Inventory.Model:SetText( "" )
		BREACH.Inventory.Model:SetSize( 138 * BetterScreenScale(), modelpanel_height )
		BREACH.Inventory.Model:SetPos( BREACH.Inventory.Model:GetParent():GetSize() / 2 - 28, 64 )
		BREACH.Inventory.Model.Paint = function( self, w, h )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( modelbackgroundmat )
			surface.DrawTexturedRect( 0, 0, w, h )

		end

		BREACH.Inventory.Model[ "Model" ] = vgui.Create( "DModelPanel", BREACH.Inventory.Model )
		BREACH.Inventory.Model[ "Model" ]:SetModel( "models/buildables/teleporter.mdl" )
		BREACH.Inventory.Model[ "Model" ]:SetPos( 0, 0 )
		BREACH.Inventory.Model[ "Model" ]:SetPaintedManually( false )
		BREACH.Inventory.Model[ "Model" ]:SetSize( 138 * BetterScreenScale(), modelpanel_height )

		if ( client:GetModel() ) then

			BREACH.Inventory.Model[ "Model" ].Entity:SetModel( client:GetModel() )
			BREACH.Inventory.Model[ "Model" ].Entity:SetSkin( client:GetSkin() )

			for _, v in ipairs( client:GetBodyGroups() ) do

				BREACH.Inventory.Model[ "Model" ].Entity:SetBodygroup( v.id, client:GetBodygroup( v.id ) )

			end

			BREACH.Inventory.Model[ "Model" ]:SetFOV( 40 )
			local obb = BREACH.Inventory.Model[ "Model" ].Entity:OBBCenter()

			if ( ents.FindByClassAndParent( "ent_bonemerged", client ) ) then

				local tbl_bonemerged = ents.FindByClassAndParent( "ent_bonemerged", client )
		
				for i = 1, #tbl_bonemerged do
			
					local bonemerge = tbl_bonemerged[ i ]
			
					if ( bonemerge && bonemerge:IsValid() ) then
						BREACH.Inventory.Model[ "Model" ]:BoneMerged({bonemerge}, bonemerge:GetSubMaterial(0), bonemerge:GetInvisible())
						--[[
			
						local charav2 = vgui.Create( "DModelPanel", BREACH.Inventory.Model )
						charav2:SetSize(138 * BetterScreenScale(), modelpanel_height)
						charav2:SetPos(0, 0)
						charav2:SetModel( bonemerge:GetModel() )
						charav2:SetFOV( 40 )
						charav2:SetColor( color_white )
						function charav2:LayoutEntity( entity )
					
							entity:SetAngles(Angle(0,0,0))
							entity:SetParent(BREACH.Inventory.Model[ "Model" ].Entity)
							entity:AddEffects(EF_BONEMERGE)

							if ! (bonemerge && bonemerge:IsValid()) then return end
							entity:SetSkin(bonemerge:GetSkin())
			

					
						end
						local ent2 = charav2:GetEntity()
						if client:GTeam() != TEAM_SCP then
							charav2:SetLookAt( obb )
							charav2:SetCamPos( Vector( 0, ( modelpanel_height / 2 ) - ( ( obb.z / 2 ) * BetterScreenScale() ), obb.z + 5 ) )
						end
						--]]
					end
			
				end
			
			end

			local iSeq = BREACH.Inventory.Model["Model"].Entity:LookupSequence( "idle_all_01" )

			BREACH.Inventory.Model[ "Model" ]:SetCamPos( Vector( 0, ( modelpanel_height / 2 ) - ( ( obb.z / 2 ) * BetterScreenScale() ), obb.z + 5 ) )

			if ( iSeq > 0 ) then

				BREACH.Inventory.Model[ "Model" ].Entity:ResetSequence( iSeq )

			end

			BREACH.Inventory.Model[ "Model" ].__LayoutEntity = BREACH.Inventory.Model[ "Model" ].__LayoutEntity || BREACH.Inventory.Model[ "Model" ].LayoutEntity
			BREACH.Inventory.Model[ "Model" ].LayoutEntity = function( ent )

				BREACH.Inventory.Model[ "Model" ].Entity:SetAngles( angle_front )
				BREACH.Inventory.Model[ "Model" ].Entity:SetPos( Vector( 0, 0, -5 ) )
				BREACH.Inventory.Model[ "Model" ]:SetLookAt( obb )

			end

		end

		BREACH.Inventory.Model[ "Model" ].OutlinePanel = vgui.Create( "DPanel", BREACH.Inventory.Model[ "Model" ] )
		BREACH.Inventory.Model[ "Model" ].OutlinePanel:SetPos( 0, 0 )
		BREACH.Inventory.Model[ "Model" ].OutlinePanel:SetSize( BREACH.Inventory.Model[ "Model" ].OutlinePanel:GetParent():GetSize() )
		BREACH.Inventory.Model[ "Model" ].OutlinePanel.Paint = function( self, w, h )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( frame )
			surface.DrawTexturedRect( 0, 0, w, h )

		end

	end

	for i = 1, 8 do

		if ( i > 1 && i < 5 ) then

			local oldposx = BREACH.Inventory.Slot[ i - 1 ]:GetPos()
			local oldsize = BREACH.Inventory.Slot[ i - 1 ]:GetSize()

			BREACH.Inventory.Slot[ i ] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[ i ]:SetText( "" )
			BREACH.Inventory.Slot[ i ]:SetPos( oldposx + ( oldsize * 1.5 ), 264 )
			BREACH.Inventory.Slot[ i ]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )
			BREACH.Inventory.Slot[ i ].DoClick = function( self )

				if ( !EQHUD.weps ) then return end

				if ( notvictim && EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					if ( EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() && isstring( EQHUD.weps[ i ]:GetClass() ) ) then

						client:SelectWeapon( EQHUD.weps[ i ]:GetClass() )

					end

				elseif ( EQHUD.weps[ i ] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ i ].ClassName:find( "cw" ) ) then

							if ( weapons.Primary.Ammo == EQHUD.weps[ i ].Primary.Ammo ) then

								RXSENDNotify( "У Вас уже есть данный тип оружия." )

								return
							end

						end

					end

					if ( client:HasWeapon( EQHUD.weps[ i ].ClassName ) ) then

						RXSENDNotify( "У Вас уже есть этот предмет." )
						return
					end

					TakeWep(client:GetEyeTrace().Entity, EQHUD.weps[ i ].ClassName)

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].DoRightClick = function( self )

				if ( !notvictim ) then return end

				if ( EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].Paint = function( self, w, h )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ i ]
						if ( weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorEntered = function( self )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim && EQHUD.weps[ i ]:IsValid() ) then

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		elseif ( i > 5 ) then

			local oldposx = BREACH.Inventory.Slot[ i - 1 ]:GetPos()
			local oldsize = BREACH.Inventory.Slot[ i - 1 ]:GetSize()

			BREACH.Inventory.Slot[ i ] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[ i ]:SetText( "" )
			BREACH.Inventory.Slot[ i ]:SetPos( oldposx + ( oldsize * 1.5 ), 264 + 124 )
			BREACH.Inventory.Slot[ i ]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )

			BREACH.Inventory.Slot[ i ].DoClick = function( self )

				if ( notvictim && EQHUD.weps[i] && EQHUD.weps[ i ]:IsValid() ) then

					client:SelectWeapon( EQHUD.weps[i]:GetClass() )

				elseif ( EQHUD.weps[ i ] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ i ].ClassName:find( "cw" ) && weapons.Primary.Ammo == EQHUD.weps[ i ].Primary.Ammo ) then

							BREACH.Player:ChatPrint( true, true, "У Вас уже есть данный тип оружия." )

							return

						end

					end

					if ( client:HasWeapon( EQHUD.weps[ i ].ClassName ) ) then

						BREACH.Player:ChatPrint( true, true, "У Вас уже есть этот предмет." )
						return
					end

					TakeWep(client:GetEyeTrace().Entity, EQHUD.weps[ i ].ClassName)

					EQHUD.weps[i] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].DoRightClick = function( self )

				if ( !notvictim ) then return end
				if ( EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].Paint = function( self, w, h )

				--draw.RoundedBoxEx( 2, 0, 0, w, h, color_black, false, false, false, false )
				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ i ]
						if ( weapon && weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorEntered = function( self )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						if ( EQHUD.weps[ i ]:IsValid() ) then

							DrawInspectWindow( EQHUD.weps[ i ], nil, i )

						end

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		end

		if ( i == 1 ) then

			BREACH.Inventory.Slot[i] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[i]:SetText( "" )
			BREACH.Inventory.Slot[i]:SetPos( 68, 264 )
			BREACH.Inventory.Slot[i]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )
			BREACH.Inventory.Slot[i].DoClick = function( self )

				if ( notvictim && EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:SelectWeapon( EQHUD.weps[ i ]:GetClass() )

				elseif ( EQHUD.weps[i] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ i ].ClassName:find( "cw" ) ) then

							if ( weapons.Primary.Ammo == EQHUD.weps[ i ].Primary.Ammo ) then

								BREACH.Player:ChatPrint( true, true, "У Вас уже есть данный тип оружия." )

								return
							end

						end

					end

					if ( client:HasWeapon( EQHUD.weps[i].ClassName ) ) then return end
                    
                    --[[

					client.JustSpawned = true

					client:Give( EQHUD.weps[ i ]:GetClass() )
	
					timer.Simple( 0.1, function()
						client.JustSpawned = false
					end)]]
                    TakeWep(client:GetEyeTrace().Entity, EQHUD.weps[ i ].ClassName)

					EQHUD.weps[i] = nil

				end

			end
			BREACH.Inventory.Slot[i].Paint = function( self, w, h )

				--draw.RoundedBoxEx( 2, 0, 0, w, h, color_black, false, false, false, false )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ i ]
						if ( weapon && weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

			end

			BREACH.Inventory.Slot[ i ].DoRightClick = function( self )

				if ( !notvictim ) then return end
				if ( EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorEntered = function( self )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						if ( EQHUD.weps[ i ]:IsValid() ) then

							DrawInspectWindow( EQHUD.weps[ i ], nil, i )

						end

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		elseif ( i == 5 ) then

			BREACH.Inventory.Slot[i] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[i]:SetText( "" )
			BREACH.Inventory.Slot[i]:SetPos( 68, 264 + 124 )
			BREACH.Inventory.Slot[i]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )
			BREACH.Inventory.Slot[i].DoClick = function( self )

				if ( notvictim && EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:SelectWeapon( EQHUD.weps[ i ]:GetClass() )

				elseif ( EQHUD.weps[ i ] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ i ].ClassName:find( "cw" ) ) then

							if ( weapons.Primary.Ammo == EQHUD.weps[ i ].Primary.Ammo ) then

								BREACH.Player:ChatPrint( true, true, "У Вас уже есть данный тип оружия." )

								return
							end

						end

					end

					if ( client:HasWeapon( EQHUD.weps[ i ].ClassName ) ) then return end

					--client:Give( EQHUD.weps[i]:GetClass() )
					 TakeWep(client:GetEyeTrace().Entity, EQHUD.weps[ i ].ClassName)--TakeWep(nil, EQHUD.weps[i])

					EQHUD.weps[i] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].DoRightClick = function( self )

				if ( !notvictim ) then return end
				if ( EQHUD.weps[ i ] && EQHUD.weps[ i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ i ].Paint = function( self, w, h )

				--draw.RoundedBoxEx( 2, 0, 0, w, h, boxclr2, false, false, false, false )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ i ]
						if ( weapon && weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

				if ( client:GetMaxSlots() < i ) then

					draw.RoundedBoxEx( 2, 0, 0, w, h, boxclr, false, false, false, false )

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorEntered = function( self )

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						if ( EQHUD.weps[ i ]:IsValid() ) then

							DrawInspectWindow( EQHUD.weps[ i ], nil, i )

						end

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		end

	end

	--[[ Extra slots ]]--
	for i = 1, 4 do

		if ( i <= 2 ) then

			local oldposx = BREACH.Inventory.Slot[ 4 ]:GetPos()
			local oldsize = BREACH.Inventory.Slot[ 4 ]:GetSize()

			BREACH.Inventory.Slot[ 8 + i ] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[ 8 + i ]:SetText( "" )
			BREACH.Inventory.Slot[ 8 + i ]:SetPos( oldposx + ( ( oldsize * 1.5 ) * i ), 264 )
			BREACH.Inventory.Slot[ 8 + i ]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )
			BREACH.Inventory.Slot[ 8 + i ].DoClick = function( self )

				if ( notvictim && EQHUD.weps[ 8 + i ] && EQHUD.weps[ 8 + i ]:IsValid() ) then

					client:SelectWeapon( EQHUD.weps[8 + i]:GetClass() )

				elseif ( EQHUD.weps[8 + i] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ 8 + i ].ClassName:find( "cw" ) ) then

							if ( weapons.Primary.Ammo == EQHUD.weps[ 8 + i ].PrimaryAmmo ) then

								BREACH.Player:ChatPrint( true, true, "У Вас уже есть данный тип оружия." )

								return
							end

						end

					end

					if ( client:HasWeapon( EQHUD.weps[ 8 + i ].ClassName ) ) then

						BREACH.Player:ChatPrint( true, true, "У Вас уже есть этот предмет." )
						return
					end

					client.JustSpawned = true

					client:Give( EQHUD.weps[ 8 + i ]:GetClass() )
	
					timer.Simple( 0.1, function()
						client.JustSpawned = false
					end)

					EQHUD.weps[8 + i] = nil

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].Paint = function( self, w, h )

				if ( EQHUD.weps[ 8 + i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ 8 + i ]
						if ( weapon && weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ 8 + i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

				if ( client:GetMaxSlots() < 8 + i ) then

					draw.RoundedBoxEx( 2, 0, 0, w, h, boxclr, false, false, false, false )

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].DoRightClick = function( self )

				if ( !notvictim ) then return end
				if ( EQHUD.weps[ 8 + i ] && EQHUD.weps[ 8 + i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ 8 + i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ 8 + i ] = nil

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].OnCursorEntered = function( self )

				local i = 8 + i

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						if ( EQHUD.weps[ i ]:IsValid() ) then

							DrawInspectWindow( EQHUD.weps[ i ], nil, i )

						end

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		else

			local oldposx = BREACH.Inventory.Slot[ 8 ]:GetPos()
			local oldsize = BREACH.Inventory.Slot[ 8 ]:GetSize()

			BREACH.Inventory.Slot[ 8 + i ] = vgui.Create( "DButton", BREACH.Inventory )
			BREACH.Inventory.Slot[ 8 + i ]:SetText( "" )
			BREACH.Inventory.Slot[ 8 + i ]:SetPos( oldposx + ( ( oldsize * 1.5 ) * ( i - 2 ) ), 264 + 124 )
			BREACH.Inventory.Slot[ 8 + i ]:SetSize( 96 * BetterScreenScale(), 96 * BetterScreenScale() )
			BREACH.Inventory.Slot[ 8 + i ].DoClick = function( self )

				local i = 8 + i

				if ( notvictim && EQHUD.weps[ i ] && EQHUD.weps[ i ] ) then

					client:SelectWeapon( EQHUD.weps[ i ]:GetClass() )

				elseif ( EQHUD.weps[ i ] && !notvictim ) then

					for _, weapons in ipairs( client:GetWeapons() ) do

						if ( weapons.CW20Weapon && EQHUD.weps[ i ].ClassName:find( "cw" ) ) then

							if ( weapons.Primary.Ammo == EQHUD.weps[ i ].Primary.Ammo ) then

								BREACH.Player:ChatPrint( true, true, "У Вас уже есть данный тип оружия." )

								return
							end

						end

					end

					if ( client:HasWeapon( EQHUD.weps[ i ].ClassName ) ) then

						BREACH.Player:ChatPrint( true, true, "У Вас уже есть этот предмет." )
						return
					end

					client.JustSpawned = true

					client:Give( EQHUD.weps[ i ] )
	
					timer.Simple( 0.1, function()
						client.JustSpawned = false
					end)

					EQHUD.weps[ i ] = nil

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].DoRightClick = function( self )

				if ( !notvictim ) then return end
				if ( EQHUD.weps[ 8 + i ] && EQHUD.weps[ 8 + i ]:IsValid() ) then

					client:DropWeapon( EQHUD.weps[ 8 + i ]:GetClass() )
					if ( SERVER ) then

						net.Start( "DropAnimation" )
						net.Send( client )

					end

					EQHUD.weps[ 8 + i ] = nil

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].Paint = function( self, w, h )

				local i = 8 + i

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						local weapon = EQHUD.weps[ i ]
						if ( weapon && weapon:IsValid() ) then

							surface.SetDrawColor( color_white )
							surface.SetMaterial( weapon.InvIcon || missing )
							surface.DrawTexturedRect( 0, 0, w, h )

						end

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

						if ( weapon == LocalPlayer():GetActiveWeapon() ) then

							draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

						end

						if ( BREACH.Inventory.SelectedID == i ) then

							draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

						end

					else

						surface.SetDrawColor( color_white )
						surface.SetMaterial( EQHUD.weps[ i ].InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

						surface.SetDrawColor( color_white )
						surface.SetMaterial( frame )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

				if ( client:GetMaxSlots() < i ) then

					draw.RoundedBoxEx( 2, 0, 0, w, h, boxclr, false, false, false, false )

				end



			end

			BREACH.Inventory.Slot[ 8 + i ].OnCursorEntered = function( self )

				local i = 8 + i

				if ( EQHUD.weps[ i ] ) then

					if ( notvictim ) then

						if ( EQHUD.weps[ i ]:IsValid() ) then

							DrawInspectWindow( EQHUD.weps[ i ], nil, i )

						end

					else

						DrawInspectWindow( EQHUD.weps[ i ], nil, i )

					end

				end

			end

			BREACH.Inventory.Slot[ 8 + i ].OnCursorExited = function( self )

				if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

					BREACH.Inventory.InspectWindow:Remove()

				end

			end

		end

	end

	for i = 1, 6 do -- Equipable items

		if ( i <= 2 ) then

			posy = 28

		elseif ( i >= 3 && i < 5 ) then

			posy = 100

		elseif ( i >= 5 ) then

			posy = 172

		end

		BREACH.Inventory.Items[i] = vgui.Create( "DButton", BREACH.Inventory )
		BREACH.Inventory.Items[i]:SetText( "" )
		BREACH.Inventory.Items[i]:SetSize( 64 * BetterScreenScale(), 64 * BetterScreenScale() )
		BREACH.Inventory.Items[i]:SetPos(  68 + ( 84 * ( i % 2 ) ), posy )
		BREACH.Inventory.Items[i].DoClick = function()

			if ( !EQHUD.weps.Equipable[i] ) then return end

			if ( EQHUD.weps.Equipable[i].ArmorType ) then 
				if EQHUD.weps.Equipable[i].ArmorType == "Armor" then
					net.Start("DropAdditionalArmor")
					net.WriteString(client:GetUsingArmor())
					net.SendToServer()
				end
				if EQHUD.weps.Equipable[i].ArmorType == "Hat" then
					net.Start("DropAdditionalArmor")
					net.WriteString(client:GetUsingHelmet())
					net.SendToServer()
				end
				if EQHUD.weps.Equipable[i].ArmorType == "Bag" then
					net.Start("DropAdditionalArmor")
					net.WriteString(client:GetUsingBag())
					net.SendToServer()
				end
				EQHUD.weps.Equipable[i] = nil
				return
			end
			if ( EQHUD.weps.Equipable[i] && notvictim ) then

				client:SelectWeapon( EQHUD.weps.Equipable[i]:GetClass() )

			elseif ( EQHUD.weps.Equipable[i] && !notvictim ) then

				if ( client:HasWeapon( EQHUD.weps.Equipable[i].ClassName ) ) then return end

				TakeWep( client:GetEyeTrace().Entity, EQHUD.weps.Equipable[i].ClassName )

				EQHUD.weps.Equipable[i] = nil

			end

		end
		BREACH.Inventory.Items[ i ].DoRightClick = BREACH.Inventory.Items[ i ].DoClick

		BREACH.Inventory.Items[ i ].Paint = function( self, w, h )

			--draw.RoundedBoxEx( 2, 0, 0, w, h, color_black, false, false, false, false )

			if ( EQHUD.weps.Equipable && EQHUD.weps.Equipable[ i ] ) then

				if ( notvictim ) then

					local item = EQHUD.weps.Equipable[ i ]
					if ( item ) then

						surface.SetDrawColor( color_white )
						surface.SetMaterial( item.InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

					if ( item == LocalPlayer():GetActiveWeapon() ) then

						draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

					end

					if ( BREACH.Inventory.SelectedID == 18 + i ) then

						draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( EQHUD.weps.Equipable[ i ].InvIcon || missing )
					surface.DrawTexturedRect( 0, 0, w, h )

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

			else

				surface.SetDrawColor( color_white )
				surface.SetMaterial( frame )
				surface.DrawTexturedRect( 0, 0, w, h )

			end

		end

		BREACH.Inventory.Items[ i ].OnCursorEntered = function( self )

			if ( EQHUD.weps.Equipable[ i ] ) then

				if ( notvictim ) then

					DrawInspectWindow( EQHUD.weps.Equipable[ i ], nil, 18 + i )

				else

					DrawInspectWindow( EQHUD.weps.Equipable[ i ], nil, 18 + i )

				end

			end

		end

		BREACH.Inventory.Items[ i ].OnCursorExited = function( self )

			if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

				BREACH.Inventory.InspectWindow:Remove()

			end

		end

	end

	BREACH.Inventory.Clothes = vgui.Create( "DButton", BREACH.Inventory )
	BREACH.Inventory.Clothes:SetText( "" )
	BREACH.Inventory.Clothes:SetSize( 128 * BetterScreenScale(), 128 * BetterScreenScale() )
	BREACH.Inventory.Clothes:SetPos( BREACH.Inventory.Items[ 5 ]:GetPos() + 80 * BetterScreenScale(), 116 )
	BREACH.Inventory.Clothes.Paint = function( self, w, h )

		--draw.RoundedBoxEx( 2, 0, 0, w, h, color_black, false, false, false, false )

		local client = LocalPlayer()

		if ( client:GetUsingCloth() != "" ) then

			surface.SetDrawColor( color_white )
			surface.SetMaterial( scripted_ents.GetStored( client:GetUsingCloth() ).t.InvIcon || missing )
			surface.DrawTexturedRect( 0, 0, w, h )

			if ( self.Enable_Outline ) then

				draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( clr_red, 80 * math.abs( math.sin( RealTime() * 2 ) ) ) )

			end

		end

		surface.SetDrawColor( color_white )
		surface.SetMaterial( frame )
		surface.DrawTexturedRect( 0, 0, w, h )

		if ( self.Enable_Outline ) then

			draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( clr_red, 80 * math.abs( math.sin( RealTime() * 2 ) ) ) )

		end


	end
	BREACH.Inventory.Clothes.DoClick = function( self )

		net.Start( "DropCurrentVest" )
		net.SendToServer()


	end

	BREACH.Inventory.Clothes.OnCursorEntered = function( self )

		if ( client:GetUsingCloth() != "" ) then

			DrawInspectWindow( nil, scripted_ents.GetStored( client:GetUsingCloth() ).t.PrintName.." ( Нажмите \"ЛКМ\" для снятия )" )

		end

	end

	BREACH.Inventory.Clothes.OnCursorExited = function( self )

		if ( IsValid( BREACH.Inventory.InspectWindow ) ) then

			BREACH.Inventory.InspectWindow:Remove()

		end

		self.Enable_Outline = nil

	end

	for i = 1, 6 do

		if ( i <= 2 ) then

			posy = 28

		elseif ( i <= 4 ) then

			posy = 100

		elseif ( i <= 6 ) then

			posy = 172

		end

		local oldsize = ( 64 * BetterScreenScale() )

		if ( BREACH.Inventory.Undroppable[ i - 1 ] ) then

			oldsize = BREACH.Inventory.Undroppable[ i - 1 ]:GetSize()

		end

		BREACH.Inventory.Undroppable[ i ] = vgui.Create( "DButton", BREACH.Inventory )
		BREACH.Inventory.Undroppable[ i ]:SetText( "" )
		BREACH.Inventory.Undroppable[ i ]:SetSize( 64 * BetterScreenScale(), 64 * BetterScreenScale() )
		BREACH.Inventory.Undroppable[ i ]:SetPos( ( BREACH.Inventory.Undroppable[ i ]:GetParent():GetSize() * .9 ) - oldsize - ( 84 * ( i % 2 ) ), posy )
		BREACH.Inventory.Undroppable[ i ].Paint = function( self, w, h )

			--draw.RoundedBoxEx( 2, 0, 0, w, h, color_black, false, false, false, false )

			if ( EQHUD.weps.UndroppableItem && EQHUD.weps.UndroppableItem[ i ] ) then

				if ( notvictim ) then

					local item = EQHUD.weps.UndroppableItem[ i ]
					if ( item:IsValid() ) then

						surface.SetDrawColor( color_white )
						surface.SetMaterial( item.InvIcon || missing )
						surface.DrawTexturedRect( 0, 0, w, h )

					end

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

					if ( item == LocalPlayer():GetActiveWeapon() ) then

						draw.OutlinedBox( 0, 0, w, h, 2, clr_green )

					end

					if ( BREACH.Inventory.SelectedID == i + 12 ) then

						draw.OutlinedBox( 0, 0, w, h, 2, ColorAlpha( color_black, 210 * math.abs( math.sin( RealTime() * 2 ) ) ) )

					end

				else

					surface.SetDrawColor( color_white )
					surface.SetMaterial( EQHUD.weps.UndroppableItem[ i ].InvIcon || missing )
					surface.DrawTexturedRect( 0, 0, w, h )

					surface.SetDrawColor( color_white )
					surface.SetMaterial( frame )
					surface.DrawTexturedRect( 0, 0, w, h )

				end

			else

				surface.SetDrawColor( color_white )
				surface.SetMaterial( frame )
				surface.DrawTexturedRect( 0, 0, w, h )

			end

		end

		BREACH.Inventory.Undroppable[ i ].DoClick = function()

			if ( notvictim && EQHUD.weps.UndroppableItem[ i ] && EQHUD.weps.UndroppableItem[ i ]:IsValid() ) then

				client:SelectWeapon( EQHUD.weps.UndroppableItem[ i ]:GetClass() )

			end

		end

		BREACH.Inventory.Undroppable[ i ].OnCursorEntered = function( self )

			if ( EQHUD.weps.UndroppableItem[ i ] ) then

				if ( notvictim ) then

					if ( EQHUD.weps.UndroppableItem[ i ]:IsValid() ) then

						DrawInspectWindow( EQHUD.weps.UndroppableItem[ i ], nil, i + 12 )

					end

				else

					DrawInspectWindow( EQHUD.weps.UndroppableItem[ i ], nil, i + 12 )

				end

			end

		end

		BREACH.Inventory.Undroppable[ i ].OnCursorExited = function( self )

			if ( BREACH.Inventory.InspectWindow ) then

				BREACH.Inventory.InspectWindow:Remove()

			end

		end

	end

end

--[[function DrawEQ()

	if ( !EQHUD.enabled ) then return end

end
hook.Add( "DrawOverlay", "DrawEQ", DrawEQ )]]

local cdforuse = 0
local cdforusetime = 0.2

function ShowEQ( notlottable, vtab )

	local client = LocalPlayer()

	if ( client.StartEffect || client.MovementLocked && !vtab ) then return end

	if ( client:IsFrozen() ) then return end

	if ( cdforuse > CurTime() && !vtab ) then return end

	EQHUD.enabled = true
	gui.EnableScreenClicker( true )

	EQHUD.weps = {}
	EQHUD.weps.Equipable = {}
	EQHUD.weps.UndroppableItem = {}

	if ( !notlottable ) then

		for _, weapon in pairs( vtab.Weapons ) do

			weapon = weapons.GetStored( weapon )

			if ( !weapon.Equipableitem && !weapon.UnDroppable ) then

				EQHUD.weps[ #EQHUD.weps + 1 ] = weapon

			elseif ( weapon.Equipableitem ) then

				EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = weapon

			elseif ( weapon.UnDroppable ) then

				EQHUD.weps.UndroppableItem[ #EQHUD.weps.UndroppableItem + 1 ] = weapon

			end

		end

	else
		
		if ( client:GetUsingHelmet() != "" ) then

			EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = scripted_ents.GetStored( client:GetUsingHelmet() ).t

		end

		if ( client:GetUsingArmor() != "" ) then

			EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = scripted_ents.GetStored( client:GetUsingArmor() ).t

		end

		if ( client:GetUsingBag() != "" ) then

			EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = scripted_ents.GetStored( client:GetUsingBag() ).t

		end

		for _, weapon in ipairs( client:GetWeapons() ) do

			if ( !weapon.Equipableitem && !weapon.UnDroppable ) then

				EQHUD.weps[ #EQHUD.weps + 1 ] = weapon

			elseif ( weapon.Equipableitem ) then

				EQHUD.weps.Equipable[ #EQHUD.weps.Equipable + 1 ] = weapon

			elseif ( weapon.UnDroppable ) then

				EQHUD.weps.UndroppableItem[ #EQHUD.weps.UndroppableItem + 1 ] = weapon

			end

		end

	end

	DrawNewInventory( notlottable, vtab )

end

function HideEQ( open_inventory )

	if ( !open_inventory ) then

		cdforuse = CurTime() + cdforusetime

	end

	EQHUD.enabled = false
	gui.EnableScreenClicker( false )

	if ( IsValid( BREACH.Inventory ) ) then

		BREACH.Inventory:Remove()

	end

	if ( open_inventory ) then

		net.Start( "ShowEQAgain" )
		net.SendToServer()

	else

		local client = LocalPlayer()

		if ( client.MovementLocked && !client.AttackedByBor ) then

			net.Start( "LootEnd" )
			net.SendToServer()

			client.MovementLocked = nil

		end

	end

end

function CanShowEQ()

	local client = LocalPlayer()

	local t = client:GTeam()

	return t != TEAM_SPEC && t != TEAM_SCP && client:Alive() && client:GetMoveType() != MOVETYPE_OBSERVER

end

function IsEQVisible()

	return EQHUD.enabled

end

function mply:HaveSpecialAb(name)
	for i, v in pairs(ALLCLASSES) do
		if i == "SCP" or i == "OTHER" then continue end
		for _, group in pairs(ALLCLASSES) do
			for _, class in pairs(group.roles) do
				if class.name != name then continue end
				if !class["ability"] then continue end
				if self:GetNWString("AbilityName") == class["ability"][1] then return true end
			end
		end
	end
	return false
end
hook.Add( "PlayerButtonDown", "Specials", function( ply, button )

	if ( button == KEY_H ) then

		if ply:GetSpecialCD() > CurTime() then return end

		if ply:IsFrozen() then return end

		if ply.MovementLocked == true then return end

		if ply:HaveSpecialAb(ROLES.ROLE_VOR) then

			if CLIENT then return end
			ply:LagCompensation(true)
			local DASUKADAIMNEEGO = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
				filter = ply
			} )
			ply:LagCompensation(false)
			local target = DASUKADAIMNEEGO.Entity
			if !IsValid(target) or !target:IsPlayer() or target:GTeam() == TEAM_SCP then
				ply:RXSENDNotify("Вы должны смотреть на цель, что-бы украсть у него что-то!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			if !IsValid(target:GetActiveWeapon()) or target:GetActiveWeapon().UnDroppable or target:GetActiveWeapon().droppable == false then
				ply:RXSENDNotify("Вы не можете украсть данный предмет у игрока!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			if ply:GetPrimaryWeaponAmount() == ply:GetMaxSlots() then
				ply:RXSENDNotify("Вы должны иметь свободный слот в инвентаре для кражи!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			if ply:HasWeapon(target:GetActiveWeapon():GetClass()) then
				ply:RXSENDNotify("У вас уже есть данный предмет!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			local stealweapon = target:GetActiveWeapon()
			ply:BrProgressBar("Обворовываем...", 1.45, "nextoren/gui/special_abilities/ability_placeholder.png", target, false, function()
				if IsValid(stealweapon) and stealweapon:GetOwner() == target then
					target:ForceDropWeapon(stealweapon:GetClass())
					ply.Shaky_PICKUPWEAPON = stealweapon
					local physobj = stealweapon:GetPhysicsObject()
					stealweapon:SetNoDraw(true)
					if IsValid(physobj) then
						physobj:EnableMotion(false)
					end
					timer.Create("WEAPON_GIVE_THIEF_"..ply:UniqueID(), FrameTime(), 9999, function()
						if ply:HasWeapon(stealweapon:GetClass()) or ply:GTeam() == TEAM_SPEC or ply:Health() <= 0 then
							stealweapon:SetNoDraw(false)
							local physobj = stealweapon:GetPhysicsObject()
							if IsValid(physobj) then
								physobj:EnableMotion(true)
							end
							timer.Remove("WEAPON_GIVE_THIEF_"..ply:UniqueID())
							return
						end
						if !ply:HasWeapon(stealweapon:GetClass()) then
							stealweapon:SetPos(ply:GetPos())
						end
					end)
					stealweapon:SetPos(ply:GetPos())
					ply:SetSpecialCD(CurTime() + 45)
				end
			end)

		elseif ply:HaveSpecialAb(ROLES.ROLE_CHAOSCMD) then

			if ply:GetSpecialMax() == 0 then return end

			ply:SetSpecialCD(CurTime() + 4)

			maxs_chaos = Vector( 8, 2, 5 )

			local trace = {}

			trace.start = ply:GetShootPos()

			trace.endpos = trace.start + ply:GetAimVector() * 165

			trace.filter = ply

			trace.mins = -maxs_chaos

			trace.maxs = maxs_chaos
		
			trace = util.TraceHull( trace )
		
			local target = trace.Entity

			if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() == TEAM_CLASSD ) then

				if target:GetModel() == "models/cultist/humans/chaos/chaos.mdl" or target:GetModel() == "models/cultist/humans/chaos/fat/chaos_fat.mdl" then 
					ply:RXSENDNotify("Цель уже получила экипировку.")
					return 
				end

				local count = 0

				for _, v in ipairs( target:GetWeapons() ) do
		
				  if ( !( v.UnDroppable || v.Equipableitem ) ) then
		
					count = count + 1
		
				  end
		
				end

				if ( ( count + 1 ) >= target:GetMaxSlots() ) then

					ply:ChatPrint("Цели требуется освободить место в инвентаре.")

					return

				end

				if SERVER then
					ply:BrProgressBar("Выдача униформы...", 8, "nextoren/gui/special_abilities/ability_placeholder.png")
				end

				old_target = target


				timer.Create("Chaos_Special_Recruiting_Check"..ply:SteamID(), 1, 8, function()

					if ply:GetEyeTrace().Entity != old_target then

						timer.Remove("Chaos_Special_Recruiting"..ply:SteamID())
						
						ply:ConCommand("stopprogress")

						timer.Remove("Chaos_Special_Recruiting_Check"..ply:SteamID())

					end

				end)

				timer.Create("Chaos_Special_Recruiting"..ply:SteamID(), 8, 1, function()

					if IsValid(ply) && IsValid(target) then

						local count = 0

						for _, v in ipairs( target:GetWeapons() ) do
				
						  if ( !( v.UnDroppable || v.Equipableitem ) ) then
				
							count = count + 1
				
						  end
				
						end

						if ( ( count + 1 ) >= target:GetMaxSlots() ) then

							ply:ChatPrint("Цели требуется освободить место в инвентаре.")

							return

						end

						ply:SetSpecialMax( ply:GetSpecialMax() - 1 )

						if SERVER then
							if target:GetNClass() != ROLES.ROLE_FAT then

								target:ClearBodyGroups()

							    target:SetModel("models/cultist/humans/chaos/chaos.mdl")

							    target:SetBodygroup( 1, 1 )

								target:SetBodygroup( 4, 1 )
								local hitgroup_head = target.ScaleDamage["HITGROUP_HEAD"]
								target.ScaleDamage = {

									["HITGROUP_HEAD"] = hitgroup_head,
									["HITGROUP_CHEST"] = 0.7,
									["HITGROUP_LEFTARM"] = 0.8,
									["HITGROUP_RIGHTARM"] = 0.8,
									["HITGROUP_STOMACH"] = 0.7,
									["HITGROUP_GEAR"] = 0.7,
									["HITGROUP_LEFTLEG"] = 0.8,
									["HITGROUP_RIGHTLEG"] = 0.8

								}

							else

								target:ClearBodyGroups()

							    target:SetModel("models/cultist/humans/chaos/fat/chaos_fat.mdl")

								local hitgroup_head = target.ScaleDamage["HITGROUP_HEAD"]

								target.ScaleDamage = {

									["HITGROUP_HEAD"] = 0.8,
									["HITGROUP_CHEST"] = 0.8,
									["HITGROUP_LEFTARM"] = 0.8,
									["HITGROUP_RIGHTARM"] = 0.8,
									["HITGROUP_STOMACH"] = 0.8,
									["HITGROUP_GEAR"] = 0.8,
									["HITGROUP_LEFTLEG"] = 0.8,
									["HITGROUP_RIGHTLEG"] = 0.8

								}

								target:SetArmor(target:Armor() + 30)

							end

							target:EmitSound( Sound("nextoren/others/cloth_pickup.wav") )

							target:Give("cw_kk_ins2_ak12")

							target:GiveAmmo(180, "AR2", true)

							target:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 1, 1 )

							target:SetupHands()

						end

					end

				end)

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_LESSION) then

			if ply:GetSpecialMax() <= 0 then return end

			if CLIENT then return end
			ply:LagCompensation(true)
			local DASUKADAIMNEEGO = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
				filter = ply
			} )
			ply:LagCompensation(false)
			if !DASUKADAIMNEEGO.Hit then
				ply:RXSENDNotify("Похоже, вы слишком далеко от точки на которой хотите поставить мину")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			if !DASUKADAIMNEEGO.Hit then
				ply:RXSENDNotify("Мина должна стоять на полу!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			local mine = ents.Create("ent_special_trap")
			mine:SetPos(DASUKADAIMNEEGO.HitPos)
			mine:SetOwner(ply)
			mine:Spawn()
			ply:SetSpecialMax(ply:GetSpecialMax() - 1)
			ply:SetSpecialCD(CurTime() + 40)
			ply:EmitSound("nextoren/vo/special_sci/trapper/trapper_"..math.random(1,10)..".mp3")

		elseif ply:HaveSpecialAb(ROLES.ROLE_CHAOSDESTROYER) then

			if ply:GetSpecialMax() <= 0 then return end

			if CLIENT then return end
			ply:LagCompensation(true)
			local DASUKADAIMNEEGO = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
				filter = ply
			} )
			ply:LagCompensation(false)
			if !DASUKADAIMNEEGO.Hit then
				ply:RXSENDNotify("Похоже, вы слишком далеко от точки на которой хотите поставить мину")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			if !DASUKADAIMNEEGO.Hit then
				ply:RXSENDNotify("Мина должна стоять на полу!")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			local claymore = ents.Create("ent_chaos_mine")
			claymore:SetPos(DASUKADAIMNEEGO.HitPos)
			claymore:SetOwner(ply)
			claymore:Spawn()
			ply:SetSpecialMax(ply:GetSpecialMax() - 1)
			ply:SetSpecialCD(CurTime() + 4)

		elseif ply:HaveSpecialAb(ROLES.ROLE_TOPKEK) then
			local angle_zero = Angle(0,0,0)
			ply:LagCompensation(true)
		local DASUKADAIMNEEGO = util.TraceLine( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
			filter = ply
		} )
		local target = DASUKADAIMNEEGO.Entity
		ply:LagCompensation(false)

		if !ply:IsOnGround() then
			ply:RXSENDNotify("Вы должны стоять на полу.")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		if !IsValid(target) or !target.GTeam or target:GTeam() == TEAM_SPEC then
			ply:RXSENDNotify("Для прогиба смотрите на цель.")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		if !ply:IsSuperAdmin() and target:GTeam() == TEAM_SCP and !target.IsZombie then
			ply:RXSENDNotify("Для прогиба смотрите на цель.")
			ply:SetSpecialCD(CurTime() + 3)
			return
		end
		ply:Freeze(true)
		target:Freeze(true)
		ply:SetMoveType(MOVETYPE_OBSERVER)
		target:SetMoveType(MOVETYPE_OBSERVER)
		ply:SetNWBool("IsNotForcedAnim", false)
		target:SetNWBool("IsNotForcedAnim", false)
		ply:SetSpecialCD(CurTime() + 65)
		local startcallbackattacker = function()
			ply:SetNWEntity("NTF1Entity", ply)
			ply:Freeze(true)
			ply.ProgibTarget = target
			sound.Play("nextoren/charactersounds/special_moves/bor/grab_start.wav", ply:GetPos(), 120, 100, 2)
			sound.Play("nextoren/charactersounds/special_moves/bor/victim_struggle_6.wav", ply:GetPos(), 120, 100, 2)
			target.ProgibTarget = ply
			local vec_pos = target:GetShootPos() + ( ply:GetShootPos() - target:EyePos() ):Angle():Forward() * 1.5
			vec_pos.z = ply:GetPos().z
			target:SetPos(vec_pos)
			ply:SetNWAngle( "ViewAngles", ( target:GetShootPos() - ply:EyePos() ):Angle() )
			target:SetNWAngle( "ViewAngles", ( ply:GetShootPos() - target:EyePos() ):Angle() )
		end
		local stopcallbackattacker = function()
			ply:SetNWEntity("NTF1Entity", NULL)
			ply:SetNWAngle("ViewAngles", angle_zero)
			ply:Freeze(false)
			ply.ProgibTarget = nil
			ply:SetNWBool("IsNotForcedAnim", true)
			ply:SetMoveType(MOVETYPE_WALK)
		end
		local finishcallbackattacker = function()
			ply:SetNWEntity("NTF1Entity", NULL)
			ply:SetNWAngle("ViewAngles", angle_zero)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:TakeDamage(1000000, ply, "КАЧОК СУКА ХУЯЧИТ")
			ply:Freeze(false)
			ply.ProgibTarget = nil
			ply:SetNWBool("IsNotForcedAnim", true)
			ply:SetMoveType(MOVETYPE_WALK)

			target:StopForcedAnimation()
			sound.Play("nextoren/charactersounds/hurtsounds/fall/pldm_fallpain0"..math.random(1, 2)..".wav", ply:GetShootPos(), math.random(50,70), 555)
		end
		local startcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", target)
			target:Freeze(true)
			target.ProgibTarget = ply
			ply.ProgibTarget = target
		end
		local stopcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", NULL)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:Freeze(false)
			target.ProgibTarget = nil
			target:SetNWBool("IsNotForcedAnim", true)
			target:SetMoveType(MOVETYPE_WALK)
		end
		local finishcallbackvictim = function()
			target:SetNWEntity("NTF1Entity", NULL)
			target:SetNWAngle("ViewAngles", angle_zero)
			target:Freeze(false)
			target.ProgibTarget = nil
			target:SetNWBool("IsNotForcedAnim", true)
			target:SetMoveType(MOVETYPE_WALK)
		end
		ply:SetForcedAnimation(ply:LookupSequence("1_bor_progib_attacker"), 5.5, startcallbackattacker, finishcallbackattacker, stopcallbackattacker)
		target:SetForcedAnimation(target:LookupSequence("1_bor_progib_resiver"), 5.5, startcallbackvictim, finishcallbackvictim, stopcallbackvictim)

		elseif ply:HaveSpecialAb(ROLES.ROLE_GoPCMD) then
			ply:SetSpecialCD(CurTime() + 80)
			if CLIENT then 
				local hands = ply:GetHands()
				local ef = EffectData()
				ef:SetEntity(hands)
				util.Effect("gocabilityeffect", ef)
				return
			end

			local ef = EffectData()
			ef:SetEntity(ply)
			util.Effect("gocabilityeffect", ef)
			BroadcastLua("local ef = EffectData() ef:SetEntity(Entity("..tostring(ply:EntIndex())..")) util.Effect(\"gocabilityeffect\", ef)")

			ply:BrProgressBar("Вход в невидимость...", 0.8, "nextoren/gui/icons/notifications/breachiconfortips.png")

			timer.Simple(0.8, function()
				if IsValid(ply) and ply:HaveSpecialAb(ROLES.ROLE_GoPCMD) then
					ply:ScreenFade(SCREENFADE.IN, gteams.GetColor(TEAM_GOC), 0.5, 0)
					ply:RXSENDNotify("Ваша способность была активирована, теперь вы невидимы.")
					ply:SetNoDraw(true)
					ply.CommanderAbilityActive = true
					for _, wep in pairs(ply:GetWeapons()) do wep:SetNoDraw(true) end
					timer.Create("Goc_Commander_"..ply:UniqueID(), 20, 1, function()
						if !ply.CommanderAbilityActive then return end
						ply:SetNoDraw(false)
						ply.CommanderAbilityActive = nil
						for _, wep in pairs(ply:GetWeapons()) do wep:SetNoDraw(false) end
					end)
				end
			end)

		elseif ply:HaveSpecialAb(ROLES.ROLE_SCIRECRUITER) then
			if ply:GetSpecialMax() == 0 then return end
			local angle_zero = Angle(0,0,0)
			ply:LagCompensation(true)
			local DASUKADAIMNEEGO = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
				filter = ply
			} )
			local target = DASUKADAIMNEEGO.Entity
			ply:LagCompensation(false)
			if SERVER then
				if !IsValid(target) or !target:IsPlayer() or target:GTeam() == TEAM_SPEC then
					ply:RXSENDNotify("Для начала смотрите на цель!")
					ply:SetSpecialCD(CurTime() + 2)
					return
				end
				if ( target:GTeam() != TEAM_CLASSD and target:GetNClass() != ROLES.ROLE_GOCSPY ) or target:GetNClass() == ROLES.ROLE_TOPKEK or target:GetNClass() == ROLES.ROLE_FAT or target:GetUsingCloth() != "" then
					ply:RXSENDNotify("Вы не можете надеть снаряжение на данного игрока!")
					ply:SetSpecialCD(CurTime() + 2)
					return
				end
				if ply:GetPrimaryWeaponAmount() >= ply:GetMaxSlots() then
					ply:RXSENDNotify("Игроку нужно освободить одну ячейку в инвентаре для снаряжения!")
					ply:SetSpecialCD(CurTime() + 2)
					return
				end
				local finishcallback = function()
					ply:SetSpecialMax( ply:GetSpecialMax() - 1 )
					if target:GTeam() != TEAM_GOC then
						target:SetGTeam(TEAM_SCI)
					else
						target:SetUsingCloth("armor_sci")
						target.OldModel = target:GetModel()
						target.OldSkin = target:GetSkin()
						target.OldBodygroups = target:GetBodyGroups()
					end
					if ( target.BoneMergedHackerHat ) then
				
						for _, v in ipairs( target.BoneMergedHackerHat ) do
				
							if ( v && v:IsValid() ) then
				
								v:Remove()
				
							end
				
						end
				
					end
					target:SetModel("models/cultist/humans/sci/scientist.mdl")
					target:ClearBodyGroups()
			 		target:SetBodygroup(0, 2)
			 		target:SetBodygroup(2, 1)
			 		target:SetBodygroup(4, 1)
					target:StripWeapon("hacking_doors")
					target:StripWeapon("item_knife")
					target:Give("weapon_pass_sci")
					target:EmitSound( Sound("nextoren/others/cloth_pickup.wav") )
					target:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 1, 1 )
					target:SetupHands()
					ply:AddToAchievementPoint("comitee", 1)
				end
				ply:BrProgressBar("Выдача снаряжения...", 8, "nextoren/gui/special_abilities/ability_recruiter.png", target, false, finishcallback)
			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_GOCJUG) then

			ply:SetSpecialCD( CurTime() + 75)

			local shield = ents.Create("ent_goc_shield")
			shield:SetOwner(ply)
			shield:Spawn()

		elseif ply:HaveSpecialAb(ROLES.ROLE_UIUSPEC) then

			maxs_uiu_spec = Vector( 8, 10, 5 )

			local trace = {}

			trace.start = ply:GetShootPos()

			trace.endpos = trace.start + ply:GetAimVector() * 165

			trace.filter = ply

			trace.mins = -maxs_uiu_spec

			trace.maxs = maxs_uiu_spec
		
			trace = util.TraceHull( trace )
		
			local target = trace.Entity

			if target:IsValid() && target:GetClass() == "func_button" && !target:IsPlayer() && ply:Alive() && ply:GTeam() == TEAM_USA && ply:Health() > 0 then

				old_target_uiu = target

				if SERVER then
					ply:BrProgressBar("Блокирование двери...", 5, "nextoren/gui/special_abilities/special_fbi_hacker.png")
				end

				timer.Create("Blocking_UIU_Check"..ply:SteamID(), 1, 5, function()
					if ply:GetEyeTrace().Entity != old_target_uiu && ply:Alive() && ply:GTeam() == TEAM_USA && ply:Health() > 0 then
						timer.Remove("Blocking_UIU"..ply:SteamID())
						timer.Remove("Blocking_UIU_Check"..ply:SteamID())
						ply:ConCommand("stopprogress")
					end
				end)

				timer.Create("Blocking_UIU"..ply:SteamID(), 5, 1, function()

					ply:SetSpecialCD( CurTime() + 30)

					target:Fire("Lock")

					timer.Simple(30, function()
						
						target:Fire("Unlock")

					end)

				end)

			end
		elseif ply:HaveSpecialAb(ROLES.ROLE_DZCMD) then

			ply:SetSpecialCD( CurTime() + 90 )
		
			local forward_portal = ply:GetForward()

			forward_portal.z = 0

			local siusiakko12 = ply:EyeAngles()

			siusiakko12.pitch = 0
			
		    siusiakko12.roll = 0

			if SERVER then

				local por = ents.Create( "dz_commander_portal" )

				por:SetOwner( ply )

				por:SetPos( ply:GetPos() + forward_portal * 150 )

				por:SetAngles(siusiakko12 - Angle(0,0,0))

				por:Spawn()

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_CHAOSSPY) then

			ply:SetSpecialCD( CurTime() + 40 )

			if CLIENT then return end

			net.Start("Chaos_SpyAbility")
			net.Send(ply)
		elseif ply:HaveSpecialAb(ROLES.ROLE_Engi) then

			if ply:GetSpecialMax() <= 0 then return end

			if CLIENT then return end
			ply:LagCompensation(true)
			local DASUKADAIMNEEGO = util.TraceLine( {
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * 130,
				filter = ply
			} )
			ply:LagCompensation(false)

			if !DASUKADAIMNEEGO.Hit then
				ply:RXSENDNotify("Туррель должнна быть на земле.")
				ply:SetSpecialCD(CurTime() + 5)
				return
			end

			local tur = ents.Create("ent_engineer_turret")
			tur:SetPos(DASUKADAIMNEEGO.HitPos)
			tur:SetOwner(ply)
			tur:Spawn()
			ply:SetSpecialMax(ply:GetSpecialMax() - 1)

		elseif ply:HaveSpecialAb(ROLES.ROLE_CULTSPEC) then

			ply:SetSpecialCD( CurTime() + 50 )

			net.Start("Cult_SpecialistAbility")
			net.Send(ply)

		elseif ply:HaveSpecialAb(ROLES.ROLE_USACMD) then

			ply:SetSpecialCD( CurTime() + 45 )

			net.Start("fbi_commanderabillity")
			net.Send(ply)

		elseif ply:HaveSpecialAb(ROLES.ROLE_NTFCMD) then

			ply:SetSpecialCD( CurTime() + 2 )

			if CLIENT then
				Choose_Faction()
			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_UIU_KILLER) then

			ply:SetSpecialCD( CurTime() + 40 )

			ply:ScreenFade(SCREENFADE.IN, Color(255,0,0,100), 1, 0.3)

			local saveresist = table.Copy(ply.ScaleDamage)
			local savespeed = ply:GetRunSpeed()

			ply.ScaleDamage = {
				["HITGROUP_HEAD"] = 0.8,
				["HITGROUP_CHEST"] = 0.45,
				["HITGROUP_LEFTARM"] = 0.45,
				["HITGROUP_RIGHTARM"] = 0.45,
				["HITGROUP_STOMACH"] = 0.45,
				["HITGROUP_GEAR"] = 0.45,
				["HITGROUP_LEFTLEG"] = 0.45,
				["HITGROUP_RIGHTLEG"] = 0.45
			}

			ply:SetRunSpeed(ply:GetRunSpeed() + 65)

			timer.Simple(15, function()
				if IsValid(ply) and ply:Health() > 0 and ply:Alive() and ply:HaveSpecialAb(ROLES.ROLE_UIU_KILLER) then
					ply.ScaleDamage = saveresist
					ply:SetRunSpeed(savespeed)
				end
			end)

			ply.ClockerAbilityTime = CurTime() + 15

		elseif ply:HaveSpecialAb(ROLES.ROLE_NTFSPEC) then

			maxs_uiu_spec = Vector( 8, 10, 5 )

			local trace = {}

			trace.start = ply:GetShootPos()

			trace.endpos = trace.start + ply:GetAimVector() * 165

			trace.filter = ply

			trace.mins = -maxs_uiu_spec

			trace.maxs = maxs_uiu_spec
		
			trace = util.TraceHull( trace )
		
			local target = trace.Entity

			if target && target:IsValid() && target:IsPlayer() && target:GTeam() == TEAM_SCP && target:Health() > 0 && target:Alive() then
				ply:SetSpecialCD( CurTime() + 90 )
				target:Freeze(true)
				old_name = target:GetName()
				old_role = target:GetNClass()
				if target:GetModel() == "models/cultist/scp/scp_682.mdl" then
					target:SetForcedAnimation("0_Stun_29", false, false, 6)
				else
					target:SetForcedAnimation("0_SCP_542_lifedrain", false, false, 6)
				end
				timer.Create("UnFreezeNTF_Special"..target:SteamID(), 6, 1, function()
					if target:GetName() != old_name && target:GetNClass() != old_role && target:GTeam() != TEAM_SCP then return end
					target:Freeze(false)
				end)
			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SHIELD) then

			ply:SetSpecialCD( CurTime() + 80 )

if SERVER then
			ply:EmitSound("nextoren/vo/special_sci/shield/shield_"..math.random(1,9)..".mp3")

				local special_shield = ents.Create("special_sphere")

				special_shield:SetOwner(ply)

				special_shield:Spawn()

				special_shield:SetPos(ply:GetPos())


			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SPECIALRESS) then

			ply:SetSpecialCD( CurTime() + 60 )

			if CLIENT then HedwigAbility() end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SPEEED) then

			ply:SetSpecialCD( CurTime() + 57 )

			if SERVER then
				ply:EmitSound("nextoren/vo/special_sci/speed_booster/speed_booster_"..math.random(1,12)..".mp3")

				local special_buff_radius = ents.FindInSphere( ply:GetPos(), 450 )

				for _, tply in pairs(special_buff_radius) do
					if IsValid(tply) and tply:IsPlayer() and tply:GTeam() != TEAM_SPEC and tply:GTeam() != TEAM_SCP then
						tply:SetRunSpeed(tply:GetRunSpeed() + 40)
						tply.Shaky_SPEEDName = tply:GetName()
						timer.Simple(25, function()
							if IsValid(tply) and tply:IsPlayer() and tply:GetName() == tply.Shaky_SPEEDName then tply:SetRunSpeed(tply:GetRunSpeed() - 40) end
						end)
					end
				end

			end


		elseif ply:HaveSpecialAb(ROLES.ROLE_SCI_CLOAKER) then

			ply:SetSpecialCD( CurTime() + 110 )

			if SERVER then
				local special_buff_radius = ents.FindInSphere( ply:GetPos(), 450 )

				for _, tply in pairs(special_buff_radius) do
					if IsValid(tply) and tply:IsPlayer() and tply:GTeam() != TEAM_SPEC and tply:GTeam() != TEAM_SCP then
						local ef = EffectData()
						ef:SetEntity(tply)
						util.Effect("gocabilityeffect", ef)
						BroadcastLua("local ef = EffectData() ef:SetEntity(Entity("..tostring(tply:EntIndex())..")) util.Effect(\"gocabilityeffect\", ef)")
						timer.Simple(0.8, function()
							tply:SetNoDraw(true)
							tply.CommanderAbilityActive = true
							for _, wep in pairs(tply:GetWeapons()) do wep:SetNoDraw(true) end
							timer.Create("Goc_Commander_"..tply:UniqueID(), 20, 1, function()
								if !tply.CommanderAbilityActive then return end
								tply:SetNoDraw(false)
								tply.CommanderAbilityActive = nil
								for _, wep in pairs(ply:GetWeapons()) do wep:SetNoDraw(false) end
							end)
						end)
					end
				end

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SPECIALRES) then

			ply:SetSpecialCD( CurTime() + 45 )

			ply:EmitSound("nextoren/vo/special_sci/medic/medic_"..math.random(1,11)..".mp3")

			for _, target in ipairs(ents.FindInSphere(ply:GetPos(), 250)) do

				if target:IsPlayer() then
					if SERVER then
	
						target:SetHealth( math.Clamp( target:Health() + 40, 0, target:GetMaxHealth() ) )
	
					end		
				end	

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_CULT_PSIH_AKA_EBANUTUY) then

			ply:SetSpecialCD( CurTime() + 205 )

			if SERVER then

				ply:SetHealth(ply:GetMaxHealth())

				ply.ScaleDamage = {
				 	["HITGROUP_HEAD"] = .1,
				 	["HITGROUP_CHEST"] = .1,
				 	["HITGROUP_LEFTARM"] = .1,
				 	["HITGROUP_RIGHTARM"] = .1,
				 	["HITGROUP_STOMACH"] = .1,
				 	["HITGROUP_GEAR"] = .1,
				 	["HITGROUP_LEFTLEG"] = .1,
				 	["HITGROUP_RIGHTLEG"] = .1
				 },

				ply:Boosted( 2, 30 )

				local old_name_psycho = ply:GetName()

				timer.Simple(30, function()
					if ply:GetName() != old_name_psycho or ply:Health() < 0 or !ply:Alive() or ply:GTeam() == TEAM_SPEC then return end
					ply:AddToStatistics("Bravery", 50)
					ply:Kill()
				end)

			end


		elseif ply:HaveSpecialAb(ROLES.ROLE_SPECIALRESSSS) then

			ply:SetSpecialCD( CurTime() + 85 )

			if SERVER then
				local tabslowed = {}
				local special_slow_radius = ents.FindInSphere( ply:GetPos(), 450 )

				ply:EmitSound("nextoren/vo/special_sci/scp_slower/scp_slower_"..math.random(1,14)..".mp3")
				for _, ply in pairs(special_slow_radius) do
					if IsValid(ply) and ply:IsPlayer() and ply:GTeam() == TEAM_SCP then
						local remembername = ply:GetNClass()
						local rememberwalk = ply:GetWalkSpeed()
						local rememberrun = ply:GetRunSpeed()
						ply:SetRunSpeed(ply:GetRunSpeed()*.45)
						ply:SetWalkSpeed(ply:GetWalkSpeed()*.45)
						timer.Create("ply_slower_special_"..ply:SteamID(), 15, 1, function()
							if remembername == ply:GetNClass() then
								ply:SetWalkSpeed(rememberwalk)
								ply:SetRunSpeed(rememberrun)
							end
						end)
					end
				end

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SPECIALRESSS) then

			ply:SetSpecialCD( CurTime() + 65 )

			if SERVER then
				local special_buff_radius = ents.FindInSphere( ply:GetPos(), 450 )

				ply:EmitSound("nextoren/vo/special_sci/buffer_damage/buffer_"..math.random(1,14)..".mp3")

				for _, tply in pairs(special_buff_radius) do
					if IsValid(tply) and tply:IsPlayer() and tply:GTeam() != TEAM_SPEC and tply:GTeam() != TEAM_SCP then
						tply.SCI_SPECIAL_DAMAGE_Active = true
						timer.Simple(25, function()
							if IsValid(tply) and tply:IsPlayer() then tply.SCI_SPECIAL_DAMAGE_Active = nil end
						end)
					end
				end
				
			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_NAZI_OFICER) then

			ply:SetSpecialCD( CurTime() + 120 )

			local special_speed_radius = ents.FindInSphere( ply:GetPos(), 450 )

			for _, v in ipairs( special_speed_radius ) do

				if v:IsPlayer() then
					
					if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC and v:GTeam() == TEAM_NAZI then

			            v:Boosted( 3, math.random( 20, 25 ) )
						v:Boosted( 2, 5 )

					end

				end

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_SPEEED) then

			ply:SetSpecialCD( CurTime() + 100 )

			local special_speed_radius = ents.FindInSphere( ply:GetPos(), 450 )

			for _, v in ipairs( special_speed_radius ) do

				if v:IsPlayer() then
					
					if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then

			            v:Boosted( 2, math.random( 17, 20 ) )

					end

				end

			end

		elseif ply:HaveSpecialAb(ROLES.ROLE_GRUCMD) then

			maxs_uiu_spec = Vector( 8, 10, 5 )

			local trace = {}

			trace.start = ply:GetShootPos()

			trace.endpos = trace.start + ply:GetAimVector() * 165

			trace.filter = ply

			trace.mins = -maxs_uiu_spec

			trace.maxs = maxs_uiu_spec
		
			trace = util.TraceHull( trace )
		
			local target = trace.Entity

			if target:IsValid() && target:IsPlayer() && ply:Alive() && ply:GTeam() == TEAM_GRU && target:GTeam() != TEAM_SPEC && target:GTeam() != TEAM_SCP && ply:Health() > 0 then

				old_target = target

				if SERVER then
					ply:BrProgressBar("Идёт допрос цели...", 5, "nextoren/gui/special_abilities/special_gru_commander.png")
				end

				timer.Create("GRU_Com_Check"..ply:SteamID(), 1, 5, function()
					if ply:GetEyeTrace().Entity != old_target && ply:Alive() && ply:GTeam() == TEAM_GRU && ply:Health() > 0 then
						timer.Remove("GRU_Com"..ply:SteamID())
						timer.Remove("GRU_Com_Check"..ply:SteamID())
						ply:ConCommand("stopprogress")
					end
				end)

				timer.Create("GRU_Com"..ply:SteamID(), 5, 1, function()

					ply:SetSpecialCD( CurTime() + 50)

					if SERVER then
					    target:AddToStatistics("Interrogation by GRU", -40)
					end

					local players = player.GetAll()

					for i = 1, #players do

						local player = players[i]

						if player:GTeam() == TEAM_GRU then

							if !GRU_Members then

								GRU_Members = {}

							end

							GRU_Members[#GRU_Members + 1] = player

						end

					end

					net.Start("GRU_CommanderAbility")
					    net.WriteString(target:GTeam())
					net.Send(ply)

				end)

			end

		end

	end

end)

function GM:PlayerButtonDown( ply, button )

	if CLIENT and IsFirstTimePredicted() then
		//local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) or "q" ) ] or 
		local key = input.LookupBinding( "+menu" )

		if ( button == KEY_Q ) then

			if ( CanShowEQ() && !IsEQVisible() ) then

				ShowEQ( true )

			elseif ( IsEQVisible() ) then

				HideEQ()

			end
	

		end
	end
	
end

function GM:PlayerButtonUp( ply, button )
	if CLIENT and IsFirstTimePredicted() then
		//local bind = _G[ "KEY_"..string.upper( input.LookupBinding( "+menu" ) ) ] or KEY_Q
		local key = input.LookupBinding( "+menu" )

		if key then
			if input.GetKeyCode( KEY_Q ) == button and IsEQVisible() then
				HideEQ()
			end
		end
	end
end

function mply:HasHazmat()

  if ( string.find( string.lower( self:GetModel() ), "hazmat" ) ) then

    return true

  end

  return false

end

------ Конец Инвентаря

function mply:Dado( kind )

	if ( kind == 1 ) then

		local unique_id = "Radiation" .. self:SteamID64()
        local old_name = self:GetName()

		self.radiation = true

        timer.Create( unique_id, .25, 0, function()

            if ( !( self && self:IsValid() ) || self:GetName() != old_name || self:GTeam() == TEAM_SPEC || self:Health() <= 0 ) then

                timer.Remove( unique_id )

                return
            end

			if ( ( self.NextParticle || 0 ) < CurTime() ) then

				self.NextParticle = CurTime() + 3
				ParticleEffect( "rgun1_impact_pap_child", self:GetPos(), angle_zero, self )

			end

            for _, v in ipairs( ents.FindInSphere( self:GetPos(), 400 ) ) do

            if ( v:IsPlayer() && v:GTeam() != TEAM_SPEC && v:Health() > 0 ) then

					if ( v:HasHazmat() && v != self ) then return end

					local radiation_info = DamageInfo()
					radiation_info:SetDamageType( DMG_RADIATION )
					radiation_info:SetDamage( 2 )
					radiation_info:SetAttacker( self )
                    radiation_info:SetDamageForce( v:GetAimVector() * 4 )

					if ( v == self ) then

						radiation_info:ScaleDamage( .5 )

					else

						radiation_info:ScaleDamage( 1 * ( 1600 / self:GetPos():DistToSqr( v:GetPos() ) ) )

					end

                    v:TakeDamageInfo( radiation_info )

                end

            end

        end )

	elseif ( kind == 2 ) then

		local unique_id = "FireBlow" .. self:SteamID64()
		local old_name = self:GetName()

		self.abouttoexplode = true

		timer.Create( unique_id, 10, 1, function()

			if ( !( self && self:IsValid() ) || self:GetName() != old_name || self:GTeam() == TEAM_SPEC || self:Health() <= 0 ) then

				timer.Remove( unique_id )

				return
			end

			if ( SERVER ) then

				local current_pos = self:GetPos()

				self.abouttoexplode = nil

				self.burnttodeath = true

				local dmg_info = DamageInfo()
				dmg_info:SetDamage( 2000 )
				dmg_info:SetDamageType( DMG_BLAST )
				dmg_info:SetAttacker( self )
				dmg_info:SetDamageForce( -self:GetAimVector() * 40 )

				util.BlastDamageInfo( dmg_info, self:GetPos(), 400 )

				sound.Play("nextoren/others/explosion_ambient_" .. math.random( 1, 2 ) .. ".ogg", current_pos, 100, 100, 100)

				local trigger_ent = ents.Create( "base_gmodentity" )
				trigger_ent:SetPos( current_pos )
				trigger_ent:SetNoDraw( true )
				trigger_ent:DrawShadow( false )
				trigger_ent:Spawn()
				trigger_ent.Die = CurTime() + 50

				net.Start( "CreateParticleAtPos" )

					net.WriteString( "pillardust" )
					net.WriteVector( current_pos )

				net.Broadcast()

				net.Start( "CreateParticleAtPos" )

					net.WriteString( "gas_explosion_main" )
					net.WriteVector( current_pos )

				net.Broadcast()

				trigger_ent.OnRemove = function( self )

					self:StopParticles()

				end
				trigger_ent.Think = function( self )

					self:NextThink( CurTime() + .25 )

					if ( self.Die < CurTime() ) then

						self:Remove()

					end

					for _, v in ipairs( ents.FindInSphere( self:GetPos(), 300 ) ) do

						if ( v:IsPlayer() && v:GTeam() != TEAM_SPEC && ( v:GTeam() != TEAM_SCP || !v:GetNoDraw() ) ) then
							
							v:Ignite(4)

						end

					end

				end

			end

		end )

	end

end

function mply:Boosted( kind, timetodie )

	if ( kind == 1 ) then

		if ( self:GetEnergized() ) then

			local current_name = self:GetName()

			net.Start( "ForcePlaySound" )

				net.WriteString( "nextoren/others/heartbeat_stop.ogg" )

			net.Send( self )

			timer.Simple( 15, function()

				if ( self && self:IsValid() && self:Health() > 0 && self:GetName() == current_name && self:GTeam() != TEAM_SPEC ) then

					self:Kill()

				end

			end )

			return
		end

		self:SetEnergized( true )

		timer.Simple( ( timetodie || 10 ), function()

			if ( self && self:IsValid() && self:Health() > 0 ) then

				self:SetEnergized( false )

			end

		end )

	elseif ( kind == 2 ) then

		if ( self:GetBoosted() ) then return end

		self:SetBoosted( true )

		self:SetWalkSpeed( self:GetWalkSpeed() * 1.3 )
		self:SetRunSpeed( self:GetRunSpeed() * 1.3 )

		self:SetStaminaScale( self:GetStaminaScale() * .7 )

		timer.Simple( ( timetodie || 10 ), function()

			if ( self && self:IsValid() && self:Alive() ) then

				self:SetBoosted( false )

				self:SetWalkSpeed( self:GetWalkSpeed() * .7 )
				self:SetRunSpeed( self:GetRunSpeed() * .7 )

				self:SetStaminaScale( self:GetStaminaScale() * 1.3 )

			end

		end )

	elseif ( kind == 3 ) then

		if ( !SERVER ) then return end

		local randomhealth = math.random( 60, 80 )

		self.old_maxhealth = self.old_maxhealth || self:GetMaxHealth()

		local old_name = self:GetName()

		self:SetHealth( self:Health() + randomhealth )
		self:SetMaxHealth( self:GetMaxHealth() + randomhealth )

		local unique_id = "ReduceHealthByPills" .. self:SteamID64()

		timer.Create( unique_id, 1, self:GetMaxHealth() - self.old_maxhealth, function()

			if ( !( self && self:IsValid() ) ) then timer.Remove( unique_id ) return end

			if ( self:Health() < 2 || !self:Alive() || self:GTeam() == TEAM_SPEC || self:GTeam() == TEAM_SCP || self:GetMaxHealth() == old_maxhealth || self:GetName() != old_name ) then

				self:SetMaxHealth( self.old_maxhealth )
				self.old_maxhealth = nil
				timer.Remove( unique_id )

				return
			end

			self:SetHealth( self:Health() - 1 )
			self:SetMaxHealth( self:GetMaxHealth() - 1 )

			if ( self:GetMaxHealth() == self.old_maxhealth ) then

				self.old_maxhealth = nil

			end

		end )

	elseif ( kind == 4 ) then

		self:SetAdrenaline( true )

		timer.Simple( ( timetodie || 10 ), function()

			if ( self && self:IsValid() ) then

				self:SetAdrenaline( false )

			end

		end )

	elseif ( kind == 5 ) then

		self.WaterDr = true

		timer.Simple( ( timetodie || 10 ), function()

			if ( self && self:IsValid() ) then

				self.WaterDr = false

			end

		end )

	end

end

function mply:GetExp()
	if not self.GetNEXP then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNEXP and self.SetNEXP then
		return self:GetNEXP()
	else
		ErrorNoHalt( "Cannot get the exp, GetNEXP invalid" )
		return 0
	end
end

function mply:GetLevel()
	if not self.GetNLevel then
		player_manager.RunClass( self, "SetupDataTables" )
	end
	if self.GetNLevel and self.SetNLevel then
		return self:GetNLevel()
	else
		ErrorNoHalt( "Cannot get the exp, GetNLevel invalid" )
		return 0
	end
end

if SERVER then

	util.AddNetworkString("SetStamina")

	function mply:SetStamina(float)
		net.Start("SetStamina")
		net.WriteFloat(float)
		net.WriteBool(false)
		net.Send(self)
	end

	function mply:AddStamina(float)
		net.Start("SetStamina")
		net.WriteFloat(float)
		net.WriteBool(true)
		net.Send(self)
	end

end

net.Receive("SetStamina", function()

	local stamina = net.ReadFloat()
	local add = net.ReadBool()

	if !add then
		LocalPlayer().Stamina = stamina
	else
		if LocalPlayer().Stamina == nil then LocalPlayer().Stamina = 100 end
		LocalPlayer().Stamina = LocalPlayer().Stamina + stamina
	end

end)

local cd_stamina = 0
if CLIENT then
	concommand.Add("test111", function()
		LocalPlayer().Stamina = 10
	end)
	hook.Add("KeyPress", "Stamina_drain", function(ply, press)

		if press == IN_JUMP and ply.Stamina then
			if !ply:GetEnergized() and !ply:GetAdrenaline() then
				ply.Stamina = ply.Stamina - 6
			end
		end

	end)
end
function Sprint( ply, mv )

	if ply:GTeam() == TEAM_SPEC then
		ply.Stamina = nil
		ply.exhausted = nil
		return
	end

	local pl = ply:GetTable()
	local n_new = ply:GetStaminaScale()
	local stamina = pl.Stamina
	local maxstamina = n_new*100
	local movetype = ply:GetMoveType()
	local invehicle = ply:InVehicle()
	local energized = ply:GetEnergized()
	local boosted = ply:GetBoosted()
	local adrenaline = ply:GetAdrenaline()
	local plyteam = ply:GTeam()
	local activeweapon = ply:GetActiveWeapon()
	if stamina == nil then pl.Stamina = maxstamina end
	stamina = pl.Stamina

	if stamina > maxstamina then stamina = maxstamina end

	if pl.exhausted then
		if exhausted_cd <= CurTime() then
			pl.exhausted = nil
		end
		--return
	end

	local isrunning = false

	if IsValid(activeweapon) and activeweapon.HoldingBreath then
		stamina = stamina - 0.025
	end

	if !adrenaline then
		if mv:KeyDown(IN_SPEED) and !( ply:GetVelocity():Length2DSqr() < 0.25 or movetype == MOVETYPE_NOCLIP or movetype == MOVETYPE_LADDER or movetype == MOVETYPE_OBSERVER or invehicle ) and plyteam != TEAM_SCP and !pl.exhausted then
			if !energized then stamina = stamina - 0.0115 end
			cd_stamina = CurTime() + 1.5
			isrunning = true
		end
	end
	if !isrunning and !ply:GetPos():WithinAABox(Vector(-4120.291504, -11427.226563, 38.683075), Vector(1126.214844, -15695.861328, -3422.429688)) then
		if cd_stamina <= CurTime() then
			local add = FrameTime()
			if energized then
				add = add *2
			end
			if stamina < 0 then stamina = 0 end
			stamina = math.Approach(stamina, maxstamina, add)
		end
	end

	if stamina < 0 and !pl.exhausted and !boosted then
		make_bottom_message("I need to catch my breath")
		net.Start("catch_breath")
		net.SendToServer()
		pl.exhausted = true
		exhausted_cd = CurTime() + 7
	end


	pl.Stamina = stamina

end

hook.Add("SetupMove", "stamina_new", function(ply, mv)
	if CLIENT then Sprint(ply, mv) end
end)

hook.Add("CreateMove", "stamina_new", function(mv)
	local ply = LocalPlayer()
	local pl = ply:GetTable()
	if ( pl.exhausted and !pl:GetBoosted() ) then
		if mv:KeyDown(IN_SPEED) then
			mv:SetButtons(mv:GetButtons() - IN_SPEED)
		end
		if mv:KeyDown(IN_JUMP) then
			mv:SetButtons(mv:GetButtons() - IN_JUMP)
		end
	end
end)

if CLIENT then
	function mply:DropWeapon( class )
		net.Start( "DropWeapon" )
			net.WriteString( class )
		net.SendToServer()
	end

	function mply:SelectWeapon( class )
		if ( !self:HasWeapon( class ) ) then return end
		self.DoWeaponSwitch = self:GetWeapon( class )
	end
	
	hook.Add( "CreateMove", "WeaponSwitch", function( cmd )
		if !IsValid( LocalPlayer().DoWeaponSwitch ) then return end

		cmd:SelectWeapon( LocalPlayer().DoWeaponSwitch )

		if LocalPlayer():GetActiveWeapon() == LocalPlayer().DoWeaponSwitch then
			LocalPlayer().DoWeaponSwitch = nil
		end
	end )
end

local box_parameters = Vector( 5, 5, 5 )

net.Receive( "ThirdPersonCutscene", function()

	local time = net.ReadUInt( 4 )
  
	local client = LocalPlayer()
  
	client.ExitFromCutscene = nil
  
	local multiplier = 0
  
	hook.Add( "CalcView", "ThirdPerson", function( client, pos, angles, fov )
  
	  if ( !client.ExitFromCutscene && multiplier != 1 ) then
  
		multiplier = math.Approach( multiplier, 1, RealFrameTime() * 2 )
  
	  elseif ( client.ExitFromCutscene ) then
  
		multiplier = math.Approach( multiplier, 0, RealFrameTime() * 2 )
  
		if ( multiplier < .25 ) then
  
		  hook.Remove( "CalcView", "ThirdPerson" )
		  client.ExitFromCutscene = nil
  
		end
  
	  end
  
	  local offset_eyes = client:LookupAttachment( "eyes" )
	  offset_eyes = client:GetAttachment( offset_eyes )
  
	  if ( offset_eyes ) then
  
		angles = offset_eyes.Ang
  
	  end
  
	  local trace = {}
	  trace.start = offset_eyes && offset_eyes.Pos || pos
	  trace.endpos = trace.start + angles:Forward() * ( -80 * multiplier )
	  trace.filter = client
	  trace.mins = -box_parameters
	  trace.maxs = box_parameters
	  trace.mask = MASK_VISIBLE
  
	  trace = util.TraceLine( trace )
  
	  pos = trace.HitPos
  
	  if ( trace.Hit ) then
  
		pos = pos + trace.HitNormal * 5
  
	  end
  
	  local view = {}
	  view.origin = pos
	  view.angles = angles
	  view.fov = fov
	  view.drawviewer = true
  
	  return view
  
	end )
  
	timer.Simple( time, function()
  
	  client.ExitFromCutscene = true
  
	end )
  
end )

function BreachUtilEffect(effectname, effectdata)
	net.Start("Shaky_UTILEFFECTSYNC")
	net.WriteString(effectname)
	net.WriteTable({effectdata})
	net.Broadcast()
end
function BreachParticleEffect(ParticleName, Position, angles, EntityParent)
	if EntityParent == nil then EntityParent = NULL end
	ParticleEffect(ParticleName, Position, angles, EntityParent)
	net.Start("Shaky_PARTICLESYNC")
	net.WriteString(ParticleName)
	net.WriteVector(Position)
	net.WriteAngle(angles)
	net.WriteEntity(EntityParent)
	net.Broadcast()
end
function BreachParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
	if EntityParent == nil then EntityParent = NULL end
	ParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
	net.Start("Shaky_PARTICLEATTACHSYNC")
	net.WriteString(ParticleName)
	net.WriteUInt(attachtype, 4)
	net.WriteEntity(entity)
	net.WriteUInt(attachmentID, 20)
	net.Broadcast()
end
if CLIENT then
	net.Receive("Shaky_PARTICLESYNC", function(len)
		local ParticleName = net.ReadString()
		local Position = net.ReadVector()
		local angles = net.ReadAngle()
		local EntityParent = net.ReadEntity()
		ParticleEffect(ParticleName, Position, angles, EntityParent)
	end)
	net.Receive("Shaky_UTILEFFECTSYNC", function(len)
		local ParticleName = net.ReadString()
		local EfData = net.ReadTable()[1] || EffectData()
		util.Effect(effectname, EfData)
	end)
	net.Receive("Shaky_PARTICLEATTACHSYNC", function(len)
		local ParticleName = net.ReadString()
		local attachtype = net.ReadUInt(4)
		local entity = net.ReadEntity()
		local attachmentID = net.ReadUInt(20)
		ParticleEffectAttach(ParticleName, attachType, entity, attachmentID)
	end)
end
function mply:WouldDieFrom( damage, hitpos )

	return self:Health() <= damage

end

function mply:ThrowFromPositionSetZ( pos, force, zmul, noknockdown )

	if ( force == 0 || self.NoThrowFromPosition ) then return false end

	zmul = zmul || .7

	if ( self:IsPlayer() ) then

		force = force * ( self.KnockbackScale || 1 )

	end

	if ( self:GetMoveType() == MOVETYPE_VPHYSICS ) then

		local phys = self:GetPhysicsObject()

		if ( phys:IsValid() && phys:IsMoveable() ) then

			local nearest = self:NearestPoint( pos )
			local dir = nearest - pos
			dir.z = 0
			dir:Normalize()
			dir.z = zmul
			phys:ApplyForceOffset( force * 50 * dir, nearest )

		end

		return true

	elseif ( self:GetMoveType() >= MOVETYPE_WALK && self:GetMoveType() < MOVETYPE_PUSH ) then

		self:SetGroundEntity( NULL )

		local dir = self:LocalToWorld( self:OBBCenter() )
		dir.z = 0
		dir:Normalize()
		dir.z = zmul
		self:SetVelocity( force * dir )

		return true

	end

end

function mply:MeleeViewPunch( damage )

	local maxpunch = ( damage + 25 ) * 0.5
	local minpunch = -maxpunch
	self:ViewPunch( Angle( math.Rand( minpunch, maxpunch ), math.Rand( minpunch, maxpunch ), math.Rand( minpunch, maxpunch ) ) )

end
