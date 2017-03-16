--// a lousy attempt to get it to reload when the clip is empty, not when you shoot it and its empty



if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

	SWEP.HoldType			= "pistol"

end

if ( CLIENT ) then
	SWEP.PrintName			= "RealReloadTEST"	
	SWEP.Author				= "cheesylard"
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "BA"
		
	SWEP.NameOfSWEP			= "rcs_test" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 0, 230, 215, 255 ) )
end

SWEP.Category				= "RealCS"
SWEP.Base					= "rcs_base"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false --change to true to see whats wrong with it


SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound( "Weapon_deagle.Single" )
SWEP.Primary.Recoil			= 5
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 7
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"



function SWEP:Think() --my failing attempt to reload 

	--[[if self:Clip1() == 0 and not self.EmptyReload == 0 then
		self.EmptyReload = 1 -- couldn't think of a fitting name
		

	end]]--
	

	if self.EmptyReload == 1 and not self.Owner:KeyDown(IN_ATTACK) then
		
		if ( self.ShootafterTakeout > CurTime() ) then return end
		if ( self.Reloadaftershoot > CurTime() ) then return end
		self:SetIronsights( false )
	
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		self.EmptyReload = 0
	
	end
end
