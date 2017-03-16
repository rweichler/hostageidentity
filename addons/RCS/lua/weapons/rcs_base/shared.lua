/*                                                     +dd         `-/ooso+/-        `:+osoo+/-`                        
                                                       sMM       /hMMmhyyyhmMMh    :dMMdyysydNMd                        
                                                       sMM     .dMMo.       `/h   :MMh`       `-                        
         sd  /hmNN:   /sdmNNmho.      /ydmNNNmh+`      sMM    `mMN-               sMM/                                  
          MNNy/- :. /mMd+-..:sNMs     so/-..-/hMN:     sMM    oMMo                -NMNo:.                               
         dMM/      /NMs       -MM+             sMN     sMM    hMM-                 .smMMMMNdho-                         
         dMl       sMMyssssssssNMh    `+ydmmmmmNMM.    sMM    yMM:                    `-:/oymMMm-                       
         dM|       yMMo@@@@@@@@@@/   /MMs/-....oMM.    sMM    /MMy                           :MMN                       
         dM|       /MM+              NMy       hMM.    sMM     hMM+           `               NMM`                      
         dM|        oMMs-      ./`   dMN-    -hMMM.    sMM      oMMd+.     ./yN   /s/-`    `:hMMs                       
         dM|         .smMNmdmNMNd.   `sNMNmmNmooMM.    sMM       `+hNMMNNNMMNh+   /dNMMNmmNMMNy:                        
          ``            `.-:-.`         .-:-`   ``      ``           `-::-.`         `.-::-.`
*/

SWEP.GamemodeType = "infiniteammo" --available types, "infiniteammo", "sandbox" and "geoforts"


-- THE BASE OF THE ALMIGHTY REAL CS
-- MAY THE LUA BE WITH YOU

--yeah, yeah, I know a lot of vars are strings, they work, I'm not changing them, no matter how messy it is.

--[[ SWEP EDIT LIST: (For those who want their own custom SWeps)
rcs_aug: An AUG-like zooming feature
rcs_scout: Pull-bolt sniper
rcs_usp: Silenceable pistol
rcs_M4a1: Silenceable automatic weapon
rcs_deagle: Deagle skins (this includes hexed skins off of FPSBanana)
rcs_elite: Dual Elite skins (this includes hexed skins off of FPSBanana)
rcs_Glock: Burst fire pistols
rcs_Famas: Burst fire automatic weapons
rcs_57: Standard pistol
rcs_AK47: Standard SMG/Rifle (Yes, that means you can make a Mac10 or Galil with it and it would work)
]]

--If you can code, I made it easy so you can have a silenceable, burst fire sniper if you really want to.
--Just edit the function RCSAttack2 to make it do what you want.

