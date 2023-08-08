--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dmodelpanel.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 46.174.48.132_27015 ~ 
~ file: lua/vgui/dmodelpanel.lua ~

]]


local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",			"Entity" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )

local light_clr = Color( 50, 50, 50 )

function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( light_clr )

	self:SetDirectionalLight( BOX_TOP, color_white )
	self:SetDirectionalLight( BOX_FRONT, color_white )

	self:SetColor( color_white )

end

function PANEL:SetDirectionalLight( iDirection, color )

	self.DirectionalLight[ iDirection ] = color

end

local sub_material_corrupted_models = {

	[ "models/cultist/heads/male/male_head_2.mdl" ] = true,
	[ "models/cultist/heads/male/male_head_3.mdl" ] = true,
	[ "models/cultist/heads/male/male_head_6.mdl" ] = true

}

local function BoneMerge( entity, model, no_draw, skin )

	local bnmrg = ents.CreateClientside( "ent_bonemerged" )

	entity.bonemerge_ent = bnmrg

	entity.bonemerge_ent:SetModel( model )
	entity.bonemerge_ent:SetSkin( entity:GetSkin() )

	entity.bonemerge_ent:Spawn()

	entity.bonemerge_ent:SetParent( entity, 0 )

	entity.bonemerge_ent:SetLocalPos( vector_origin )
	entity.bonemerge_ent:SetLocalAngles( angle_zero )

	entity.bonemerge_ent:AddEffects( EF_BONEMERGE )
	entity.bonemerge_ent:AddEffects( EF_NOSHADOW )
	entity.bonemerge_ent:AddEffects( EF_NORECEIVESHADOW )

	if ( skin ) then

		entity.bonemerge_ent:SetSkin( skin )

	end

	if ( !entity.BoneMergedEnts ) then

		entity.BoneMergedEnts = {}

	end

	if ( no_draw ) then

		entity.no_draw = true

	end

	if ( model:find( "/heads/" ) && !model:find( "hair" ) ) or model:find("balaclava") then

		entity.HeadEnt = entity.bonemerge_ent

		if ( entity.Sub_Material ) then

			local sub_material_id = 0

			if ( sub_material_corrupted_models[ model ] ) then

				sub_material_id = 1

			end

			entity.bonemerge_ent:SetSubMaterial( sub_material_id, entity.Sub_Material )

		end

	end

	if ( no_draw ) then

		entity.bonemerge_ent.no_draw = no_draw

	end

	entity.BoneMergedEnts[ #entity.BoneMergedEnts + 1 ] = entity.bonemerge_ent

	return bnmrg

end

function PANEL:BoneMerged( tbl, sub_material, no_draw, skin )

	local ent = self.Entity

	if ( sub_material ) then

		self.Entity.Sub_Material = sub_material

	end

	if ( !istable( tbl ) ) then

		return BoneMerge( ent, tbl, no_draw, skin )

	end

	for _, v in pairs( tbl ) do

		if ( istable( v ) ) then

			for _, additional in pairs( v ) do

				return BoneMerge( ent, additional, no_draw, skin )

			end

		else

			if ( isentity( v ) ) then

				if ( v && v:IsValid() ) then

					return BoneMerge( ent, v:GetModel(), v:GetInvisible(), v:GetSkin() )

				end

			else

				return BoneMerge( ent, v, no_draw, skin )

			end

		end

	end

end

function PANEL:SetModel( strModelName )

	-- Note - there's no real need to delete the old
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then

		self.Entity:Remove()
		self.Entity = nil

	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

	self.Entity = ClientsideModel( strModelName, RENDERGROUP_OTHER )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )
	self.Entity:SetIK( false )

	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end

end

function PANEL:GetModel()

	if ( !IsValid( self.Entity ) ) then return end

	return self.Entity:GetModel()

end

function PANEL:DrawModel()

	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModel( self.Entity )

	if ( ret != false ) then
		self.Entity:DrawModel()

		if ( self.Entity.bonemerge_ent ) then

			for _, v in ipairs( self.Entity.BoneMergedEnts ) do

				if ( v && v:IsValid() && !v.no_draw ) then

					v:DrawModel()

				end

				if ( !( v && v:IsValid() ) ) then

					table.RemoveByValue( self.Entity.BoneMergedEnts, v )

				end

			end

		end

		self:PostDrawModel( self.Entity )
	end

	render.SetScissorRect( 0, 0, 0, 0, false )

end

function PANEL:PreDrawModel( ent )
	return true
end

function PANEL:PostDrawModel( ent )

end

function PANEL:Paint( w, h )

	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end

	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) ) -- * surface.GetAlphaMultiplier()

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()

	self.LastPaint = RealTime()

end

function PANEL:MakeZombie()
	for i, material in pairs(self.Entity:GetMaterials()) do
		i = i -1
		if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
			if string.StartWith(material, "models/all_scp_models/") then
				local str = string.sub(material, #"models/all_scp_models//")
				str = "models/all_scp_models/zombies/"..str
				self.Entity:SetSubMaterial(i, str)
			end
		else
			self.Entity:SetSubMaterial(i, "!ZombieTexture")
		end
	end
	if !self.Entity.BoneMergedEnts then return end
	for _, bnmrg in pairs(self.Entity.BoneMergedEnts) do
		if !IsValid(bnmrg) then continue end
		if bnmrg:GetModel():find("male_head_") or bnmrg:GetModel():find("balaclava") then
			self.Entity.FaceTexture = "models/all_scp_models/zombies/shared/heads/head_1_1"
			if CORRUPTED_HEADS[bnmrg:GetModel()] then
				bnmrg:SetSubMaterial(1, self.Entity.FaceTexture)
			else
				bnmrg:SetSubMaterial(0, self.Entity.FaceTexture)
			end
		else
			for i, material in pairs(bnmrg:GetMaterials()) do
				i = i -1
				if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
					if string.StartWith(material, "models/all_scp_models/") then
						local str = string.sub(material, #"models/all_scp_models//")
						str = "models/all_scp_models/zombies/"..str
						bnmrg:SetSubMaterial(i, str)
					end
				else
					bnmrg:SetSubMaterial(i, "!ZombieTexture")
				end
			end
		end
	end
end

function PANEL:RunAnimation()

	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )

end

function PANEL:StartScene( name )

	if ( IsValid( self.Scene ) ) then

		self.Scene:Remove()

	end

	self.Scene = ClientsideScene( name, self.Entity )

end

function PANEL:LayoutEntity( Entity )

	--
	-- This function is to be overriden
	--

	if ( self.bAnimated ) then

		self:RunAnimation()

	end

	Entity:SetAngles( Angle( 0, RealTime() * 10 % 360, 0 ) )

end

function PANEL:OnRemove()

	if ( IsValid( self.Entity ) ) then

		local ent = self.Entity

		if ( ent.BoneMergedEnts ) then

			for _, v in ipairs( ent.BoneMergedEnts ) do

				if ( v && v:IsValid() ) then

					v:Remove()

				end

			end

		end

		ent:Remove()

	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	ctrl:GetEntity():SetSkin( 2 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DModelPanel", "A panel containing a model", PANEL, "DButton" )
