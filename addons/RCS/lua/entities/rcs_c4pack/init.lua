AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize( )
	local phys 
	self:SetModel( "models/weapons/w_c4_planted.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.timeleft = CurTime() + 35
	self.Active = true
	self.Refuse = true
	util.PrecacheSound( "weapons/c4/c4_beep1.wav" )
	util.PrecacheSound( "weapons/c4/c4_plant.wav" )
	self:EmitSound(Sound("weapons/c4/c4_plant.wav"))
	phys = self:GetPhysicsObject( )
	timer.Simple(1, function() self:Beep() end)
	if phys:IsValid( ) then
		phys:Wake( )
		phys:SetMass( 5 )
		phys:EnableGravity( true )
		phys:EnableDrag( true )
	end
	self.Entity.CollisionGroup = COLLISION_GROUP_NONE -- so the planter isn't stuck in it and it liek WTF
	
end

function ENT:Beep()
	if !self.Active then return end
	local btimeleft = (self.timeleft-CurTime())/15
	self:EmitSound(Sound("weapons/c4/c4_beep1.wav"))
	timer.Simple(btimeleft, function() if self then self:Beep() end end)
end
function ENT:Use( pl )
	if !self.Used then
		self.Used = 1
		self.defuser = pl
		pl.defusetimeleftrcsc4= 5 + CurTime()
		pl.defusingrcsc4 = 1
		umsg.Start( "ISDEFUSING", pl )
				umsg.String( 1 )
		umsg.End()
		umsg.Start( "DEFUSETIME", pl )
				umsg.String( 5 + CurTime() )
		umsg.End()
		
	end
end

function ENT:Explode( )        
	local i, exp, fire, dist, n, init, dir, res, pos
        
	init = self:GetPos( )
	dir = self:GetAngles( ):Up( )
	dist = 0
        
	for i = 1, self.TotalExplosions do
		res = util.TraceLine{ start = init, endpos = init + dist * ( dir + VectorRand( ) ), filter = self }
            
		pos = res.HitPos
            
		dist = i * 15
            
		exp = ents.Create( "env_physexplosion" )
			exp:SetPos( pos )
			exp:SetKeyValue( "inner_radius" , 000 )
			exp:SetKeyValue( "magnitude"    , 300 )
			exp:SetKeyValue( "spawnflags"   , 026 )
			exp:SetKeyValue( "radius"       , 000 )
		exp:Spawn( )
            
		exp:SetOwner( self )
            
		exp:Fire( "explode", "", math.Rand( .02, .4 ) )
		exp:Fire( "kill", "", 1 )

		if math.random( 10 ) > 7 then
			exp = ents.Create( "env_explosion" )
				exp:SetPos( pos )
				exp:SetKeyValue( "imagnitude"    , 100 )
			exp:Spawn( )
				exp:SetOwner( self )
				exp:Fire( "explode", "", math.Rand( .02, .4 ) )
				exp:Fire( "kill", "", 1 )
		end

		if math.random( 10 ) > 6 then
			fire = ents.Create( "env_fire" )
				fire:SetPos( pos )
				fire:DropToFloor( )
				fire:SetKeyValue( "StartDisabled"   , 000 )
				fire:SetKeyValue( "damagescale"     , 001 )
				fire:SetKeyValue( "fireattack"      , 002 )
				fire:SetKeyValue( "firesize"        , 128 )
				fire:SetKeyValue( "spawnflags"      , 142 )
				fire:SetKeyValue( "iginitonpoint"   , 000 )
				fire:SetKeyValue( "health"          , 030 )
			fire:Spawn( )
               
			fire:Fire( "StartFire", "", math.Rand( .3, 2 ) )
		end
	end
	self:Remove( )
end

function ENT:OnTakeDamage( info )
    if info and self:IsValid( ) then
        if info:IsExplosionDamage( ) then
            self:Explode( )
        end
    end
end

function ENT:Think( )
    
    if self.Active and self.timeleft - 1 <= CurTime() then --the -5 is for at the end it makes a solid red pulse and we don't want that do we? (and it might crash the game for those lower-end computers)
		self:Explode( )
		self.Active = false
    end
    if !self.Active and !self.sendit then
		self.sendit = true
		umsg.Start("RCSC4:Active", self)
			umsg.String( 0 )
		umsg.End()
	end
	if self.Used then
		if not self.defuser:KeyDown( IN_USE) then
			self.Used = 0
			self.defuser.defusingrcsc4 = 0
			self.defuser.defusetimeleftrcsc4 = 0
			umsg.Start( "ISDEFUSING", self.defuser )
				umsg.String( 0 )
			umsg.End()
			umsg.Start( "DEFUSETIME", self.defuser )
				umsg.String( 0 )
			umsg.End()
			self.defuser = nil
		elseif self.defuser.defusetimeleftrcsc4 <= CurTime() then
			self.Used = 0
			self.defuser.defusingrcsc4 = 0
			self.defuser.defusetimeleftrcsc4 = 0
			umsg.Start( "ISDEFUSING", self.defuser )
				umsg.String( 0 )
			umsg.End()
			umsg.Start( "DEFUSETIME", self.defuser )
				umsg.String( 0 )
			umsg.End()
			self.defuser = nil
			self.Active = false
		end
	end
end

function ENT:StartTouch( ent ) 	end
function ENT:OnRemove( )	end