if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "ar2"
	
	
	--send required resources to client
	resource.AddFile("materials/gmod/scope.vmt")
	resource.AddFile("materials/gmod/scope-refract.vmt")
	resource.AddFile("materials/gmod/scope.vtf")
	resource.AddFile("materials/gmod/scope-refract.vtf")
	resource.AddFile("materials/gmod/scope-refract.vtf.vtmp")
	resource.AddFile("materials/gmod/scope.vtf.vtmp")
	--just adding the knife and 2handed holdtype
	local ActIndex = {}
		ActIndex[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL
		ActIndex[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1
		ActIndex[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE
		ActIndex[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2
		ActIndex[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN
		ActIndex[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG
		ActIndex[ "physgun" ] 		= ACT_HL2MP_IDLE_PHYSGUN
		ActIndex[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW
		ActIndex[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE
		ActIndex[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM
		ActIndex[ "normal" ]		= ACT_HL2MP_IDLE
		ActIndex[ "knife" ]		= ACT_HL2MP_IDLE_KNIFE
		ActIndex[ "2hand" ]		= ACT_HL2MP_IDLE_MELEE2
		
	function SWEP:SetWeaponHoldType( t )

			local index = ActIndex[ t ]
			
			if (index == nil) then
				Msg( "SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n" )
				return
			end

			self.ActivityTranslate = {}
			self.ActivityTranslate [ ACT_HL2MP_IDLE ] 					= index
			self.ActivityTranslate [ ACT_HL2MP_WALK ] 					= index+1
			self.ActivityTranslate [ ACT_HL2MP_RUN ] 					= index+2
			self.ActivityTranslate [ ACT_HL2MP_IDLE_CROUCH ] 			= index+3
			self.ActivityTranslate [ ACT_HL2MP_WALK_CROUCH ] 			= index+4
			self.ActivityTranslate [ ACT_HL2MP_GESTURE_RANGE_ATTACK ] 	= index+5
			self.ActivityTranslate [ ACT_HL2MP_GESTURE_RELOAD ] 		= index+6
			self.ActivityTranslate [ ACT_HL2MP_JUMP ] 					= index+7
			self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
			
			self:SetupWeaponHoldTypeForAI( t )

	end
	
end

if ( CLIENT ) then
	SWEP.PrintName			= "RealAdminGun"	
	SWEP.Author				= "cheesylard"
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 75
	SWEP.DefaultVFOV		= 75
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true
	SWEP.NameOfSWEP			= "rcs_base" --always make this the name of the folder the SWEP is in.
	
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "D"
	surface.CreateFont( "csd", ScreenScale( 40 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "cs", ScreenScale( 60 ), 500, true, true, "RCSSelectIcons" )
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 220, 0, 255 ) )
end

SWEP.StrobePace				= 0.7 --frequency of that going in and out for the selection icon, lower for fas ter, higher for slower

SWEP.Category				= "RealCS"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.IsShotgun				= false
SWEP.EjectDelay				= 0


SWEP.IsAlwaysSilenced 		= "no"

SWEP.ShellEjectEffect		= "rg_shelleject"
SWEP.ShellEjectAttachment	= "2"

SWEP.Primary.Sound			= Sound( "Weapon_AWP.Single" )
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 100000000000
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= -1 --set to -1 for INFINATE AMMO BABY!!!!!!!!!!!
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.CrossHairIronsight		= false
SWEP.delaytime				= 1
SWEP.DryFires				= false

SWEP.SilencedCone			= 0.1
SWEP.BurstCone				= 0.1

SWEP.IncreasesSpread		= true --it increases spread


SWEP.Primary.MaxSpread		= 0.15 --the maximum amount the spread can go by, best left at 0.20 or lower
SWEP.Primary.Handle			= 0.5 --how many seconds you have to wait between each shot before the spread is at its best
SWEP.Primary.SpreadIncrease	= 0.21/15 --how much you add to the cone after each shot
SWEP.Primary.HandleCut		= 15 --the higher the number, the less it spreads, you may need to increase it with SWEP.Primary.Handle,  as it can effect the spread


SWEP.SilencedMaxSpread		= 0.15
SWEP.SilencedHandle			= 0.4
SWEP.SilencedSpreadIncrease	= 0.21/15
SWEP.SilencedHandleCut		= 15

SWEP.BurstMaxSpread			= 0.15
SWEP.BurstHandle			= 0.4
SWEP.BurstSpreadIncrease	= 0.2/15
SWEP.BurstHandleCut			= 15

SWEP.MoveSpread				= 3 --multiplier for spread when you are moving
SWEP.JumpSpread				= 5 --multiplier for spread when you are jumping
SWEP.CrouchSpread			= 0.5 --multiplier for spread when you are crouching

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true //false
SWEP.Secondary.Ammo			= "none"
SWEP.ShellEffect			= "rg_shelleject_rifle"

SWEP.IronSightsPos = Vector (6.1518, -2.9359, 1.0987)
SWEP.IronSightsAng = Vector (-3.3388, -2.8267, -173.704)

SWEP.RunningSIGHTS = {Vector (0.172, -1.8287, 0.7562), Vector (-8.2022, -9.0854, 2.6607)}
--[[----------------------------------------------------
                    BEGIN FUNCTIONS
-------------------------------------------------------]]

local IRONSIGHT_TIME, totalhandle, needstoreload, cone, sincrease, hcut, maxsp, handle, cdw, cdw2, cdw3 --localize everything
SWEP.ShootafterTakeout = 0 --do not change
IRONSIGHT_TIME = 0.25 --how long it takes to move the gun into ironsight mode
totalhandle = 0 --do not change
cdw2 = -1 --do not change
SWEP.Reloadaftersilence = 0 --do not change
SWEP.Spreadincrease = 0 --do not change
SWEP.NextSecondaryAttack = 0--do not change
SWEP.Reloadaftershoot = 0--do not change
SWEP.Zoom = 0--do not change

function SWEP:RCSAttack1() end
function SWEP:RCSAttack2() return false end
function SWEP:RCSReload() end
function SWEP:RCSThink() end
function SWEP:RCSHolster() end
function SWEP:RCSDeploy() end
function SWEP:RCSInit() end

function SWEP:CanPrimaryAttack() --get rid of the SHIZZLE (yo homie dawg whazzup u chillin?)
	if ( self.Weapon:Clip1() <= 0 ) and self.Primary.ClipSize > -1 then
		self.Weapon:EmitSound("Weapon_Pistol.Empty") --ITS EMPTY IDIOT
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
		self.Primary.Automatic = true --for pistols (it doesn't matter because you can't shoot anyways)
		return false
	end
	return true
end
function SWEP:DefaultDeploy(delay, d)
	self.ShootafterTakeout = CurTime() + delay
	self.deploydelay = delay
	if d != true then
		if self:Clip1() <= 0 then timer.Simple( delay, function() self:OtherReload() end) end
	end
	self.Weapon:SetNetworkedInt("deploydelay", CurTime() + delay)
end

--defaults
function SWEP:Initialize() 
   
 	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType ) 
 		self:SetNPCMinBurst( 30 ) 
 		self:SetNPCMaxBurst( 30 ) 
 		self:SetNPCFireRate( 0.01 ) 
 	end 
	if self.Primary.Ammo == "smg1" or self.Primary.Ammo == "buckshot" or self.Primary.Ammo == "ar2" then
		self.Owner.HasPrimary = true
		self.Owner.PrimaryWeapon = self.Weapon
	elseif self.Primary.Ammo == "pistol" or self.Primary.Ammo == "357" then
		self.Owner.HasSecondary = true
		self.Owner.SecondaryWeapon = self.Weapon
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	self.unavailable = false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetIronsights( false )
	self.Primary.Spread = self.Primary.Cone
	self.Reloading = "no"
	self:DefaultDeploy(1, true)
	self:RCSDeploy()
	self.unavailable = false
	self:SetClip1(self.Primary.ClipSize)
 	self.RCS_CLIP1 = self.Primary.ClipSize
 	self.Weapon:SetNetworkedBool( "Ironsights", false ) 
	self.ViewModelFOV = self.DefaultVFOV
	self:RCSInit()
end 

function SWEP:OnRemove()
	self.Weapon_Out = false
	if self.Primary.Ammo == "smg1" or self.Primary.Ammo == "buckshot" or self.Primary.Ammo == "ar2" then
		self.Owner.HasPrimary = false
		self.Owner.PrimaryWeapon = nil
	elseif self.Primary.Ammo == "pistol" or self.Primary.Ammo == "357" then
		self.Owner.HasSecondary = false
		self.Owner.SecondaryWeapon = nil
	end
end
--Crouch modifiers and stuff, thank me because it took me a poopload of time to make

function SWEP:ConeStuff(rcs_think)
	self.Primary.Spread = self.Primary.Cone
	--BEGIN WHOLY MAYONAISE THIS PART TOOK FOREVER
	if self.Weapon:GetNetworkedInt("Silenced") == 1 then
		if self.Weapon:GetNetworkedInt("Zoom") == 1 then
			cone = (self.SilencedCone + self.Zoom1Cone)/2
		elseif self.Weapon:GetNetworkedInt("Zoom") == 2 then
			cone = (self.SilencedCone + self.Zoom2Cone)/2
		else
			cone = self.SilencedCone
		end

		if self.Weapon:GetNetworkedInt("Burst") == 1 or self.Weapon:GetNetworkedInt("FBurst") == 1 then
			if self.Weapon:GetNetworkedInt("Zoom") == 1 then
				cone = (self.SilencedCone + self.BurstCone + self.Zoom1Cone)/3
			elseif self.Weapon:GetNetworkedInt("Zoom") == 2 then
				cone = (self.SilencedCone + self.BurstCone + self.Zoom2Cone)/3
			else
				cone = (self.SilencedCone + self.BurstCone)/2
			end
			sincrease = (self.SilencedSpreadIncrease + self.BurstSpreadIncrease)/2
			hcut = (self.SilencedHandleCut + self.BurstHandleCut)/2
			maxsp = (self.SilencedMaxSpread + self.BurstMaxSpread)/2
			handle = (self.SilencedHandle + self.BurstHandle)/2
		else
			sincrease = self.SilencedSpreadIncrease
			hcut = self.SilencedHandleCut
			maxsp = self.SilencedMaxSpread
			handle = self.SilencedHandle
		end
	elseif self.Weapon:GetNetworkedInt("Burst") == 1 or self.Weapon:GetNetworkedInt("FBurst") == 1 then
		if self.Weapon:GetNetworkedInt("Zoom") == 1 then
			cone = (self.BurstCone + self.Zoom1Cone)/2
		elseif self.Weapon:GetNetworkedInt("Zoom") == 2 then
			cone = (self.BurstCone + self.Zoom2Cone)/2
		else
			cone = self.BurstCone
		end
		sincrease = self.BurstSpreadIncrease
		hcut = self.BurstHandleCut
		maxsp = self.BurstMaxSpread
		handle = self.BurstHandle
	else
		sincrease = self.Primary.SpreadIncrease
		hcut = self.Primary.HandleCut
		maxsp = self.Primary.MaxSpread
		handle = self.Primary.Handle
		if self.Weapon:GetNetworkedInt("Zoom") == 1 then
			cone = self.Zoom1Cone
			if self.Primary.Zoom1HandleCut then
				hcut = self.Primary.Zoom1HandleCut
			end
			if self.Primary.Zoom1SpreadIncrease then
				sincrease = self.Primary.Zoom1SpreadIncrease
			end
			if self.Primary.Zoom1MaxSpread then
				maxsp = self.Primary.Zoom1MaxSpread
			end
			if self.Primary.Zoom1Handle then
				handle = self.Primary.Zoom1Handle
			end
		elseif self.Weapon:GetNetworkedInt("Zoom") == 2 then
			cone = self.Zoom2Cone
		else
			cone = self.Primary.Cone
		end
	end
	--END WHOLY MAYONAISE THIS TOOK FOREVER
	if self.IncreasesSpread == false and self.Weapon:GetNetworkedInt("Zoom") == 0 then
		cone = 0.2
	else
		cone = 0 - sincrease*2/3
	end
	handle = handle*5/6
	--jump and crouch and stuff modifiers
	self.Crosshairsize = 0.035 --default size for crosshairs, it's written first so it can be overridden
	if not self.Owner:IsOnGround() then --if you are jumping
		cone = cone + 0.2
		self.Crosshairsize = 0.06 --set crosshair size accordingly
	elseif self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) then --if you are moving
		if self.IncreasesSpread then
			cone = cone + 0.05
		else
			cone = cone + 0.1 --multiplies the cone  by the custom spread that was set at the top.
		end
		self.Crosshairsize = 0.05
	elseif self.Owner:Crouching() then --if you are crouching
		self.Crosshairsize = 0.02
		handle = handle/2
	end
	self.Primary.Spread = cone
	--that the more you shoot, the more the crosshairs go (0  _  0)
	if !rcs_think and self.IncreasesSpread then --if it has that special spread increasing
		handle = handle*3/2
		if totalhandle <= CurTime() then --if you waited it oiut
			totalhandle = handle + CurTime() --reset it back to mornal
		elseif ((totalhandle - CurTime())/hcut + self.Primary.Spread)> maxsp then --if you went over the limit of how wack the gun is
			totalhandle = (maxsp - self.Primary.Spread)*hcut + CurTime() --set it at it's max
		else --if not 
			totalhandle = totalhandle + handle --add to the spread
		end
		self.Primary.Spread = self.Primary.Spread + sincrease*((totalhandle - CurTime())/handle)

		//self.Owner:PrintMessage(HUD_PRINTTALK, ""..self.Primary.Spread + sincrease*((totalhandle - CurTime())/handle).."")
		self.Weapon:SetNetworkedInt("curhandle", totalhandle ) --send info so it can scale it on the crosshairs
	end
	
	--incorperate the maxspread
	if self.Primary.Spread > maxsp then
		self.Primary.Spread = maxsp
	end
	--set the crosshair size
	self.Weapon:SetNetworkedInt("Crosshair", self.Crosshairsize )
	

end
SWEP.TryingToIronsight = false
function SWEP:SecondaryAttack()
	local deployDELAY = self.Weapon:GetNetworkedInt("deploydelay")
	if ( deployDELAY > CurTime() ) then return end
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if self.Owner:KeyDown(IN_USE) and not self.Owner:KeyDown((IN_FORWARD or IN_BACK or IN_MOVELEFT or IN_MOVERIGHT) and IN_SPEED) then --ironsights
		self:RCSIronsights()
		self.Secondary.Automatic = false
	elseif self.Owner:KeyDown(IN_USE) and self:RCSThink() == "keepiron" then
		self:RCSIronsights()
		self.Secondary.Automatic = false
	else
		if self:RCSAttack2() != false then
			self.Weapon:GetOwner():SetFOV( 0, 0.3 )
		end
		self.Secondary.Automatic = true
	end
	
end
function SWEP:RCSIronsights()
	if ( self.Reloadaftershoot > CurTime() ) then return end
	if ( self.Reloadaftersilence > CurTime() ) then return end
	local deployDELAY = self.Weapon:GetNetworkedInt("deploydelay")
	if ( deployDELAY > CurTime() ) then return end
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if ( self.Zoom == 1 ) then return end
	if ( self.Zoom == 2 ) then return end
	if ( !self.IronSightsPos ) then return end
	if ( self.NextSecondaryAttack > CurTime() ) then return end
	
	--sets the ironsights
	bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )
	self:SetIronsights( bIronsights )
	if self.Weapon:GetNetworkedBool( "Ironsights" ) == true then
		self.Weapon:GetOwner():SetFOV( 60, 0.3 )
	else
		self.Weapon:GetOwner():SetFOV( 0, 0.3 )
	end
	self.NextSecondaryAttack = CurTime() + 0.3 --delay
end


function SWEP:PrimaryAttack()
	local deployDELAY = self.Weapon:GetNetworkedInt("deploydelay")
	if ( deployDELAY > CurTime() ) then return end
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if !self:CanPrimaryAttack() then return end
	self.Reloadaftershoot = CurTime() + self.Primary.Delay			
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self:ConeStuff()
	if self.Weapon:GetNetworkedInt("Silenced") == 1 then
		self.Weapon:EmitSound( self.SilencedSound )
		self:CSShootBullet( self.SilencedDamage, self.SilencedRecoil, self.Primary.NumShots, self.Primary.Spread )
	else
		self.Weapon:EmitSound( self.Primary.Sound )
		self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Spread )
	end
	self:TakePrimaryAmmo( 1 )
	self:RCSAttack1() --do primaryattack for other SWeps that have something extra involved (burst, scope, etc)
end


function SWEP:CSShootBullet( DAMNage, recoil, amount, spread )
	if CLIENT then --in case if someone joined the server, and the font WASNT added.
		surface.CreateFont( "csd", ScreenScale( 40 ), 500, true, true, "CSKillIcons" )
		surface.CreateFont( "cs", ScreenScale( 60 ), 500, true, true, "RCSSelectIcons" )
	end
	local multi = 1 --set the multiplier
	if self.GamemodeType == "geoforts" then --if the config at the top says "geoforts"
		if SERVER then 
			multi = gmod.GetGamemode().geof.teams[self.Owner:Team()].qualify --set the multiplier for qualify round
		else --client
			multi = LocalPlayer():GetNetworkedFloat("gfm"..self.Owner:Team())
		end
	end
	--[[if self.Spreadincrease <= CurTime() then
		self.Spreadincrease = 0.6 + CurTime()
	else
		self.Spreadincrease = self.Spreadincrease + 0.6
	end
	spread = spread + (self.Spreadincrease - CurTime())/15
	self.Owner:PrintMessage(HUD_PRINTTALK, ""..(self.Spreadincrease - CurTime())15.."")]]
	self:ShootEffects()
	local force = DAMNage/5
	if DAMNage > 200 then --changes force to phys objects depending on damage, unless if it's too high (like 5-second admin guns)
		force = 200/5
	end
	amount 	= amount 	or 1
	spread 	= spread 	or 0.01
	local rcsbul1 = {}
	rcsbul1.Num 		= amount
	rcsbul1.Src 		= self.Owner:GetShootPos()			-- Source of bullet, basically where you are
	rcsbul1.Dir 		= self.Owner:GetAimVector()			-- Direction of the bullet, where you are aiming
	rcsbul1.Spread 		= Vector( spread, spread, 0 )		--Spread
	rcsbul1.Tracer		= 2									--show where the bullet it going in game, every 2 bullets, that little yellow dash thing
	rcsbul1.Force		= force								-- Pushes physics objects to your liking
	rcsbul1.Callback	 = function ( attacker, btr, dmginfo ) --boom headshot
		if ( btr.HitGroup == HITGROUP_HEAD ) then
			if CLIENT then killicon.AddFont( self.NameOfSWEP, "CSKillIcons", self.IconLetter.."D", Color( 255, 80, 150, 255 ) ) end
		else
			if CLIENT then killicon.AddFont( self.NameOfSWEP, "CSKillIcons", self.IconLetter, Color( 255, 80, 150, 255 ) ) end
		end
	end 
	--stuff for my machinima
	--if self.Owner:KeyDown (IN_USE) then
	--	rcsbul1.Damage 	= 0
	--else
		rcsbul1.Damage	= DAMNage*multi
	--end
	
	
	
	self.Owner:FireBullets( rcsbul1 )
	
	if self.DryFires == true and self.Weapon:Clip1() <= 1 then
		self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE )
	elseif self.Weapon:GetNetworkedInt("Silenced") == 1 then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
	elseif self.Weapon:GetNetworkedInt("Burst") == 1 then
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) 
	else
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	end	
	
	if ( self.Weapon:GetNetworkedInt("Silenced") != 1 or self.IsAlwaysSilenced != "yes" ) then --only does the muzzleflash if you are not silenced
		self.Owner:MuzzleFlash() --crappy muzzle light
	end
	
	if ( self.Weapon:Clip1() == 1 ) then
		self.EmptyReload = 0
	end
	--elite stuff
	--[[if self.ViewModel == "models/weapons/v_pist_elite.mdl" then
		if self.EliteSHOT then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.EliteSHOT = false
		else
			self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			self.EliteSHOT = true
		end
	else]]if self.BurstType == "pistol" then --glock stuff
		if self.Weapon:GetNetworkedInt("Burst") == 1 then
			self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) 
		else
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		end
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) --3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end --pointless for NPCs to have recoil, and they don't know how to reload either
	self.Owner:ViewPunch( Angle( math.random(-recoil,recoil), math.random(-recoil,recoil*2), 0 ) )
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	if self:Clip1() <= 1 then timer.Simple( self.Primary.Delay, function() self:OtherReload() end) end
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	--cool transparency effect i was messing around with
	if !cdw or cdw < CurTime() then
		cdw = CurTime() + self.StrobePace
		cdw2 = cdw2*-1
	end
	if cdw2 == -1 then
		cdw3 = 255
	else
		cdw3 = 0
	end
	local ich = (cdw2*((cdw - CurTime())*(255/self.StrobePace)))+cdw3
	
	
	draw.SimpleText( self.IconLetter, "RCSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 255, 255, ich ), TEXT_ALIGN_CENTER )	--draw the icon
	--self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end

function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
	self:SetIronsights( true )
end

function SWEP:Reload()
	if self.unavailable then return end
	local deployDELAY = self.Weapon:GetNetworkedInt("deploydelay")
	if ( deployDELAY > CurTime() ) then return end
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if ( self.Reloadaftershoot > CurTime() ) then return end
	if (self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2)) and self:Clip1() <= 0 then
		needstoreload = true
	return
	end
	if isreloading then return end
	if self.Weapon:Clip1() >= self.Primary.ClipSize then return end
	self.Weapon:GetOwner():SetFOV( 0, 0.3 )
	self.DidntSwitch = false
	self.Primary.Automatic = true
	needstoreload = false
	if self.IsShotgun then
		if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
		--// Start reloading if we can
		if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.5, function()
				self.Weapon:SetNetworkedBool( "reloading", true )
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.5)
				self.Reloading = "yes"
				
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.49 )
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			end)
		end
	else
		if self.Weapon:GetNetworkedInt("Silenced") == 1 then
			self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED );
		else
			self.Weapon:DefaultReload( ACT_VM_RELOAD );
		end
	end
	if self.GamemodeType == "infiniteammo" and self.Primary.Ammo != "none" and SERVER then
		local reserve = self.Primary.ClipSize - self:Clip1() or 20
		self.Owner:GiveAmmo(reserve,self.Primary.Ammo)
	end
	self:ALWAYSINZOOM(1)
	self:SetIronsights( false )
	self:RCSReload()
