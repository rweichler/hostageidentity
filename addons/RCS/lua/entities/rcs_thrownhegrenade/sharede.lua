if (SERVER) then

	SWEP.Radius = 100 --radius to remove props





	
	











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
			local pos = self.Entity:GetPos()
			for _, ent in pairs(ents.GetAll()) do
				if ent.Type != "brush" and !ent:IsPlayer() and !ent:IsNPC() then --don't remove players, npc's or brushes
					local entpos = ent:GetPos()
					if (pos - entpos):Length() < self.Radius then --check if these entities are close to the grenade
						ent:Remove() --remove them
					end
				end
			end
			--explosion effect
			local xplode = ents.Create( "env_explosion" )
			xplode:SetPos( self.Entity:GetPos() )
			xplode:SetOwner( ownerofnade )
			xplode:Spawn()
			xplode:SetKeyValue( "iMagnitude", "0" )
			xplode:Fire( "Explode", 0, 0 )
			xplode:EmitSound( "weapons/explode"..math.random(3,5)..".wav", 500, 500 )
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
		//self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local lollol = -data.Speed * data.HitNormal * .1 + (data.OurOldVelocity * -0.6)
	phys:ApplyForceCenter(lollol)
end
