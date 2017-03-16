if (SERVER) then
	AddCSLuaFile( "shared.lua" )
		local possibleprimaries = {
		"rcs_awp",
		"rcs_ak47",
		"rcs_m4a1",
		"rcs_aug",
		"rcs_sg552",
		"rcs_sg550",
		"rcs_g3sg1",
		"rcs_scout",
		"rcs_galil",
		"rcs_famas",
		"rcs_tmp",
		"rcs_mac10",
		"rcs_mp5",
		"rcs_ump",
		"rcs_p90",
		"rcs_m249",
		"rcs_m3",
		"rcs_xm1014"
		}
		local possiblesecondaries = {
		"rcs_deagle",
		"rcs_beretta",
		"rcs_elites",
		"rcs_usp",
		"rcs_p228",
		"rcs_glock",
		"rcs_57"
		}
	local function HasWep(pl, wep)
	
	end
	function ENT:SpawnFunction( plr, tr )

		if not tr.Hit then return end
		
		local ent = ents.Create( self.Classname )
		ent:SetPos( tr.HitPos + tr.HitNormal * 24 )
		ent:Spawn()
		ent:Activate()	
		ent:SetVictim( plr )
		
		return ent

	end
	
	function ENT:Initialize()
		self.Timer = CurTime()
		if !self.WModel then
			self.Entity:SetModel("models/weapons/w_rif_ak47.mdl")
			self.WModel = "models/weapons/w_rif_ak47.mdl"
		else
			self.Entity:SetModel(self.WModel)
		end
		if !self.SWEP then
			self.SWEP = "rcs_ak47"
		end
		if !self.AmmoType then
			self.AmmoType = "smg1"
		end
		if !self.Reserve then
			self.Reserve = 0
		end
		if self.AmmoType == "smg1" or self.AmmoType == "ar2" or self.AmmoType == "buckshot" then
			self.Typee = "prim"
		end
		if self.AmmoType == "pistol" or self.AmmoType == "357" then
			self.Typee = "sec"
		end
		self.Entity:PhysicsInit( SOLID_VPHYSICS )
		self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
		self.Entity:SetSolid( SOLID_VPHYSICS )
		self.Entity:DrawShadow( false )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
	local thing = 0
	function ENT:Think()
	end
	function ENT:OnTakeDamage()
	end
	ENT.Timer = 0
	function ENT:Use(pl)
		local curswep = self.SWEP
		if (!pl:IsPlayer() or self.Timer + .5 > CurTime()) or pl.team > 2 then return end
		//if ((self.AmmoType == "smg1" or self.AmmoType == "buckshot" or self.AmmoType == "ar2") and pl.HasPrimary) or ((self.AmmoType == "pistol" or self.AmmoType == "357") and pl.HasSecondary) then return end
		local ammo, model, clip, reserve, swep, dude, wep
		dude = false
		if self.AmmoType == "smg1" or self.AmmoType == "ar2" or self.AmmoType == "buckshot" then
			self.Typee = "prim"
		end
		if self.AmmoType == "pistol" or self.AmmoType == "357" then
			self.Typee = "sec"
		end
		local elites, lclip, rclip, hasprim, hassec
		elites = false
		hasprim = false
		hassec = false
		for _, weps in pairs (pl:GetWeapons()) do
			for _, poss in pairs(possibleprimaries) do
				if ""..weps:GetClass().."" == poss then
					hasprim = true
					Msg("has prim\n")
				end
			end
			for _, poss in pairs(possiblesecondaries) do
				if ""..weps:GetClass().."" == poss then
					hassec = true
					Msg("has sec\n")
				end
			end
			if self.SWEP == "rcs_beretta" and weps:GetClass() == self.SWEP then
				Msg("hasB\n")
				curswep = "rcs_elites"
				pl:SelectWeapon("rcs_beretta")
				local dur = pl:GetActiveWeapon()
				lclip = dur:Clip1()
				rclip = self.Clip
				self.Clip = dur:Clip1() + self.Clip
				dur:Remove()
				elites = true
				hassec = false
			end
		end
		
	
		for _, weps in pairs (possibleprimaries) do
			if hasprim == true and self.SWEP == weps then
				Msg("Already has primary, cannot pickup primary weapon\n")
				return --[[false
				Swep = pl.PrimaryWeapon
				ammo = Swep.Primary.Ammo
				model = Swep.WorldModel
				clip = Swep:Clip1()
				reserve = pl.GetAmmoCount(ammo)
				swep = Swep.NameOfSWEP
				Swep:Remove()
				dude = true]]
			elseif self.SWEP == weps and pl.IsHostage and pl.IsHostage == true then
				return
			end
		end

		for _, weps in pairs (possiblesecondaries) do
			if hassec == true and self.SWEP == weps then
				Msg("Already has secondary, cannot pickup secondary weapon\n")
				return --[[false
				Swep = pl.SecondaryWeapon
				ammo = Swep.Primary.Ammo
				model = Swep.WorldModel
				clip = Swep:Clip1()
				reserve = pl:GetAmmoCount(ammo)
				swep = Swep.NameOfSWEP
				Swep:Remove()
				dude = true]]
			elseif curswep == "rcs_elites" and pl.IsHostage and pl.IsHostage == true then return
			end
		end
		if pl.IsHostage and pl.IsHostage == true then
			curswep = curswep.."_hostage"
		end
		Msg(curswep.."\n")
		pl:Give(curswep)
		pl:SelectWeapon(""..curswep.."")
		wep = pl:GetActiveWeapon()
		wep:SetClip1(self.Clip)
		wep.RCS_CLIP1 = self.Clip
		pl:GiveAmmo(self.Clip,self.AmmoType)
		self.Timer = CurTime()
		self.Entity:Remove()
		if elites == true then
			wep.RAmmo = rclip
			wep.LAmmo = lclip
		end
		--[[return "what"
		if self.Clip then
			self.Clip = clip
		end
		self.AmmoType = ammo
		self.Reserve = reserve
		self.SWEP = swep
		self.WModel = model
		self.Entity:SetModel(model)
		if self.AmmoType == "smg1" or self.AmmoType == "ar2" or self.AmmoType == "buckshot" then
			self.Typee = "prim"
		elseif self.AmmoType == "pistol" or self.AmmoType == "357" then
			self.Typee = "sec"
		end]]
	end
	function ENT:StartTouch()
	end
	function ENT:EndTouch()
	end
	function ENT:Touch()
	end
end

if (CLIENT) then
	function ENT:Draw()
		self.Entity:DrawModel()
	end
	function ENT:IsTranslucent()
		return true
	end
end

ENT.Type = "anim"
function ENT:OnRemove() end
function ENT:PhysicsUpdate() end
local function awp(pl)
	if !pl:IsAdmin() then return end
	local tr = pl:GetEyeTrace()
	local dude = ents.Create("rcs_droppedweapon")
	dude:SetPos(tr.HitPos+Vector(0,0,10))
	dude:Spawn()
	dude.SWEP = "rcs_awp"
	dude.WModel = "models/weapons/w_snip_awp.mdl"
	dude:SetModel("models/weapons/w_snip_awp.mdl")
	dude.Clip = 10
end
concommand.Add("spawn_awp", awp)