if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "knife"

end

if ( CLIENT ) then
	SWEP.PrintName			= "Tactical Knife"	
	SWEP.Author				= "cheesylard"
	SWEP.DrawAmmo			= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "j"

	SWEP.NameOfSWEP			= "rcs_knife" --always make this the name of the folder the SWEP is in.
	killicon.AddFont( SWEP.NameOfSWEP, "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.IronSightsPos = Vector (-15.6937, -10.1535, -1.0596)
SWEP.IronSightsAng = Vector (46.9034, 9.0593, -90.2522)

SWEP.Category				= "RealCS"
SWEP.Base					= "rcs_base"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl" 

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.CrossHairIronsight		= true --does crosshairs when ironsights are on

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Damage			= 10
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage		= 60
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/knife/knife_hitwall1.wav")
SWEP.FleshHit1 				= ("weapons/knife/knife_hit1.wav")
SWEP.FleshHit2 				= ("weapons/knife/knife_hit2.wav")
SWEP.FleshHit3 				= ("weapons/knife/knife_hit3.wav")
SWEP.FleshHit4 				= ("weapons/knife/knife_hit4.wav")
SWEP.SuperFleshHitSound		= Sound("weapons/knife/knife_stab.wav")
SWEP.CantIdle				= false

function SWEP:RCSAttack2()	
	if ( self.ShootafterTakeout > CurTime() ) then return end		
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.1 )
	
	local phtr = self.Owner:GetEyeTrace()
	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local ph = phtr.Entity:GetPhysicsObject()
	
	if (self.Owner:GetShootPos() - tr.HitPos):Length() < 75 then
		if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or string.find(tr.Entity:GetClass(),"prop_ragdoll") or tr.Entity.MatType == "MAT_GLASS" then
			self.Weapon:EmitSound( self.SuperFleshHitSound )
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = self.Owner:GetAimVector()
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 5
					bullet.Damage = 50
				self.Owner:FireBullets(bullet) 
		
		else --if you dont hit an npc, player or ragdoll
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal) --leaves a cutmark
			self.Weapon:EmitSound(self.WallSound,100,math.random(95,110)) --plays sound
			if (self.Owner:GetPos() - tr.HitPos):Length() > 75 then return end 
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			
			if not tr.HitWorld  and not string.find(tr.Entity:GetClass(),"prop_static") then
				ph:ApplyForceCenter(self.Owner:GetAimVector()*5000)
			end
		
		end

	else --if you miss
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	end
	timer.Create( "idletimer", 1.2, 1, function(this) this:IdleAnimation(true); this.CantIdle = true end, self)  
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) --3rd Person Animation
	return false --when you use this attack the ironsights still don't go away
end

function SWEP:RCSThink()
	return "keepiron"
end

function SWEP:DIck(lol)
	//self.Owner:PrintMessage(HUD_PRINTTALK,lol)
end
function SWEP:IdleAnimation(a)
	if self.CantIdle == true and !a then return end
	self.CantIdle = false
	timer.Simple( 12, function(this) this:IdleAnimation(); this:DIck("IDLEAGAIN") end, self)  
	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	self:DIck("idleanimation")

end


function SWEP:PrimaryAttack()

	if ( self.ShootafterTakeout > CurTime() ) then return end		
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
	
	local phtr = self.Owner:GetEyeTrace()
	local trace = util.GetPlayerTrace(self.Owner)
 	local tr = util.TraceLine(trace)
	local ph = phtr.Entity:GetPhysicsObject()

	if (self.Owner:GetPos() - tr.HitPos):Length() < 75 then
	
		
		
		if tr.Entity:IsPlayer() or string.find(tr.Entity:GetClass(),"npc") or string.find(tr.Entity:GetClass(),"prop_ragdoll") or tr.Entity.MatType == "MAT_GLASS" then
		
			if self.hit == 1 then
				self.Weapon:EmitSound( self.FleshHit1 )
				self.hit = 2
				
			elseif self.hit == 2 then
				self.Weapon:EmitSound( self.FleshHit2 )
				self.hit = 3
				
			elseif self.hit == 3 then
				self.Weapon:EmitSound( self.FleshHit3 )
				self.hit = 4
				
			else
				self.Weapon:EmitSound( self.FleshHit4 )
				self.hit = 1
			end
			
			self.Owner:SetAnimation( PLAYER_ATTACK1 );
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
					bullet = {}
					bullet.Num    = 1
					bullet.Src    = self.Owner:GetShootPos()
					bullet.Dir    = self.Owner:GetAimVector()
					bullet.Spread = Vector(0, 0, 0)
					bullet.Tracer = 0
					bullet.Force  = 5
					bullet.Damage = 10
				self.Owner:FireBullets(bullet) 
				
				
		else
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			self.Weapon:EmitSound(self.WallSound,100,math.random(95,110))
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			if not tr.HitWorld and not string.find(tr.Entity:GetClass(),"prop_static") then
				if SERVER then ph:ApplyForceCenter(self.Owner:GetAimVector()*5000) end
			end
		end
	
	
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		
	end
	timer.Create( "idletimer", 1.2, 1, function(this) this:IdleAnimation(true); this.CantIdle = true end, self)  

	self.Owner:SetAnimation( PLAYER_ATTACK1 ) --3rd Person Animation

	
end

function SWEP:Reload()
	return false

end

function SWEP:OnRemove()
	timer.Remove("idletimer")
	self.CantIdle = true
return true
end

function SWEP:Holster()
	timer.Remove("idletimer")
	self.CantIdle = true
	return true
end

SWEP.ShootafterTakeout = 0

function SWEP:Deploy()
	self:DefaultDeploy(0.8)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:EmitSound( "weapons/knife/knife_deploy1.wav" );
	timer.Create( "idletimer", 0.9, 1, function(this) this:IdleAnimation(true); this.CantIdle = true end, self)  
	return true
end

function SWEP:ShootEffects()

end

