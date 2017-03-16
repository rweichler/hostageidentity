if (SERVER) then
	AddCSLuaFile( "shared.lua" )

	function ENT:Initialize()

		self.Entity:SetModel("models/weapons/w_eq_fraggrenade_thrown.mdl")
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:DrawShadow( false )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		local ownerofnade = ownerofhegrenade
		ownerofhegrenade = nil
		
		local phys = self.Entity:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
		
		timer.Simple(2,
		function()
			local xplode = ents.Create( "env_explosion" ) --BOOOOM!!!
			xplode:SetPos( self:GetPos() )
			xplode:SetOwner( ownerofnade ) --DUH!
			xplode:Spawn() --_--;
			xplode:SetKeyValue( "iMagnitude", "100" )
			xplode:Fire( "Explode", 0, 0 )
			xplode:EmitSound( "weapons/hegrenade/explode3.wav", 500, 500 )
			self.Entity:Remove()
		end )
	end
	
	function ENT:Think()
	end
	function ENT:OnTakeDamage()
	end
	function ENT:Use()
	end
	function ENT:StartTouch()
	end
	function ENT:EndTouch()
	end
	function ENT:Touch()
	end
end

if (CLIENT) then
	function ENT:Draw()
		self.Entity:DrawModel()
	end
	function ENT:IsTranslucent()
		return true
	end
end

ENT.Type = "anim"
function ENT:OnRemove()
end
function ENT:PhysicsUpdate()
end
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local lollol = -data.Speed * data.HitNormal * .1 + (data.OurOldVelocity * -0.6)
	phys:ApplyForceCenter(lollol)
end
