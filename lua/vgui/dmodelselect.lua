--[[
Server Name: RXSEND Breach
Server IP:   46.174.50.119:27015
File Path:   lua/vgui/dmodelselect.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local PANEL = {}

function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetTall( 66 * 2 + 2 )

end

function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * ( numHeight or 2 ) + 2 )

end

function PANEL:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )

	for model, v in pairs( ModelList ) do

		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 64, 64 )
		icon:SetTooltip( model )
		icon.Model = model
		icon.ConVars = v

		local convars = {}

		-- some model lists, like from wheels, have extra convars in the ModelList
		-- we'll need to add those too
		if ( !bDontCallListConVars && istable( v ) ) then
			table.Merge( convars, v ) -- copy them in to new list
		end

		-- make strConVar optional so we can have everything in the ModelList instead, if we want to
		if ( strConVar ) then
			convars[strConVar] = model
		end

		self:AddPanel( icon, convars )

	end

	if ( !bDontSort ) then
		self:SortByMember( "Model", false )
	end

end

derma.DefineControl( "DModelSelect", "", PANEL, "DPanelSelect" )
