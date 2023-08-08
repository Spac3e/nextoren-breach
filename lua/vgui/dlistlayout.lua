--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dlistlayout.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self:SetDropPos( "82" )

end

function PANEL:OnModified()

	-- Override me

end

function PANEL:OnChildRemoved()

	self:InvalidateLayout()

end

function PANEL:PerformLayout()

	self:SizeToChildren( false, true )

end

function PANEL:OnChildAdded( child )

	child:Dock( TOP )

	local dn = self:GetDnD()
	if ( dn ) then
		child:Droppable( self:GetDnD() )
	end

	if ( self:IsSelectionCanvas() ) then
		child:SetSelectable( true )
	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local pnl = vgui.Create( ClassName )
	pnl:MakeDroppable( "ExampleDraggable", false )
	pnl:SetSize( 200, 200 )

	for i = 1, 5 do

		local btn = pnl:Add( "DButton" )
		btn:SetText( "Button " .. i )

	end

	for i = 1, 5 do

		local btn = pnl:Add( "DLabel" )
		btn:SetText( "Label " .. i )
		btn:SetMouseInputEnabled( true )

	end

	PropertySheet:AddSheet( ClassName, pnl, nil, true, true )

end

derma.DefineControl( "DListLayout", "", PANEL, "DDragBase" )
