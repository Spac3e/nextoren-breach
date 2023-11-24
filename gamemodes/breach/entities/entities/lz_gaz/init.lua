AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local auto_lz_gaz_time = 0
local kashli_na_vbr = {
    "nextoren/unity/cough1.ogg",
    "nextoren/unity/cough2.ogg",
    "nextoren/unity/cough3.ogg"
}

local areas = {
    {Vector(4424, -8052, -127), Vector(10572, -2956, 1233)},
    {Vector(4663, -3055, -179), Vector(11121, -1430, 825)},
    {Vector(10650, -422, -40), Vector(8433, -1776, 461)},
    {Vector(7130, -1870, -142), Vector(7884, -1047, 346)},
    {Vector(2128, -3420, -1435), Vector(-1370, -6421, -23)}
}

function ENT:Think()
    if CurTime() < auto_lz_gaz_time then return end

    for _, ply in pairs(player.GetAll()) do
        if ply:GTeam() != TEAM_SPEC and not ply.GASMASK_Equiped then
            local plypos = ply:GetPos()
            local inarea = false

            for _, area in ipairs(areas) do
                local vec1, vec2 = area[1], area[2]
                if plypos:WithinAABox(vec1, vec2) then
                    inarea = true
                    break
                end
            end

            if !inarea then continue end

            local whitelist = {
                "models/cultist/humans/mog/mog_hazmat.mdl",
                "models/cultist/humans/sci/hazmat_1.mdl",
                "models/cultist/humans/sci/hazmat_2.mdl",
                "models/cultist/humans/dz/dz.mdl",
                "models/cultist/humans/goc/goc.mdl",
                "models/cultist/humans/scp_special_scp/special_5.mdl",
                "models/cultist/humans/scp_special_scp/special_6.mdl",
                "models/cultist/humans/scp_special_scp/special_8.mdl",
                "models/cultist/scp/173.mdl"
            }

            local roleswhitelist = {
                [role.DZ_Gas] = true,
            }

            if !whitelist[ply:GetModel()] and !roleswhitelist[ply:GetRoleName()] and ply:GetMoveType() != MOVETYPE_NOCLIP then
                ply:TakeDamage(ply:GetMaxHealth() / 10)
                ply:EmitSound(kashli_na_vbr[math.random(1, #kashli_na_vbr)])
            end
        end
    end

    auto_lz_gaz_time = CurTime() + 3
end
