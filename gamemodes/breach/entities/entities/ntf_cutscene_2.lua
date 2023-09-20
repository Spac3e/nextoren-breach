AddCSLuaFile()

ENT.Base = "base_anim"

ENT.PrintName		= "NTF_CutScene"

ENT.Type			= "anim"

ENT.Spawnable		= true

ENT.AdminSpawnable	= true

ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Owner = nil

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()

	self.Entity:SetModel( self.Owner:GetModel() )

	self.Entity:SetMoveType(MOVETYPE_NONE )

	self:SetCollisionGroup( COLLISION_GROUP_NONE    )

	self:SetPos(Vector(-10527.646484, -77.443832, 2373.897461))


	self:SetAngles(Angle(0, 0, 0))

    self:SetModelScale( 1 )

    self:SetPlaybackRate( 1 )

	self:SetLocalVelocity( Vector( 0, 0, -240 ) )

	self.Owner:SetNoDraw(true)

	timer.Simple(.3, function()
		if IsValid(self) then

			self.Entity:SetSequence("2appel_a")

			for i = 0, self.Owner:GetNumBodyGroups() -1 do
				self.Entity:SetBodygroup(i, self.Owner:GetBodygroup(i))
			end
			self.Entity:SetBodygroup(4,0)
		
			self:SetPlaybackRate( 1 )

			self:EmitSound("weapons/universal/uni_bipodretract.wav", 160)
			timer.Create("NTF_Sound", 1, 4, function()
				if !IsValid(self) then return end
				self:EmitSound("nextoren/charactersounds/foley/sprint/sprint_"..math.random(1,52)..".wav", 160)
			end)
	
		end
	end)

	timer.Simple(2, function()
		self.Entity:SetMoveType(MOVETYPE_NOCLIP )

	end)

	timer.Simple(4.7, function()
		if SERVER then
			self.Owner:SetNoDraw(false)
			self:Remove()
		end

	end)

end

function ENT:Think()


	for _, ply in ipairs(player.GetAll()) do

		if ply == self:GetOwner() then

			ply:SetNWEntity("NTF1Entity", self)

		end

	end

	self:NextThink( CurTime() )

	return true

end

function ENT:OnRemove()

	for _, ply in ipairs(player.GetAll()) do

		if ply == self:GetOwner() then

			ply:SetNWEntity("NTF1Entity", NULL)

		end

	end

end

if CLIENT then

	function ENT:Draw()

		if LocalPlayer() == self:GetOwner() then

			self:DrawModel()


		end

	end

end



