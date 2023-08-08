--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dtree_node_button.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self:SetTextInset( 32, 0 )
	self:SetContentAlignment( 4 )

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "TreeNodeButton", self, w, h )

	--
	-- Draw the button text
	--
	return false

end

function PANEL:UpdateColours( skin )

	if ( self:IsSelected() ) then return self:SetTextStyleColor( skin.Colours.Tree.Selected ) end
	if ( self.Hovered ) then return self:SetTextStyleColor( skin.Colours.Tree.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Tree.Normal )

end

function PANEL:GenerateExample()

	-- Do nothing!

end

derma.DefineControl( "DTree_Node_Button", "Tree Node Button", PANEL, "DButton" )
