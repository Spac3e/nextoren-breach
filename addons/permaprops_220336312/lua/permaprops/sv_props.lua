/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

if not PermaProps then PermaProps = {} end

PermaProps.SpecialENTSSpawn = {}
PermaProps.SpecialENTSSpawn["gmod_lamp"] = function( ent, data)

	ent:SetFlashlightTexture( data["Texture"] )
	ent:SetLightFOV( data["fov"] )
	ent:SetColor( Color( data["r"], data["g"], data["b"], 255 ) )
	ent:SetDistance( data["distance"] )
	ent:SetBrightness( data["brightness"] )
	ent:Switch( true )

	ent:Spawn()

	ent.Texture = data["Texture"]
	ent.KeyDown = data["KeyDown"]
	ent.fov = data["fov"]
	ent.distance = data["distance"]
	ent.r = data["r"]
	ent.g = data["g"]
	ent.b = data["b"]
	ent.brightness = data["brightness"]

	return true

end

PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"] = function( ent, data)

	if ( ent:GetModel() == "models/buggy.mdl" ) then ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jeep_test.txt" ) end
	if ( ent:GetModel() == "models/vehicle.mdl" ) then ent:SetKeyValue( "vehiclescript", "scripts/vehicles/jalopy.txt" ) end

	if ( data["VehicleTable"] && data["VehicleTable"].KeyValues ) then
		for k, v in pairs( data["VehicleTable"].KeyValues ) do
			ent:SetKeyValue( k, v )
		end
	end

	ent:Spawn()
	ent:Activate()

	ent:SetVehicleClass( data["VehicleName"] )
	ent.VehicleName = data["VehicleName"]
	ent.VehicleTable = data["VehicleTable"]
	ent.ClassOverride = data["Class"]

	return true

end
PermaProps.SpecialENTSSpawn["prop_vehicle_jeep_old"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]
PermaProps.SpecialENTSSpawn["prop_vehicle_airboat"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]
PermaProps.SpecialENTSSpawn["prop_vehicle_prisoner_pod"] = PermaProps.SpecialENTSSpawn["prop_vehicle_jeep"]

