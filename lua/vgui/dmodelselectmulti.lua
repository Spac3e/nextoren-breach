--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dmodelselectmulti.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self.ModelPanels = {}
	self:SetTall( 66 * 2 + 26 )

end

function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * ( numHeight or 2 ) + 26 )

end

function PANEL:AddModelList( Name, ModelList, strConVar, bDontSort, bDontCallListConVars )

	local ModelSelect = vgui.Create( "DModelSelect", self )

	ModelSelect:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )

	self:AddSheet( Name, ModelSelect )

	self.ModelPanels[Name] = ModelSelect

	return ModelSelect

end

derma.DefineControl( "DModelSelectMulti", "", PANEL, "DPropertySheet" )
