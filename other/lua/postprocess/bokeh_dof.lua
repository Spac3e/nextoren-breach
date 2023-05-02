--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   lua/postprocess/bokeh_dof.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local blur_mat = Material( "pp/bokehblur" )

local pp_bokeh = CreateClientConVar( "pp_bokeh", "0", false, false )
local pp_bokeh_blur = CreateClientConVar( "pp_bokeh_blur", "5", true, false )
local pp_bokeh_distance = CreateClientConVar( "pp_bokeh_distance", "0.1", true, false )
local pp_bokeh_focus = CreateClientConVar( "pp_bokeh_focus", "1.0", true, false )

function DrawBokehDOF( intensity, distance, focus )

	render.UpdateScreenEffectTexture()

	blur_mat:SetTexture( "$BASETEXTURE", render.GetScreenEffectTexture() )
	blur_mat:SetTexture( "$DEPTHTEXTURE", render.GetResolvedFullFrameDepth() )

	blur_mat:SetFloat( "$size", intensity )
	blur_mat:SetFloat( "$focus", distance )
	blur_mat:SetFloat( "$focusradius", focus )

	render.SetMaterial( blur_mat )
	render.DrawScreenQuad()

end

local function OnChange( name, oldvalue, newvalue )

	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	if ( newvalue != "0" ) then
		DOFModeHack( true )
	else
		DOFModeHack( false )
	end

end
cvars.AddChangeCallback( "pp_bokeh", OnChange )

hook.Add( "RenderScreenspaceEffects", "RenderBokeh", function()

	if ( !pp_bokeh:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "bokeh" ) ) then return end

	DrawBokehDOF( pp_bokeh_blur:GetFloat(), pp_bokeh_distance:GetFloat(), pp_bokeh_focus:GetFloat() )

end )

hook.Add( "NeedsDepthPass", "NeedsDepthPass_Bokeh", function()

	if ( pp_bokeh:GetBool() ) then return true end

end )