end


function SWEP:TReloadShotty()

	self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
	self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )
	self.Reloading = "yes"

end

function SWEP:OtherReload()
	if self:Clip1() > 0 then return end
	if self.unavailable then return end
	local deployDELAY = self.Weapon:GetNetworkedInt("deploydelay")
	if ( deployDELAY > CurTime() ) then return end
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if ( self.Reloadaftershoot > CurTime() ) then return end
	if self.Owner:KeyDown(IN_ATTACK) or self.Owner:KeyDown(IN_ATTACK2) then
		if self:Clip1() <= 0 then
			needstoreload = true
		end
	return
	end
	if isreloading then return end
	self.Weapon:GetOwner():SetFOV( 0, 0.3 )
	self.DidntSwitch = false
	self.Primary.Automatic = true
	needstoreload = false
	if self.IsShotgun then
		if ( self.Weapon:GetNetworkedBool( "reloading", false ) ) then return end
	
		--// Start reloading if we can
		if ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
			timer.Simple(0.5, function()
				self.Weapon:SetNetworkedBool( "reloading", true )
				self.Weapon:SetVar( "reloadtimer", CurTime() + 0.5)
				self.Reloading = "yes"
				
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.49 )
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			end)
		end
	else
		if self.Weapon:GetNetworkedInt("Silenced") == 1 then
			self.Weapon:DefaultReload( ACT_VM_RELOAD_SILENCED );
		else
			self.Weapon:DefaultReload( ACT_VM_RELOAD );
		end
	end
	if self.GamemodeType == "infiniteammo" and self.Primary.Ammo != "none" and SERVER then
		local reserve = self.Primary.ClipSize - self:Clip1() or 20
		self.Owner:GiveAmmo(reserve,self.Primary.Ammo)
	end
	self:ALWAYSINZOOM(1)
	self:SetIronsights( false )
	self:RCSReload()
