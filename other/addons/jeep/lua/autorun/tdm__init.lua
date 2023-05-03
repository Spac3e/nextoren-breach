-- Credits: G-Force (STEAM_0:1:19084184)
 
if not SERVER then return end
 
-- GLOBAL VARIABLES
TDMCars                 = TDMCars                   or {}
 
-- CALLBACK FUNCTIONS
TDMCars.Think           = TDMCars.Think             or {}
TDMCars.EnterEvent      = TDMCars.EnterEvent        or {}
TDMCars.ExitEvent       = TDMCars.ExitEvent         or {}
TDMCars.SpawnEvent      = TDMCars.SpawnEvent        or {}
TDMCars.RemoveEvent     = TDMCars.RemoveEvent       or {}
 
-- CACHING
TDMCars.VehiclesSpawned = TDMCars.VehiclesSpawned   or {}
TDMCars.ActiveThinks    = TDMCars.ActiveThinks      or {}
 
-- Adding vehicle to cache list on creation
hook.Add( "OnEntityCreated", "TDMCars_OnEntityCreated", function( ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        timer.Simple( 0, function()
            TDMCars.VehiclesSpawned[ ent ] = true
 
            local mdl = ent:GetModel():lower()
            local callback = TDMCars.SpawnEvent[ mdl ]
 
            if callback then
                TDMCars.SpawnEvent[ mdl ]( ent )
            end
        end )
    end
end )
 
-- Removing vehicle from cache list on removal
hook.Add( "EntityRemoved", "TDMCars_EntityRemoved", function( ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()
        TDMCars.VehiclesSpawned[ ent ] = nil
 
        local callback = TDMCars.RemoveEvent[ mdl ]
        if callback then
            TDMCars.RemoveEvent[ mdl ]( ent )
        end
    end
end )
 
-- Adding vehicle to think list on entry
hook.Add( "PlayerEnteredVehicle", "TDMCars_PlayerEnteredVehicle", function( ply, ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()
 
        local think = TDMCars.Think[ mdl ]
        if think then
            local steamid = ply:SteamID()
            hook.Add( "Think", "TDMCars_Player" .. steamid, function()
                if IsValid( ply ) and IsValid( ent ) then
                    think( ply, ent )
                else
                    hook.Remove( "Think", "TDMCars_Player" .. steamid )
                end
            end )
 
            TDMCars.ActiveThinks[ ply ] = ent
        end
 
        local callback = TDMCars.EnterEvent[ mdl ]
        if callback then
            TDMCars.EnterEvent[ mdl ]( ply, ent )
        end
    end
end )
 
-- Removing vehicle from think list on entry
hook.Add( "PlayerLeaveVehicle", "TDMCars_PlayerLeaveVehicle", function( ply, ent )
    if ent:GetClass() == "prop_vehicle_jeep" then
        local mdl = ent:GetModel():lower()
 
        if TDMCars.ActiveThinks[ ply ] then
            hook.Remove( "Think", "TDMCars_Player" .. ply:SteamID() )
            TDMCars.ActiveThinks[ ply ] = nil
        end
 
        local callback = TDMCars.ExitEvent[ mdl ]
        if callback then
            TDMCars.ExitEvent[ mdl ]( ply, ent )
        end
    end
end )
 
-- TDMCars.Think[ "models/tdmcars/vol_850r.mdl" ] = function( ply, veh )
	-- local Pwr = 0
	-- if ply:KeyDown(IN_FORWARD) then Pwr = 1 end
	-- veh.Cars_Power = Lerp(0.02, veh.Cars_Power or 1, Pwr)
	-- veh:SetPoseParameter("boost_gauge", veh.Cars_Power)
-- end	
-- TDMCars.Think[ "models/tdmcars/242turbo.mdl" ] = function( ply, veh )
	-- local Pwr = 0
	-- if ply:KeyDown(IN_FORWARD) then Pwr = 1 end
	-- veh.Cars_Power = Lerp(0.07, veh.Cars_Power or 1, Pwr)
	-- veh:SetPoseParameter("boost_gauge", veh.Cars_Power)
-- end
TDMCars.Think[ "models/tdmcars/sal_s281_06.mdl" ] = function( ply, veh )
	local Pwr = 0
	if ply:KeyDown(IN_FORWARD) then Pwr = 1 end
	veh.Cars_Power = Lerp(0.06, veh.Cars_Power or 1, Pwr)
	veh:SetPoseParameter("boost_gauge", veh.Cars_Power)
end
TDMCars.Think[ "models/tdmcars/sal_s331_supercab.mdl" ] = function( ply, veh )
	local Pwr = 0
	if ply:KeyDown(IN_FORWARD) then Pwr = 1 end
	veh.Cars_Power = Lerp(0.06, veh.Cars_Power or 1, Pwr)
	veh:SetPoseParameter("boost_gauge", veh.Cars_Power)
end
TDMCars.Think[ "models/tdmcars/mer_slr.mdl" ] = function( ply, veh )
	local Pwr = 0
	if ply:KeyDown(IN_BACK) and veh:GetVelocity():Length() > 800 then Pwr = 1 end
	veh.Cars_Power = Lerp(0.2, veh.Cars_Power or 1, Pwr)
	veh:SetPoseParameter("airbrake_pose", veh.Cars_Power)
end