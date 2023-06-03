--[[
Server Name: [RXSEND] Breach 2.6.0
Server IP:   46.174.50.119:27015
File Path:   addons/[weapons]_ballistic_shields/lua/entities/bs_shield/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

include('shared.lua')
include( "ballistic_shields/cl_bs_util.lua" ) 
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()  
	if(bshields.config.dShieldTexture == "") then self:DrawModel() return end
	local webmat = surface.GetURL(bshields.config.dShieldTexture, 256, 256)
	
	if ( self.Mat ) then
		render.MaterialOverrideByIndex( 6, self.Mat )
	end 
	local html_mat = webmat
	local matdata =
	{
        ["$basetexture"]=html_mat:GetName(),
        ["$decal"] = 1,
        ["$translucent"] = 1
	}

	local uid = string.Replace( html_mat:GetName(), "__vgui_texture_", "" )

	self.Mat = CreateMaterial( "bshields_webmat_"..uid, "VertexLitGeneric", matdata )
	self:DrawModel()
	render.ModelMaterialOverride( nil )
end  