include( "shared.lua" )

ENT.Mat = Material( "sprites/redglow1" )
ENT.Mat2 = Material( "cable/redlaser" )
ENT.isactive = 1
function ENT:Initialize()
	self.timeleft_cl = CurTime() + 35
	timer.Simple(1, function() self:Beep_cl() end)
end
function ENT:Beep_cl()
	if !self.isactive then return end
	local btimeleft_cl = (self.timeleft_cl-CurTime())/15
	timer.Simple(btimeleft_cl, function() if self then self:Beep_cl() end end)
	local beeplight = DynamicLight( self:EntIndex() )
	if ( beeplight ) then
		beeplight.Pos = self:GetPos()
		beeplight.r = 255
		beeplight.g = 0
		beeplight.b = 0
		beeplight.Brightness = 6
		beeplight.Size = 1000
		beeplight.Decay = 1000
		beeplight.DieTime = CurTime() + 0.15
	end 
end

local function RCSC4Active(um)
	self.isactive = um:ReadString()
end
	-- hook it
usermessage.Hook( "RCSC4:Active", RCSC4Active )

function ENT:Draw( )
    if not self.BurnSound then
        self.BurnSound = CreateSound( self, Sound( "ambient/fire/fire_small_loop1.wav" ) )
    end
    local bone, n, dlight
    self:DrawModel( )
    
    --Create a red sprite here for the wick's burning
    
    bone = self:GetAttachment( self:LookupAttachment( "wick" ) )
    
    render.SetMaterial( self.Mat )
    
    --Draw 'POINT THIS DIRECTION TO SAVE FACE' sprite where the wires cross
    render.DrawSprite( self:LocalToWorld( Vector( -0.5, 1, 2 ) ), 4, 4, Color( 255, 255, 255, 255 ) )

    if self:GetNWFloat( "Defuse", 1 ) < 1 then
        n = math.random( 2, 6 )
    
        render.DrawSprite( bone.Pos, n, n, Color( 255, 255, 255, 255 ) )
    
        dlight = DynamicLight( self:EntIndex( ) ) 
    
        if dlight then 
            dlight.Pos = bone.Pos
            dlight.r = 255
            dlight.g = 0
            dlight.b = 0 
            dlight.Brightness = 2
            dlight.Decay = math.random( 6, 8 ) / 10 * 5
            dlight.Size = n
            dlight.DieTime = CurTime( ) + 1
        end
        
        self.BurnSound:PlayEx( .5, 170 )
    else
        self.BurnSound:Stop( )
    end
    
    --Always glow yellow
    dlight = DynamicLight( self:EntIndex( ) )
    
    if dlight then
        dlight.Pos = self:GetPos( ) + self:GetAngles( ):Up( ) * 4
        dlight.r = 255
        dlight.g = 255
        dlight.b = 0
        dlight.Brightness = 4
        dlight.Decay = 30
        dlight.Size = 12
        dlight.DieTime = CurTime( ) + 1
    end
end

function ENT:OnRemove( )
    self.BurnSound:Stop( )
end
