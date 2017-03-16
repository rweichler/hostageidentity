if SERVER then
	AddCSLuaFile ("shared.lua")
	SWEP.HoldType = "ar2"
else
	SWEP.PrintName		= "Angle Getter"
	SWEP.Author			= "cheesylard"
	SWEP.Purpose		= "Prints angles and positions of props/entites to the console, used for Hostage Identity development.\nIf you don't want this, delete the HostageIdentityMapRequirements folder in addons."
	SWEP.Instructions	= "Left click to print the props position/angles to the console.\nRight click to move the prop you are shooting at the the position of the prop that you lastly left clicked at (right click not really used, just for fun =P)."
	SWEP.Slot		= 5
	SWEP.SlotPos	= 100
end
local pos, ang, ownpos, ownang, acc, SELF
SELF = self
acc = 10000 --accuracy of thingy printed to console, obviously the higher the number, the more accurate it is, this is ideal

SWEP.Category = "***Hostage Identity DEV"
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.BobScale			= 0
SWEP.SwayScale			= 0

SWEP.Primary.Ammo		= ""
SWEP.Secondary.Ammo		= ""

function SWEP:ANIM(anim)
	self.Weapon:SendWeaponAnim(anim)
end

function SWEP:Deploy()
	self:ANIM(ACT_VM_DRAW)
end

function SWEP:setposang(poss,angs)
	self.Owner:SetPos(poss)
	self.Owner:SetEyeAngles(angs)
end
function SWEP:PrimaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if tr.HitWorld then return end
	local ent = tr.Entity
	pos = ent:GetPos()
	if ent:IsPlayer() or ent:IsNPC() then
		ang = ent:EyeAngles()
	else
		ang = ent:GetAngles()
	end
	self.Owner:ConCommand("echo Vector("
	..(math.floor(pos.x*acc)/acc)
	..","
	..(math.floor(pos.y*acc)/acc)
	..","
	..(math.floor(pos.z*acc)/acc)
	.."), Angle("
	..(math.floor(ang.p*acc)/acc)
	..","
	..(math.floor(ang.y*acc)/acc)
	..","
	..(math.floor(ang.r*acc)/acc)
	.."),")
	self:ANIM(ACT_VM_DETACH_SILENCER)
	self:ANIM(ACT_VM_PRIMARYATTACK)
end

function SWEP:SecondaryAttack()
	local tr = self.Owner:GetEyeTrace()
	if !pos or tr.HitWorld then return end
	local ent = tr.Entity
	ent:SetPos(pos)
	if ent:IsPlayer() or ent:IsNPC() then
		ent:SetEyeAngles(ang)
	else
		ent:SetAngles(ang)
	end
	self:ANIM(ACT_VM_ATTACH_SILENCER)
	self:ANIM(ACT_VM_PRIMARYATTACK_SILENCED)
end