end

function SWEP:ALWAYSINZOOM(sens) --this always happen when you zoom, regardless of situation
	self:SetIronsights( false ) --ironsights
	self.Weapon:SetNetworkedInt("Zoom", self.Zoom ) --send data to the client to draw the scope
	self.MouseSensitivity = sens --set the mouse sensitivity accordingly
	if sens == 1 then --determine if we draw the view model depending on sensitivity
		if SERVER then self.Owner:DrawViewModel( true ) end --since it is normal, it must not be scoped, so we draw the view model
	else
		if SERVER then self.Owner:DrawViewModel( false ) end --everything else means that it is scoped, so we don't draw it
	end
end

function SWEP:Think()
	self:ConeStuff(true)
	local double = false
	if needstoreload then self:OtherReload() end
	if self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) and self.Owner:KeyDown(IN_SPEED) then
		if self.Owner:Crouching() then
			self.Weapon:SetNetworkedInt("sprinting", 0)
		else
			self.Weapon:SetNetworkedInt("sprinting", 1)
			if self.Weapon:GetNetworkedBool( "Ironsights" ) == true and self:RCSThink() != "keepiron" then
				self.TryingToIronsight = true
				self:SetIronsights( false )
				self.Weapon:GetOwner():SetFOV( 0, 0.3 )
			end
			double = true
		end
	else
		self.Weapon:SetNetworkedInt("sprinting", 0)
	end
	if double == true then
		self:RCSThink()
	end
	--This gets REALLY annoying. (uncomment and use it if you want)
	--[[
	if self.TryingToIronsight == true and not self.Owner:KeyDown(IN_SPEED) then
		self.TryingToIronsight = false
		if ( self.Reloadaftershoot > CurTime() ) or self.Reloadaftersilence > CurTime()
		or self.Weapon:GetNetworkedInt("deploydelay") > CurTime() or self.ShootafterTakeout > CurTime()
		or self.Zoom >= 1 or !self.IronSightsPos or self.NextSecondaryAttack > CurTime() then return end
		self:SetIronsights( true )
		self.Weapon:GetOwner():SetFOV( 60, 0.3 )
	end
	]]
	self:RCSThink()
