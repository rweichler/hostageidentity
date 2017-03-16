if (SERVER) then --the init.lua stuff goes in here


   AddCSLuaFile ("shared.lua")


   SWEP.Weight = 5
   SWEP.AutoSwitchTo = false
   SWEP.AutoSwitchFrom = false
   SWEP.HoldType = "melee"

end

if (CLIENT) then --the cl_init.lua stuff goes in here


	SWEP.PrintName = "Hand grenade"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "h"
	SWEP.NameOfSWEP			= "rcs_hegrenade" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Primary.NumNades = 1 --number of throwable grenades at your disposal


local here = true
SWEP.Author = "cheesylard"
SWEP.Contact = "cheesylard@hotmail.com"
SWEP.Purpose = ""
SWEP.Instructions = "An HeGrenade, DUH"
SWEP.Category = "RealCS"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Base = "rcs_base"

SWEP.ViewModel = "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IronSightsPos = Vector (7.3161, 0, 0.6718)
SWEP.IronSightsAng = Vector (7.2937, 9.6773, 51.2462)

function SWEP:Holster()
	self.Proned = false
	self.Throwing = false
	self.Farthrow = 0
	self.Farthrow2 = false
return true
end
local ownereyes
function SWEP:Reload()
end

function SWEP:Think()
	if self.Proned and not self.Owner:KeyDown ( IN_ATTACK ) then
		self.Proned = false
		self.Throwing = true
		self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		if self.Farthrow <= CurTime() then self.Farthrow2 = true else self.Farthrow2 = false end
		ownereyes = self.Owner:EyePos() + (self.Owner:GetAimVector() * 2)
		local owner = self.Owner
		timer.Simple( 0.2, function()
			if !owner:Alive() then return end
			self:rcs_hegrenade_Throw()
		end )
	end
	self:ConeStuff(true)
end
function SWEP:OnRemove()
//	if self.Throwing == true then
//		local ent = ents.Create ("rcs_thrownhegrenade")
//		ent:SetPos (ownereyes)
//		ent:SetAngles (Vector(math.random(1,100),math.random(1,100),math.random(1,100)))
//		ent:Spawn()
//	end
end
function SWEP:rcs_hegrenade_Throw()
	if !self.Throwing then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	ownerofhegrenade = self.Owner
	local tr = self.Owner:GetEyeTrace()
	if (!SERVER) then return end
	local ent = ents.Create ("rcs_thrownhegrenade")
	ent:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector() * 2))
	ent:SetAngles (Vector(math.random(1,100),math.random(1,100),math.random(1,100)))
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	local shot_length = tr.HitPos:Length()
	if self.Owner:KeyDown( IN_FORWARD ) then
		self.Force = 3200
	elseif self.Owner:KeyDown( IN_BACK ) then
		self.Force = 2100
	elseif self.Owner:KeyDown( IN_MOVELEFT ) then
		self.Force = 2500
	elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
		self.Force = 2500
	else
		self.Force = 2500
	end
	if self.Farthrow2 then self.Force = self.Force + 600 end
	phys:ApplyForceCenter(self.Owner:GetAimVector()*self.Force*1.2+Vector(0,0,700))
	phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
	self.Primary.NumNades = self.Primary.NumNades - 1
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.6 )
	timer.Simple(0.6,
	function()
		if self.Primary.NumNades <= 0 then
			local owna = self.Owner
			self.Weapon:Remove()
			owna:ConCommand("lastinv")
		else
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			self.Proned = false
			self.Throwing = false
			self.Farthrow = 0
			self.Farthrow2 = false
		end
	end)
end
function SWEP:PrimaryAttack()
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if self.Throwing then return end
	if !self.Proned then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Proned = true
		self.Farthrow = 2 + CurTime()

	end
end
