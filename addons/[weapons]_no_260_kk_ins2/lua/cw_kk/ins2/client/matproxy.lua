--[[
Server Name: RXSEND Breach
Server IP:   62.122.215.225:27015
File Path:   addons/[weapons]_no_260_kk_ins2/lua/cw_kk/ins2/client/matproxy.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


local math_Approach = math.Approach

CustomizableWeaponry_KK.ins2.matproxy = CustomizableWeaponry_KK.ins2.matproxy or {}

// Scope Lense

CustomizableWeaponry_KK.ins2.matproxy.lense = CustomizableWeaponry_KK.ins2.matproxy.lense or {}
local proxy = CustomizableWeaponry_KK.ins2.matproxy.lense

proxy.name = "IronsightVectorResult"

function proxy:init(mat, values)
	self.mults = {}

	self.ResultTo = values.resultvar
	self.ResultBase = Vector(values.resultdefault)
	self.ResultAdd = Vector(values.resultzoomed) - self.ResultBase
end

function proxy:bind(mat, ent)
	if !IsValid(ent) then return end

	local mul = self.mults[ent] or 0.5

	if IsValid(ent.wepParent) and ent.wepParent.CW20Weapon and ent.wepParent:isAiming() then
		mul = math_Approach(mul, 1, FrameTime() * 2)
	else
		mul = math_Approach(mul, 0, FrameTime() * 2)
	end

	mat:SetVector(self.ResultTo, self.ResultBase + mul * self.ResultAdd)
	self.mults[ent] = mul
end

matproxy.Add(proxy)

// Scope Rendertarget

CustomizableWeaponry_KK.ins2.matproxy.scope = CustomizableWeaponry_KK.ins2.matproxy.scope or {}
local proxy = CustomizableWeaponry_KK.ins2.matproxy.scope

proxy.name = "Scope"

function proxy:init(mat, values)
	-- self.resultVars = self.resultVars or {}
	-- self.resultVars[values.resultvar] = true
	-- self.ResultTo = values.resultvar
	-- self.ResultBase = Vector(values.resultdefault)
	-- self.ResultAdd = Vector(values.resultzoomed) - self.ResultBase
end

function proxy:bind(mat, ent)
	if !IsValid(ent) then return end

	-- print("scope proxy", ent, CurTime())

	-- local mul = self.mults[ent] or 0.5

	-- if IsValid(ent.wepParent) and ent.wepParent.CW20Weapon and ent.wepParent:isAiming() then
		-- mul = math_Approach(mul, 1, FrameTime() * 2)
	-- else
		-- mul = math_Approach(mul, 0, FrameTime() * 2)
	-- end

	-- mat:SetVector(self.ResultTo, self.ResultBase + mul * self.ResultAdd)
	-- self.mults[ent] = mul
end

matproxy.Add(proxy)
