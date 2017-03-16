if SERVER then
	AddCSLuaFile( "shared.lua" )
end
if CLIENT then
	SWEP.PrintName			= "Scout SM24"
	SWEP.NameOfSWEP			= "rcs_sm24" --always make this the name of the folder the SWEP is in.
end
SWEP.Base					= "rcs_scout"
SWEP.ViewModel				= "models/weapons/v_snip_scm24.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_scm24.mdl"
SWEP.Primary.Sound			= Sound( "Weapon_SM24.Single" )