if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "ar2"
	

end

if ( CLIENT ) then
	SWEP.PrintName			= "C4 Explosive"	
	SWEP.Author				= "cheesylard"
	SWEP.Slot				= 4
	SWEP.ViewModelFlip		= false
	--Just fucking around
	--[[function SWEP:DrawHUD()
		for i = 1,14 do
			local lorkeo = math.random(0,5)
			if lorkeo == 0 then
				penor = "LOLOLOL"
			elseif lorkeo == 1 then
				penor = "BOOM HEADSHOT"
			elseif lorkeo == 2 then
				penor = "HHAHAHHAHHA"
			elseif lorkeo == 3 then
				penor = "8=======D"
			elseif lorkeo == 4 then
				penor = "asdfasdfasdf"
			elseif lorkeo == 5 then
				penor = "no u"
			end
			
			surface.SetDrawColor(math.random(0,255), math.random(0,255), math.random(0,255), 255)
			surface.DrawRect(math.random(1,ScrW()), math.random(1,ScrH()), math.random(1,ScrW()), math.random(1,ScrH()))
			if penor == "no u" then
				draw.DrawText(penor, "OMGARIALRUSERIOUSS", math.random(1,ScrW()), math.random(1,ScrH()), Color(math.random(0,255), math.random(0,255), math.random(0,255), 255),TEXT_ALIGN_CENTER)
			else
				draw.DrawText(penor, "OMGARIALRUSERIOUS", math.random(1,ScrW()), math.random(1,ScrH()), Color(math.random(0,255), math.random(0,255), math.random(0,255), 255),TEXT_ALIGN_CENTER)
			end
		end]]
--[[		if self.defusing == 1 then
			local w, h, x, y, v, topleftoutlinex, topleftx, topleftoutliney, toplefty, dp
			w = surface.ScreenWidth( )
			h = surface.ScreenHeight( )
			x = h/2.5
			y = h/40
			v = 4
			dp = (1-(self.defusetime/10))*x
		    topleftoutlinex = ((w-x)-v)/2
			topleftx = (w-x)/2
			topleftoutliney = (((h/1.5)-y)-v)/2
			toplefty = ((h/1.5)-y)/2

		    
		    surface.SetDrawColor( 255, 200, 000, 190 )
		    surface.DrawRect( topleftx, toplefty, dp, y )
			surface.SetDrawColor( 255, 200, 000, 190 )
			surface.DrawOutlinedRect( topleftoutlinex, topleftoutliney, x+v, y+v )
		end
	end
	local function SetDEFUSETIME(um)
		SWEP.defusetime = um:ReadString()
	end
	-- hook it
	usermessage.Hook( "DEFUSETIME", GetClientGGLevel )
	local function GetISITDEFUSING(um)
		SWEP.defusing = um:ReadString()
	end
	-- hook it
	usermessage.Hook( "ISDEFUSING", GetISITDEFUSING )
	usermessage.Hook( "DEFUSETIME", SetDEFUSETIME )
]]

	--[[function SWEP:Initialize()
		surface.CreateFont("Impact", ScreenScale( 30 ), 400, true, false, "OMGARIALRUSERIOUS")
		surface.CreateFont("Impact", ScreenScale( 60 ), 400, true, false, "OMGARIALRUSERIOUSS")
	end]]
end
SWEP.Base = "rcs_base"
SWEP.Category = "RealCS"

--I'm still testing it
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.ViewModel				= "models/weapons/v_c4.mdl"
SWEP.WorldModel				= "models/weapons/w_c4.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Secondary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.defusetime = 0
SWEP.planting = 0
SWEP.timetoplant = 0
function SWEP:PrimaryAttack()
	if ( self.ShootafterTakeout > CurTime() ) then return end
	if !self.Owner:IsOnGround() then
		self.Owner:PrintMessage(HUD_PRINTCENTER, "You need to be on the ground dumbfuck")
		return false
	else
		self.timetoplant = 2.33 + CurTime()
		self.planting = 1
	end
	self.Primary.Automatic = false
end
function SWEP:Think()
	if self.timetoplant <= CurTime() then
		if self.planting == 1 then
			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.planting = 2
			self.timetoplant = CurTime() + 30/25
		elseif self.planting == 2 then
			local owner = self.Owner
			local c4 = ents.Create( "rcs_c4pack" )
				c4:SetPos( owner:GetPos() )
				c4:SetAngles( self.Owner:GetForward())// + Angle( 0, 0,0 ) )
			c4:Spawn( )
			c4:SetMoveType( MOVETYPE_NONE )
			constraint.NoCollide( c4, owner, 0, 0 )
			self.planting = 0
			self.timetoplant = 0
			self.Weapon:Remove()
		end
	end
	
	if self.planting and not self.Owner:KeyDown(IN_ATTACK) then
		self.planting = 0
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end
end
