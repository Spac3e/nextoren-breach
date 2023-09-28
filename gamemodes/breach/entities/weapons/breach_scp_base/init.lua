AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Ability_ClientsideCooldown")
util.AddNetworkString("GestureClientNetworking")
util.AddNetworkString("ForbidTalant")

function SWEP:Cooldown(abilityIndex, cooldownTime)
    if self.AbilityIcons[abilityIndex].CooldownTime <= CurTime() then
        self.AbilityIcons[abilityIndex].CooldownTime = CurTime() + cooldownTime
        return true
    else
        return false
    end
end