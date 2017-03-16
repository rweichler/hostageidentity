--REAL CS BASE
--sorry for no comments to show what everything does im too lazy to do it LOL!

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

	SWEP.HoldType			= "pistol"

end

if ( CLIENT ) then
	SWEP.PrintName			= "Beretta (Dual)"	
	SWEP.Author				= "cheesylard"
	SWEP.SlotPos			= 2
	SWEP.Slot				= 1
	SWEP.IconLetter			= "s"
	SWEP.NameOfSWEP			= "rcs_elites" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.Category				= "RealCS"
SWEP.Base					= "rcs_base_pistol"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_elite.mdl"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Sound			= Sound( "Weapon_Elite.Single" )
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0001 --starting cone, it WILL increase to something higher, so keep it low
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.MaxReserve		= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Primary.MaxSpread		= 0.15 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle			= 0.5 --how many seconds you have to wait between each shot before the spread is at its best
SWEP.Primary.SpreadIncrease	= 0.21/15 --how much you add to the cone after each shot

SWEP.MoveSpread				= 6 --multiplier for spread when you are moving
SWEP.JumpSpread				= 10 --multiplier for spread when you are jumping
SWEP.CrouchSpread			= 0.5 --multiplier for spread when you are crouching

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.RAmmo = 15
SWEP.LAmmo = 15

SWEP.IronSightsPos = Vector (4.3729, -5.6481, 2.9126)
SWEP.IronSightsAng = Vector (0.0688, -3.8302, 0)

function SWEP:RCSAttack1Pistol()
	if self.Weapon:GetNetworkedBool( "Ironsights" ) == false then
		self.ViewModelFlip = !self.ViewModelFlip
	end
	if self.Weapon:Clip1() == 29 then
		self.RAmmo = 15
		self.LAmmo = 15
	end
	if self.RShot == true then
		self.RShot = false
		self.RAmmo = self.RAmmo - 1
	else
		self.RShot = true
		self.LAmmo = self.LAmmo - 1
	end
	local x
	if self.RShot == true then
		x = "LJustShot"
	else
		x = "RJustShot"
	end
	Msg(self.RAmmo.." (RAmmo), "..self.LAmmo.." (LAmmo), "..x.."\n");
end