local matToytown = Material( "pp/toytown-top" )

CreateClientConVar("br_bluredges", "1", true, false, "", 0, 1)

CreateClientConVar("br_cinematic_spectator", "0", true, false, "", 0, 1)

local pp_toytown_passes = 3

local pp_toytown_size = 0.4



function DrawToyTown( NumPasses, H )

	cam.Start2D()



	surface.SetMaterial( matToytown )

	surface.SetDrawColor( 255, 255, 255, 255 )



	for i = 1, NumPasses do



		render.CopyRenderTargetToTexture( render.GetScreenEffectTexture() )



		surface.DrawTexturedRect( 0, 0, ScrW(), H )

		surface.DrawTexturedRectUV( 0, ScrH() - H, ScrW(), H, 0, 1, 1, 0 )



	end



	cam.End2D()

end



local tab = {

	["$pp_colour_addr"] = 0,

	["$pp_colour_addg"] = 0,

	["$pp_colour_addb"] = 0,

	["$pp_colour_brightness"] = -0.04,

	["$pp_colour_contrast"] = 0.85,

	["$pp_colour_colour"] = 0.82,

	["$pp_colour_mulr"] = 0,

	["$pp_colour_mulg"] = 0,

	["$pp_colour_mulb"] = 0

}



hook.Add( "RenderScreenspaceEffects", "darkscreenbreach", function()

    local br_cinematic_spectator = GetConVar("br_cinematic_spectator")

    if LocalPlayer():GTeam() == TEAM_SPEC and !br_cinematic_spectator:GetBool() then return end

    if LocalPlayer():GTeam() == TEAM_SCP then return end

    if LocalPlayer():GetNClass() == "MTF Juggernaut" or LocalPlayer():GetNClass() == "MTF Special" then return end

    if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then return end

    if LocalPlayer():GetPos().z > 1370 then return end

    if preparing == true then return end

    DrawColorModify( tab )

end)



hook.Add( "RenderScreenspaceEffects", "bluredgebreach", function()



    local pp_toytown = GetConVar("br_bluredges")

    local br_cinematic_spectator = GetConVar("br_cinematic_spectator")



    if LocalPlayer():GTeam() == TEAM_SPEC and !br_cinematic_spectator:GetBool() then return end

    if !pp_toytown:GetBool() then return end

	if ( !render.SupportsPixelShaders_2_0() ) then return end



	local NumPasses = pp_toytown_passes

	local H = math.floor( ScrH() * pp_toytown_size )



	DrawToyTown( NumPasses, H )



end )