PermaProps.SpecialENTSSpawn["prop_ragdoll"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()
	
	if data["Bones"] then

		for objectid, objectdata in pairs( data["Bones"] ) do

			local Phys = ent:GetPhysicsObjectNum( objectid )
			if !IsValid( Phys ) then continue end
		
			if ( isvector( objectdata.Pos ) && isangle( objectdata.Angle ) ) then

				local pos, ang = LocalToWorld( objectdata.Pos, objectdata.Angle, Vector(0, 0, 0), Angle(0, 0, 0) )
				Phys:SetPos( pos )
				Phys:SetAngles( ang )
				Phys:Wake()

				if objectdata.Frozen then
					Phys:EnableMotion( false )
				end

			end
		
		end

	end

	if data["BoneManip"] and ent:IsValid() then

		for k, v in pairs( data["BoneManip"] ) do

			if ( v.s ) then ent:ManipulateBoneScale( k, v.s ) end
			if ( v.a ) then ent:ManipulateBoneAngles( k, v.a ) end
			if ( v.p ) then ent:ManipulateBonePosition( k, v.p ) end

		end

	end

	if data["Flex"] and ent:IsValid() then

		for k, v in pairs( data["Flex"] ) do
			ent:SetFlexWeight( k, v )
		end

		if ( Scale ) then
			ent:SetFlexScale( Scale )
		end

	end

	return true

end

PermaProps.SpecialENTSSpawn["sammyservers_textscreen"] = function( ent, data )

	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()
	
	if data["Lines"] then

		for k, v in pairs(data["Lines"] or {}) do

			ent:SetLine(k, v.text, Color(v.color.r, v.color.g, v.color.b, v.color.a), v.size, v.font, v.rainbow or 0)

		end

	end

	return true

end

PermaProps.SpecialENTSSpawn["NPC"] = function( ent, data )

	if data and istable( data ) then

		if data["Equipment"] then

			local valid = false
			for _, v in pairs( list.Get( "NPCUsableWeapons" ) ) do
				if v.class == data["Equipment"] then valid = true break end
			end

			if ( data["Equipment"] && data["Equipment"] != "none" && valid ) then
				ent:SetKeyValue( "additionalequipment", data["Equipment"] )
				ent.Equipment = data["Equipment"] 
			end

		end

	end

	ent:Spawn()
	ent:Activate()

	return true

end

if list.Get( "NPC" ) and istable(list.Get( "NPC" )) then

	for k, v in pairs(list.Get( "NPC" )) do
		
		PermaProps.SpecialENTSSpawn[k] = PermaProps.SpecialENTSSpawn["NPC"]

	end

end

PermaProps.SpecialENTSSpawn["item_ammo_crate"] = function( ent, data )

	if data and istable(data) and data["type"] then

		ent.type = data["type"]
		ent:SetKeyValue( "AmmoType", math.Clamp( data["type"], 0, 9 ) )

	end

	ent:Spawn()
	ent:Activate()
	
	return true

end


PermaProps.SpecialENTSSave = {}
PermaProps.SpecialENTSSave["gmod_lamp"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["Texture"] = ent.Texture
	content.Other["KeyDown"] = ent.KeyDown
	content.Other["fov"] = ent.fov
	content.Other["distance"] = ent.distance
	content.Other["r"] = ent.r
	content.Other["g"] = ent.g
	content.Other["b"] = ent.b
	content.Other["brightness"] = ent.brightness

	return content

end

PermaProps.SpecialENTSSave["prop_vehicle_jeep"] = function( ent )

	if not ent.VehicleTable then return false end

	local content = {}
	content.Other = {}
	content.Other["VehicleName"] = ent.VehicleName
	content.Other["VehicleTable"] = ent.VehicleTable
	content.Other["ClassOverride"] = ent.ClassOverride

	return content

end
PermaProps.SpecialENTSSave["prop_vehicle_jeep_old"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]
PermaProps.SpecialENTSSave["prop_vehicle_airboat"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]
PermaProps.SpecialENTSSave["prop_vehicle_prisoner_pod"] = PermaProps.SpecialENTSSave["prop_vehicle_jeep"]

PermaProps.SpecialENTSSave["prop_ragdoll"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["Bones"] = {}

	local num = ent:GetPhysicsObjectCount()
	for objectid = 0, num - 1 do

		local obj = ent:GetPhysicsObjectNum( objectid )
		if ( !obj:IsValid() ) then continue end

		content.Other["Bones"][ objectid ] = {}

		content.Other["Bones"][ objectid ].Pos = obj:GetPos()
		content.Other["Bones"][ objectid ].Angle = obj:GetAngles()
		content.Other["Bones"][ objectid ].Frozen = !obj:IsMoveable()
		if ( obj:IsAsleep() ) then content.Other["Bones"][ objectid ].Sleep = true end

		content.Other["Bones"][ objectid ].Pos, content.Other["Bones"][ objectid ].Angle = WorldToLocal( content.Other["Bones"][ objectid ].Pos, content.Other["Bones"][ objectid ].Angle, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )

	end

	if ( ent:HasBoneManipulations() ) then
	
		content.Other["BoneManip"] = {}

		for i = 0, ent:GetBoneCount() do
	
			local t = {}
		
			local s = ent:GetManipulateBoneScale( i )
			local a = ent:GetManipulateBoneAngles( i )
			local p = ent:GetManipulateBonePosition( i )
		
			if ( s != Vector( 1, 1, 1 ) ) then t[ 's' ] = s end -- scale
			if ( a != Angle( 0, 0, 0 ) ) then t[ 'a' ] = a end -- angle
			if ( p != Vector( 0, 0, 0 ) ) then t[ 'p' ] = p end -- position
	
			if ( table.Count( t ) > 0 ) then
				content.Other["BoneManip"][ i ] = t
			end
	
		end

	end

	content.Other["FlexScale"] = ent:GetFlexScale()
	for i = 0, ent:GetFlexNum() do

		local w = ent:GetFlexWeight( i )
		if ( w != 0 ) then
			content.Other["Flex"] = content.Other["Flex"] or {}
			content.Other["Flex"][ i ] = w
		end

	end

	return content

end

PermaProps.SpecialENTSSave["sammyservers_textscreen"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["Lines"] = ent.lines or {}

	return content

end

PermaProps.SpecialENTSSave["prop_effect"] = function( ent )

	local content = {}
	content.Class = "pp_prop_effect"
	content.Model = ent.AttachedEntity:GetModel()

	return content

end
PermaProps.SpecialENTSSave["pp_prop_effect"] = PermaProps.SpecialENTSSave["prop_effect"]

PermaProps.SpecialENTSSave["NPC"] = function( ent )

	if !ent.Equipment then return {} end

	local content = {}
	content.Other = {}
	content.Other["Equipment"] = ent.Equipment

	return content

end

if list.Get( "NPC" ) and istable(list.Get( "NPC" )) then

	for k, v in pairs(list.Get( "NPC" )) do
		
		PermaProps.SpecialENTSSave[k] = PermaProps.SpecialENTSSave["NPC"]

	end

end

PermaProps.SpecialENTSSave["item_ammo_crate"] = function( ent )

	local content = {}
	content.Other = {}
	content.Other["type"] = ent.type

	return content

end

sql.Query("CREATE TABLE IF NOT EXISTS permaprops('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'content' TEXT NOT NULL, PRIMARY KEY('id'));")

if not PermaProps then PermaProps = {} end

PermaProps.SQL = {}

function PermaProps.SQL.Query( data )

	return sql.Query( data )

end

/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
						Thanks to ARitz Cracker for this part
*/

function PermaProps.HasPermission( ply, name )

	if !PermaProps or !PermaProps.Permissions or !PermaProps.Permissions[ply:GetUserGroup()] then return false end

	if PermaProps.Permissions[ply:GetUserGroup()].Custom == false and PermaProps.Permissions[ply:GetUserGroup()].Inherits and PermaProps.Permissions[PermaProps.Permissions[ply:GetUserGroup()].Inherits] then

		return PermaProps.Permissions[PermaProps.Permissions[ply:GetUserGroup()].Inherits][name]

	end

	return PermaProps.Permissions[ply:GetUserGroup()][name]

end

local function PermaPropsPhys( ply, ent, phys )

	if ent.PermaProps then

		return PermaProps.HasPermission( ply, "Physgun")

	end
	
end
hook.Add("PhysgunPickup", "PermaPropsPhys", PermaPropsPhys)
hook.Add( "CanPlayerUnfreeze", "PermaPropsUnfreeze", PermaPropsPhys) -- Prevents people from pressing RELOAD on the physgun

local function PermaPropsTool( ply, tr, tool )

	if IsValid(tr.Entity) then

		if tr.Entity.PermaProps then

			if tool == "permaprops" then

				return true

			end

			return PermaProps.HasPermission( ply, "Tool")

		end

		if tr.Entity:GetClass() == "sammyservers_textscreen" and tool == "permaprops" then -- Let people use PermaProps on textscreen
			
			return true

		end

	end

end
hook.Add( "CanTool", "PermaPropsTool", PermaPropsTool)

local function PermaPropsProperty( ply, property, ent )

	if IsValid(ent) and ent.PermaProps and tool ~= "permaprops" then

		return PermaProps.HasPermission( ply, "Property")

	end

end
hook.Add( "CanProperty", "PermaPropsProperty", PermaPropsProperty)

/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

util.AddNetworkString("pp_open_menu")
util.AddNetworkString("pp_info_send")

local function PermissionLoad()

	if not PermaProps then PermaProps = {} end
	if not PermaProps.Permissions then PermaProps.Permissions = {} end

	PermaProps.Permissions["superadmin"] = { Physgun = true, Tool = true, Property = true, Save = true, Delete = true, Update = true, Menu = true, Permissions = true, Inherits = "admin", Custom = true }
	PermaProps.Permissions["admin"] = { Physgun = false, Tool = false, Property = false, Save = true, Delete = true, Update = true, Menu = true, Permissions = false, Inherits = "user", Custom = true }
	PermaProps.Permissions["user"] = { Physgun = false, Tool = false, Property = false, Save = false, Delete = false, Update = false, Menu = false, Permissions = false, Inherits = "user", Custom = true }

	if CAMI then

		for k, v in pairs(CAMI.GetUsergroups()) do

			if k == "superadmin" or k == "admin" or k == "user" then continue end

			PermaProps.Permissions[k] = { Physgun = false, Tool = false, Property = false, Save = false, Delete = false, Update = false, Menu = false, Permissions = false, Inherits = v.Inherits, Custom = false }

		end
		
	end

	if file.Exists( "permaprops_config.txt", "DATA" ) then
 		file.Delete( "permaprops_config.txt" )
	end

	if file.Exists( "permaprops_permissions.txt", "DATA" ) then
 		
 		local content = file.Read("permaprops_permissions.txt", "DATA")
 		local tablecontent = util.JSONToTable( content )

 		for k, v in pairs(tablecontent) do
 			
 			if PermaProps.Permissions[k] == nil then

 				tablecontent[k] = nil

 			end

 		end

 		table.Merge(PermaProps.Permissions, ( tablecontent or {} ))

	end

end

hook.Add("Initialize", "PermaPropPermLoad", PermissionLoad)
hook.Add("CAMI.OnUsergroupRegistered", "PermaPropPermLoadCAMI", PermissionLoad) -- In case something changes

local function PermissionSave()

	file.Write( "permaprops_permissions.txt", util.TableToJSON(PermaProps.Permissions) ) 

end

local function pp_open_menu( ply )

	if !PermaProps.HasPermission( ply, "Menu") then ply:ChatPrint("Access denied !") return end

	local SendTable = {}
	local Data_PropsList = sql.Query( "SELECT * FROM permaprops WHERE map = ".. sql.SQLStr(game.GetMap()) .. ";" )

	if Data_PropsList and #Data_PropsList < 200 then
	
		for k, v in pairs( Data_PropsList ) do

			local data = util.JSONToTable(v.content)

			SendTable[v.id] = {Model = data.Model, Class = data.Class, Pos = data.Pos, Angle = data.Angle}

		end

	elseif Data_PropsList and #Data_PropsList > 200 then -- Too much props dude :'(

		for i = 1, 199 do
			
			local data = util.JSONToTable(Data_PropsList[i].content)

			SendTable[Data_PropsList[i].id] = {Model = data.Model, Class = data.Class, Pos = data.Pos, Angle = data.Angle}

		end

	end

	local Content = {}
	Content.MProps = tonumber(sql.QueryValue("SELECT COUNT(*) FROM permaprops WHERE map = ".. sql.SQLStr(game.GetMap()) .. ";"))
	Content.TProps = tonumber(sql.QueryValue("SELECT COUNT(*) FROM permaprops;"))

	Content.PropsList = SendTable
	Content.Permissions = PermaProps.Permissions

	local Data = util.TableToJSON( Content )
	local Compressed = util.Compress( Data )

	net.Start( "pp_open_menu" )
	net.WriteFloat( Compressed:len() )
	net.WriteData( Compressed, Compressed:len() )
	net.Send( ply )

end
concommand.Add("pp_cfg_open", pp_open_menu)

local function pp_info_send( um, ply )

	if !PermaProps.HasPermission( ply, "Menu") then ply:ChatPrint("Access denied !") return end
	
	local Content = net.ReadTable()

	if Content["CMD"] == "DEL" then

		Content["Val"] = tonumber(Content["Val"])

		if Content["Val"] != nil and Content["Val"] <= 0 then return end

		sql.Query("DELETE FROM permaprops WHERE id = ".. sql.SQLStr(Content["Val"]) .. ";")

		for k, v in pairs(ents.GetAll()) do
			
			if v.PermaProps_ID == Content["Val"] then

				ply:ChatPrint("You erased " .. v:GetClass() .. " with a model of " .. v:GetModel() .. " from the database.")
				v:Remove()
				break

			end

		end

	elseif Content["CMD"] == "VAR" then

		if PermaProps.Permissions[Content["Name"]] == nil or PermaProps.Permissions[Content["Name"]][Content["Data"]] == nil  then return end
		if !isbool(Content["Val"]) then return end

		if Content["Name"] == "superadmin" and  ( Content["Data"] == "Custom" or Content["Data"] == "Permissions" or Content["Data"] == "Menu" ) then return end

		if !PermaProps.HasPermission( ply, "Permissions") then ply:ChatPrint("Access denied !") return end

		PermaProps.Permissions[Content["Name"]][Content["Data"]] = Content["Val"]

		PermissionSave()

	elseif Content["CMD"] == "DEL_MAP" then

		sql.Query( "DELETE FROM permaprops WHERE map = ".. sql.SQLStr(game.GetMap()) .. ";" )
		PermaProps.ReloadPermaProps()

		ply:ChatPrint("You erased all props from the map !")

	elseif Content["CMD"] == "DEL_ALL" then

		sql.Query( "DELETE FROM permaprops;" )
		PermaProps.ReloadPermaProps()

		ply:ChatPrint("You erased all props !")

	elseif Content["CMD"] == "CLR_MAP" then

		for k, v in pairs( ents.GetAll() ) do

			if v.PermaProps == true then

				v:Remove()

			end

		end

		ply:ChatPrint("You have removed all props !")

	end

end
net.Receive("pp_info_send", pp_info_send)

/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

if not PermaProps then PermaProps = {} end

function PermaProps.PPGetEntTable( ent )

	if !ent or !ent:IsValid() then return false end

	local content = {}
	content.Class = ent:GetClass()
	content.Pos = ent:GetPos()
	content.Angle = ent:GetAngles()
	content.Model = ent:GetModel()
	content.Skin = ent:GetSkin()
	//content.Mins, content.Maxs = ent:GetCollisionBounds()
	content.ColGroup = ent:GetCollisionGroup()
	content.Name = ent:GetName()
	content.ModelScale = ent:GetModelScale()
	content.Color = ent:GetColor()
	content.Material = ent:GetMaterial()
	content.Solid = ent:GetSolid()
	content.RenderMode = ent:GetRenderMode()
	
	if PermaProps.SpecialENTSSave[ent:GetClass()] != nil and isfunction(PermaProps.SpecialENTSSave[ent:GetClass()]) then

		local othercontent = PermaProps.SpecialENTSSave[ent:GetClass()](ent)
		if not othercontent then return false end
		if othercontent != nil and istable(othercontent) then
			table.Merge(content, othercontent)
		end

	end

	do
		local othercontent = hook.Run("PermaProps.OnEntitySaved", ent)
		if othercontent and istable(othercontent) then
			table.Merge(content, othercontent)
		end
	end

	if ( ent.GetNetworkVars ) then
		content.DT = ent:GetNetworkVars()
	end

	local sm = ent:GetMaterials()
	if ( sm and istable(sm) ) then

		for k, v in pairs( sm ) do

			if ( ent:GetSubMaterial( k )) then

				content.SubMat = content.SubMat or {}
				content.SubMat[ k ] = ent:GetSubMaterial( k-1 )

			end

		end

	end

	local bg = ent:GetBodyGroups()
	if ( bg ) then

		for k, v in pairs( bg ) do
	
			if ( ent:GetBodygroup( v.id ) > 0 ) then

				content.BodyG = content.BodyG or {}
				content.BodyG[ v.id ] = ent:GetBodygroup( v.id )

			end
	
		end

	end

	if ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid() then
		content.Frozen = !ent:GetPhysicsObject():IsMoveable()
	end

	if content.Class == "prop_dynamic" then
		content.Class = "prop_physics"
	end

	--content.Table = PermaProps.UselessContent( ent:GetTable() )

	return content

end

function PermaProps.PPEntityFromTable( data, id )

	if not id or not isnumber(id) then return false end
	if not data or not istable(data) then return false end

	if data.Class == "prop_physics" and data.Frozen then
		data.Class = "prop_dynamic" -- Can reduce lags
	end

	local ent = ents.Create(data.Class)
	if !ent then return false end
	if !ent:IsVehicle() then if !ent:IsValid() then return false end end
	ent:SetPos( data.Pos or Vector(0, 0, 0) )
	ent:SetAngles( data.Angle or Angle(0, 0, 0) )
	ent:SetModel( data.Model or "models/error.mdl" )
	ent:SetSkin( data.Skin or 0 )
	//ent:SetCollisionBounds( ( data.Mins or 0 ), ( data.Maxs or 0 ) )
	ent:SetCollisionGroup( data.ColGroup or 0 )
	ent:SetName( data.Name or "" )
	ent:SetModelScale( data.ModelScale or 1 )
	ent:SetMaterial( data.Material or "" )
	ent:SetSolid( data.Solid or 6 )

	if PermaProps.SpecialENTSSpawn[data.Class] != nil and isfunction(PermaProps.SpecialENTSSpawn[data.Class]) then

		PermaProps.SpecialENTSSpawn[data.Class](ent, data.Other)

	else

		ent:Spawn()

	end

	hook.Run("PermaProps.OnEntityCreated", ent, data)

	ent:SetRenderMode( data.RenderMode or RENDERMODE_NORMAL )
	ent:SetColor( data.Color or Color(255, 255, 255, 255) )

	if data.EntityMods != nil and istable(data.EntityMods) then -- OLD DATA

		if data.EntityMods.material then
			ent:SetMaterial( data.EntityMods.material["MaterialOverride"] or "")
		end
		
		if data.EntityMods.colour then
			ent:SetColor( data.EntityMods.colour.Color or Color(255, 255, 255, 255))
		end

	end

	if data.DT then

		for k, v in pairs( data.DT ) do

			if ( data.DT[ k ] == nil ) then continue end
			if !isfunction(ent[ "Set" .. k ]) then continue end
			ent[ "Set" .. k ]( ent, data.DT[ k ] )

		end

	end

	if data.BodyG then

		for k, v in pairs( data.BodyG ) do

			ent:SetBodygroup( k, v )

		end

	end


	if data.SubMat then

		for k, v in pairs( data.SubMat ) do

			if type(k) != "number" or type(v) != "string" then continue end

			ent:SetSubMaterial( k-1, v )
			
		end

	end

	if data.Frozen != nil then
		
		local phys = ent:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:EnableMotion(!data.Frozen)
		end

	end

	/*if data.Table then

		table.Merge(ent:GetTable(), data.Table)

	end*/

	ent.PermaProps_ID = id
	ent.PermaProps = true
	
	// For all idiots who don't know how to config FPP, FUCK YOU
	function ent:CanTool( ply, trace, tool )

		if trace and IsValid(trace.Entity) and trace.Entity.PermaProps then

			if tool == "permaprops" then

				return true

			end

			return PermaProps.HasPermission( ply, "Tool")

		end

	end

	return ent

end

function PermaProps.ReloadPermaProps()

	for k, v in pairs( ents.GetAll() ) do

		if v.PermaProps == true then

			v:Remove()

		end

	end

	local content = PermaProps.SQL.Query( "SELECT * FROM permaprops WHERE map = ".. sql.SQLStr(game.GetMap()) .. ";" )

	if not content or content == nil then return end
	
	for k, v in pairs( content ) do

		local data = util.JSONToTable(v.content)

		local e = PermaProps.PPEntityFromTable(data, tonumber(v.id))
		if !e or !e:IsValid() then continue end

	end

end
hook.Add("InitPostEntity", "InitializePermaProps", PermaProps.ReloadPermaProps)
hook.Add("PostCleanupMap", "WhenCleanUpPermaProps", PermaProps.ReloadPermaProps) -- #MOMO
timer.Simple(5, function() PermaProps.ReloadPermaProps() end) -- When the hook isn't call ...

function PermaProps.SparksEffect( ent )

	local effectdata = EffectData()
	effectdata:SetOrigin(ent:GetPos())
	effectdata:SetMagnitude(2.5)
	effectdata:SetScale(2)
	effectdata:SetRadius(3)
	util.Effect("Sparks", effectdata, true, true)

end

function PermaProps.IsUserGroup( ply, name )

    if not ply:IsValid() then return false end
    return ply:GetNetworkedString("UserGroup") == name

end

function PermaProps.IsAdmin( ply )

    if ( PermaProps.IsUserGroup(ply, "superadmin") or false ) then return true end
    if ( PermaProps.IsUserGroup(ply, "admin") or false ) then return true end

    return false

end

function PermaProps.IsSuperAdmin( ply )

	return ( PermaProps.IsUserGroup(ply, "superadmin") or false )

end

function PermaProps.UselessContent( tbl )

	local function SortFcn( tbl2 )

		for k, v in pairs( tbl2 ) do

			if isfunction( v ) or isentity( v ) then
				
				tbl2[k] = nil

			elseif istable( v ) then
				
				SortFcn( v )

			end
			
		end

		return tbl2

	end

	for k, v in pairs( tbl ) do

		if isfunction( v ) or isentity( v ) then
			
			tbl[k] = nil

		elseif istable( v ) then
			
			SortFcn( v )

		end
		
	end

	return tbl

end