end


function SWEP:Holster()	
	self.unavailable = true --set the availability
	self.RCS_CLIP1 = self:Clip1() --set the clip
	totalhandle = 0 --reset the accuracy
	self.Weapon:SetNetworkedInt("curhandle", totalhandle )-- same as above
	if self.Owner:GetFOV() != 0 then
		self.Weapon:GetOwner():SetFOV( 0, 0.1 )
	end
	self:RCSHolster() --run customized function
return true
end


function SWEP:Deploy()
	if self.Weapon:GetNetworkedInt("PutOut")  != 1 then
		self.RCS_CLIP1 = self.Primary.ClipSize
		self:SetClip1(self.Primary.ClipSize)
		self.Weapon:SetNetworkedInt("PutOut", 1 )
	end
	if self.Primary.Ammo == "smg1" or self.Primary.Ammo == "buckshot" or self.Primary.Ammo == "ar2" then
		self.Owner.HasPrimary = true
		self.Owner.PrimaryWeapon = self.Weapon
	elseif self.Primary.Ammo == "pistol" or self.Primary.Ammo == "357" then
		self.Owner.HasSecondary = true
		self.Owner.SecondaryWeapon = self.Weapon
	end
	self.unavailable = false
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetClip1( self.RCS_CLIP1 )
	self:SetIronsights( false )
	self.Primary.Spread = self.Primary.Cone * 1
	self.Reloading = "no"
	if ( self.Weapon:Clip1() == 1 ) then
		self.EmptyReload = 0
	end
	self.Primary.Automatic = true
	self:DefaultDeploy(1)
	self.ViewModelFOV = self.DefaultVFOV
	self:RCSDeploy()
	return true
