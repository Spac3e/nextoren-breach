--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dcategorylist.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self.pnlCanvas:DockPadding( 2, 2, 2, 2 )

end

function PANEL:AddItem( item )

	item:Dock( TOP )
	DScrollPanel.AddItem( self, item )
	self:InvalidateLayout()

end

function PANEL:Add( name )

	local Category = vgui.Create( "DCollapsibleCategory", self )
	Category:SetLabel( name )
	Category:SetList( self )

	self:AddItem( Category )

	return Category

end

function PANEL:Paint( w, h )

	derma.SkinHook( "Paint", "CategoryList", self, w, h )
	return false

end

function PANEL:UnselectAll()

	for k, v in pairs( self:GetChildren() ) do

		if ( v.UnselectAll ) then
			v:UnselectAll()
		end

	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )

	local Cat = ctrl:Add( "Test category with text contents" )
	Cat:Add( "Item 1" )
	Cat:Add( "Item 2" )

	-- The contents can be any panel, even a DPanelList
	local Cat2 = ctrl:Add( "Test category with panel contents" )
	Cat2:SetTall( 100 )
	local Contents = vgui.Create( "DButton" )
	Contents:SetText( "This is the content of the category" )
	Cat2:SetContents( Contents )

	ctrl:InvalidateLayout( true )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "DCategoryList", "", PANEL, "DScrollPanel" )
