AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.PrintName		= "Tree"
ENT.Author		    = ""
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Owner = nil
ENT.IsAttacking = false
ENT.CurrentTargets = {}
ENT.Attacks = 0
ENT.SnapSound = Sound( "snap.wav" )

function ENT:Initialize()
	self:SetModel("models/props_foliage/tree_deciduous_01a.mdl")
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.Copied = nil
	self.CopiedOut = nil
    self.Copied = {}
    self:SetPos(Vector(9085.486328, -1932.134644, 5.520229))
end


-- Функция для анимации предмета
local function AnimateItem(item, destination)
    if IsValid(item) and IsValid(destination) then
        local startPos = item:GetPos()
        local endPos = destination

        item:SetPos(startPos - Vector(0, 0, 10)) -- Переместить предмет вниз немного

        timer.Simple(2, function() -- Измените продолжительность анимации по необходимости (2 секунды в этом примере)
            if IsValid(item) and IsValid(destination) then
                item:SetPos(endPos)
                item:SetVelocity(Vector(0, 0, 300)) -- Бросить предмет вверх (настройте скорость по необходимости)
            end
        end)
    end
end

function ENT:Think()
    if SERVER then
        local nearbyEntities = ents.FindInSphere(self:GetPos(), 150)
        for _, item in pairs(nearbyEntities) do
            if IsValid(item) and item:IsWeapon() and !IsValid(item:GetOwner()) then
                local itemClass = item:GetClass()
                if itemClass == "meganias" or item == self.Copied or item == self.CopiedOut then
                    continue -- Пропустить определенные классы энтити и уже скопированные предметы
                end

                local copy = ents.Create(itemClass)
                copy:SetPos(Vector(9085.438477, -1904.265137, 81.331055)) -- Задайте желаемую позицию для выбрасывания
                copy:Spawn()

                -- Примените параметры copied и copiedout
                self.Copied = item
                self.CopiedOut = copy

                AnimateItem(copy, copy:GetPos() + Vector(0, 0, 10)) -- Анимировать созданный предмет

                break -- Один раз скопировали предмет и прервали цикл
            end
        end
    end

    self:NextThink(CurTime() + 1)
    return true
end