end

function SWEP:ShootEffects()
	if !self.Weapon:GetNetworkedInt("Silenced", 1) then --no muzzleflash if its silenced
		self.Owner:MuzzleFlash() --crappy muzzle light
	end	
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) --3rd Person Animation
	
	--set up shell for ejection
	local shell = EffectData()
	shell:SetEntity( self.Weapon )
	
	
	--eject the shell (different model depending on ammo type
	if SERVER then --It used to eject 2 shells at once, and I was like, what the heck? and I got really frustrated, so I slapped this on here because I ran out of ideas, and it worked. I honestly have no idea why this fixed it.
		timer.Simple( self.EjectDelay, function() --the awp and pump shotty eject the shell when they pump/pull the bolt, so I had to put a timer for those
			--I gotta thank Teta and elevator13 for this part :D, they helped me in FP
			local viewent = self.Owner:GetViewModel()
			//shell:SetOrigin(viewent:GetAttachment("2").Pos)
			shell:SetOrigin(self.Owner:GetShootPos())
			shell:SetAngle( self.Owner:EyeAngles() + Angle( math.Rand( 0, 60 ), math.Rand( 0, 60 ), math.Rand( 0, 60 ) ) )
			if self.Primary.Ammo == "pistol" then
				util.Effect( "ShellEject", shell )
			elseif self.Primary.Ammo == "buckshot" then
				util.Effect( "ShotgunShellEject", shell )
			else
				util.Effect( "RifleShellEject", shell )
			end
		end)
	end
end

//[:,4a2.] --my friend told me to write this, he always makes fun of me coding lol


--copypasta from cs_base
function SWEP:GetViewModelPosition( pos, ang ) 
	local sightpos, sightang
	if ( !self.IronSightsPos ) then return pos, ang end 
  
	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" ) 
	 
	if ( bIron != self.bLastIron ) then 
	 
		self.bLastIron = bIron  
		self.fIronTime = CurTime()
 	 
	end 
 	sightpos = self.IronSightsPos
	sightang = self.IronSightsAng
	if self.Weapon:GetNetworkedInt("sprinting") == 1 then
		self.SwayScale = 1
		self.BobScale = 2
	elseif ( bIron ) then  
		self.SwayScale 	= 0.3 
		self.BobScale 	= 0.1 
	else  
		self.SwayScale 	= 1.0 
		self.BobScale 	= 1.0 
	end 
	
	local fIronTime = self.fIronTime or 0 
   
	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then  
		return pos, ang  
	end 
 	 
	local Mul = 1.0 
 	 
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then 
	 
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 ) 
		 
		if (!bIron) then Mul = 1 - Mul end 
	 
	end 
  
	local Offset	= sightpos 
	 
	if ( sightang ) then 
		ang = ang * 1 
		ang:RotateAroundAxis( ang:Right(), 		sightang.x * Mul ) 
		ang:RotateAroundAxis( ang:Up(), 		sightang.y * Mul ) 
		ang:RotateAroundAxis( ang:Forward(), 	sightang.z * Mul ) 

	end 
	 
	local Right 	= ang:Right() 
	local Up 		= ang:Up() 
	local Forward 	= ang:Forward() 
	pos = pos + Offset.x * Right * Mul 
	pos = pos + Offset.y * Forward * Mul 
	pos = pos + Offset.z * Up * Mul 
	return pos, ang 
end 

function SWEP:SetIronsights( b ) 
	self.Weapon:SetNetworkedBool( "Ironsights", b ) 
end 

function SWEP:TakePrimaryAmmo( num ) 
	-- Doesn't use clips 
	if self.Primary.ClipSize < 0 then return end
	if ( self.Weapon:Clip1() <= 0 ) then  
	 
		if ( self:Ammo1() <= 0 ) then return end 
		 
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() ) 
	 
	return end 
 	 
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )	 
	self.RCS_CLIP1 = self.RCS_CLIP1 or self.Weapon:Clip1() --the console spits out that it's nil for some reason 0_o
	self.RCS_CLIP1 = self.RCS_CLIP1 - num
end 



--crossshairs
if CLIENT then
	//local ch = crosshaircolor_cmd:GetString()
	local ch, crosshaircolor
	local dual = dual or false
	function SWEP:DrawHUD()
		if !self.CrossHairIronsight and self.Weapon:GetNetworkedBool( "Ironsights" ) then
			local pppp = Color(255,255,255,200)
			surface.SetDrawColor( pppp )
			surface.DrawRect( ScrW() / 2.0 -1, ScrH() / 2.0 -1, 2, 2)
		return
		end
		
		local ch = self.Owner:GetInfo("rcs_crosshaircolor")
		if !ch then //or (ch != "0" and ch != "1" and ch != "2" and ch != "3" and ch != "4" and ch != "5" and ch != "6" and ch != "7" and ch != "8" and ch != "9") then
		//	Msg("0 = None, 1 = Green, 2 = Cyan, 3 = Red, 4 = White, 5 = Black, 6 = Pink, 7 = Brown, 8 = Yellow, 9 = Dual\n")
			CreateClientConVar( "rcs_crosshaircolor", "2", true, true )
		//	RunConsoleCommand("rcs_crosshaircolor","2")
		end
		
		if ch == "0" then
			crosshaircolor = Color(0, 200, 215, 0)
			
		elseif ch == "1" then
			crosshaircolor = Color(50, 255, 0, 200)
			
		elseif ch == "2" then
			crosshaircolor = Color(0, 200, 215, 200)
			
		elseif ch == "3" then
			crosshaircolor = Color(255, 0, 50, 200)
			
		elseif ch == "4" then
			crosshaircolor = Color(255, 255, 255, 200)
			
		elseif ch == "5" then
			crosshaircolor = Color(0, 0, 0, 200)
			
		elseif ch == "6" then
			crosshaircolor = Color(255, 110, 180, 200)
			
		elseif ch == "7" then
			crosshaircolor = Color(139, 69, 19, 200)
			
		elseif ch == "8" then
			crosshaircolor = Color(255, 255, 0, 200)
			
		elseif ch == "9" then
			crosshaircolor = Color(255, 255, 255, 200)
			
			dual = true
		else
			crosshaircolor = Color(50, 255, 0, 200)
		end
		if ch != "9" then
			dual = false
		end
		local vel = self.Owner:GetVelocity()
		local crosshairsize, ch, lawlhandle, x, y, scale, LastShootTime, gap, length
		crosshairsize = self.Weapon:GetNetworkedInt("Crosshair")
		ch = self.Weapon:GetNetworkedInt("curhandle")
		if ch > CurTime() then
			lawlhandle = (ch - CurTime())*4
		else
			lawlhandle = 0
		end


		
		
		scale = 10 * crosshairsize
		
		-- Scale the size of the crosshair according to how long ago we fired our weapon
		LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
		scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
		
		surface.SetDrawColor( crosshaircolor )
		if lawlhandle < 0 then lawlhandle = 0 end
		-- Draw an awesome crosshair
		local x,y
		x = ScrW() / 2.0 
		y = ScrH() / 2.0 
		local velx, vely, velz
		velx = vel.x
		vely = vel.y
		velz = vel.z
		if velx < 0 then
			velx = -1*velx
		end
		if vely < 0 then
			vely = -1*vely
		end
		if velz < 0 then
			velz = -1*velz
		end
		gap = (20 * scale) + lawlhandle + (velx+vely+velz)/20
		length = gap + (20 * scale) + lawlhandle/2
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
		if dual == true then
			surface.SetDrawColor( 0,0,0,200 )
			surface.DrawLine( x - length, y+1, x - gap, y+1 )
			surface.DrawLine( x + length, y-1, x + gap, y-1 )
			surface.DrawLine( x+1, y - length, x+1, y - gap )
			surface.DrawLine( x-1, y + length, x-1, y + gap )
		end
	end
	
	
	
	/* OLD CONCOMMAND FOR CROSSHAIR COLOR
	local function RCSCrosshaircolor(pl,cmd,args)
		if tonumber(args[1]) == 0 then
			crosshaircolor = Color(0, 200, 215, 0)
		elseif tonumber(args[1]) == 1 then
			crosshaircolor = Color(50, 255, 0, 200)
		elseif tonumber(args[1]) == 2 then
			crosshaircolor = Color(0, 200, 215, 200)
		elseif tonumber(args[1]) == 3 then
			crosshaircolor = Color(255, 0, 50, 200)
		elseif tonumber(args[1]) == 4 then
			crosshaircolor = Color(255, 255, 255, 200)
		elseif tonumber(args[1]) == 5 then
			crosshaircolor = Color(0, 0, 0, 200)
		elseif tonumber(args[1]) == 6 then
			crosshaircolor = Color(255, 110, 180, 200)
		elseif tonumber(args[1]) == 7 then
			crosshaircolor = Color(139, 69, 19, 200)
		elseif tonumber(args[1]) == 8 then
			crosshaircolor = Color(255, 255, 0, 200)
		elseif tonumber(args[1]) == 9 then
			crosshaircolor = Color(255, 255, 255, 200)
			dual = true
		else
			Msg("0 = None, 1 = Green, 2 = Cyan, 3 = Red, 4 = White, 5 = Black, 6 = Pink, 7 = Brown, 8 = Yellow, 9 = Dual\n")
		end
		if !tonumber(args[1]) then return end
		if tonumber(args[1]) < 9 then
			dual = false
		end
	end
	concommand.Add ("rcs_crosshaircolor", RCSCrosshaircolor)
	*/
end

--100% Devenger's code below
local function SimilarizeAngles (ang1, ang2) --this function makes angle-play a little easier on the mind, damn the overhead I say
	ang1.y = math.fmod (ang1.y, 360)
	ang2.y = math.fmod (ang2.y, 360)
	if math.abs (ang1.y - ang2.y) > 180 then
		if ang1.y - ang2.y < 0 then
			ang1.y = ang1.y + 360
		else
			ang1.y = ang1.y - 360
		end
	end
end

local function ReduceScopeSensitivity (uCmd)
	if LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() then
		local newAng = uCmd:GetViewAngles()
		if LastViewAng then
			SimilarizeAngles (LastViewAng, newAng)
			local diff = newAng - LastViewAng
			diff = diff * (LocalPlayer():GetActiveWeapon().MouseSensitivity or 1)
			uCmd:SetViewAngles (LastViewAng + diff)
		end
	end
	LastViewAng = uCmd:GetViewAngles()
end

hook.Add ("CreateMove", "RSS", ReduceScopeSensitivity)
