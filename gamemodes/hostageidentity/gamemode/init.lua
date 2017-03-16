local COUNTRY_UK = 1
local COUNTRY_US = 2
local COUNTRY_FRANCE = 3
local COUNTRY_BELGIUM = 4
local COUNTRY_SWITZ = 5
local COUNTRY_AUSTRIA = 6
local COUNTRY_GERMANY = 7
local COUNTRY_ISRAEL = 8
--TODO: Add support for dropping elites when you die
--------------------------------------------------------------------------
/*
DISCLAIMER:

This is a HEAVILY modified Prop Hunt v1.01. So there.
It's the one which has no console commands and just the base code and stuff.

The only reason why I took prop hunt is because it already had the round system
put In, so I figured it would save me a lot of Time instead of coding a whole
round system when I had it already right here.

Hopefully AMT is cool with this.
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hacky.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "concommands.lua" )
AddCSLuaFile( "umsg.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")
include("map_cycle.lua")
include("hacky.lua")
----------------------------------------------------------------------------
GM.InvisStatics = {}
GM.SpawnWeaponsCrap = {}
local terrorist_spawns, counterterrorist_spawns, hostage_spawns, hostages, numhostages, end_time, prepping
end_time = 0
hostages = {}
--Send the required files to the client

resource.AddFile("resource/fonts/Alba Super.ttf" )
resource.AddFile("resource/fonts/Urban Sketch.ttf" )
resource.AddFile("resource/fonts/GREENPIL.ttf" )
resource.AddFile("sound/gungame/cs/letsgo.wav")
resource.AddFile("sound/gungame/cs/locknload.wav")
resource.AddFile("sound/gungame/cs/moveout.wav")
resource.AddFile("sound/gungame/cs/terwin.wav")
resource.AddFile("sound/gungame/cs/ctwin.wav")
resource.AddFile("sound/gungame/cs/rounddraw.wav")
resource.AddFile("materials/hostident/bodymap/arm.vtf")
resource.AddFile("materials/hostident/bodymap/leg.vtf")
resource.AddFile("materials/hostident/bodymap/head.vtf")
resource.AddFile("materials/hostident/bodymap/torso.vtf")
resource.AddFile("materials/hostident/bodymap/arm_r.vtf")
resource.AddFile("materials/hostident/bodymap/leg_r.vtf")
resource.AddFile("materials/hostident/bodymap/arm.vmt")
resource.AddFile("materials/hostident/bodymap/leg.vmt")
resource.AddFile("materials/hostident/bodymap/head.vmt")
resource.AddFile("materials/hostident/bodymap/torso.vmt")
resource.AddFile("materials/hostident/bodymap/arm_r.vmt")
resource.AddFile("materials/hostident/bodymap/leg_r.vmt")
resource.AddFile("materials/hostident/hud/45bul.vmt")
resource.AddFile("materials/hostident/hud/Tselect.vmt")
resource.AddFile("materials/hostident/hud/CTselect.vmt")
resource.AddFile("materials/hostident/hud/SPECselect.vmt")
resource.AddFile("materials/hostident/hud/45bul.vtf")
resource.AddFile("materials/hostident/hud/Tselect.vtf")
resource.AddFile("materials/hostident/hud/CTselect.vtf")
resource.AddFile("materials/hostident/hud/SPECselect.vtf")
resource.AddFile("materials/hostident/hud/closewindow.vmt")
resource.AddFile("materials/hostident/hud/closewindow.vtf")
local dir2 = "hostident/flags/"
resource.AddFile(dir2.."UK.vtf")
resource.AddFile(dir2.."US.vtf")
resource.AddFile(dir2.."FRANCE.vtf")
resource.AddFile(dir2.."BELGIUM.vtf")
resource.AddFile(dir2.."SWITZ.vtf")
resource.AddFile(dir2.."AUSTRIA.vtf")
resource.AddFile(dir2.."GERMANY.vtf")
resource.AddFile(dir2.."ISRAEL.vtf")
resource.AddFile(dir2.."UK.vmt")
resource.AddFile(dir2.."US.vmt")
resource.AddFile(dir2.."FRANCE.vmt")
resource.AddFile(dir2.."BELGIUM.vmt")
resource.AddFile(dir2.."SWITZ.vmt")
resource.AddFile(dir2.."AUSTRIA.vmt")
resource.AddFile(dir2.."GERMANY.vmt")
resource.AddFile(dir2.."ISRAEL.vmt")
--Include needed lua files
if file.Exists("../gamemodes/hostageidentity/gamemode/custompropsandmodels/"..game.GetMap()..".lua") then
	include("custompropsandmodels/"..game.GetMap()..".lua")
else
	function GM:SpawnWeapons() --prevents nil value
	end
end
if file.Exists("../gamemodes/hostageidentity/gamemode/hostagespawns/"..game.GetMap()..".lua") then
	include("hostagespawns/"..game.GetMap()..".lua")
end
--Unused functions
function GM:ShowTeam() end
function GM:PlayerUse() return true end
function GM:ShowSpare1() end
function GM:ShowSpare2() end
function GM:PlayerLoadout(pl)
	if pl.CountryChange then
		pl.Country = pl.CountryChange
		pl.CountryChange = nil
	end
	local ppossiblesecondaries = {
		"rcs_deagle",
		"rcs_beretta",
		"rcs_elites",
		"rcs_usp",
		"rcs_p228",
		"rcs_glock",
		"rcs_57"
	}
	local ppossibleprimaries = {
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
	local ctprim = {
	"rcs_awp",
	"rcs_m4a1",
	"rcs_famas",
	"rcs_p90",
	"rcs_sg550",
	"rcs_aug",
	"rcs_g3sg1",
	"rcs_galil"
	}
	local ctsec = {
	"rcs_glock",
	"rcs_beretta",
	"rcs_usp",
	"rcs_p228",
	"rcs_p228",
	"rcs_usp",
	"rcs_usp",
	"rcs_deagle"
	}
	if (pl.IsHostage != true) then
		pl:Give("rcs_knife");
		if math.random(2) == 1 then
			pl:Give("rcs_hegrenade");
		end
		local hassec = false
		for _,wep in pairs(ppossiblesecondaries) do
			for _,has in pairs(pl:GetWeapons()) do
				if has:GetClass() == wep then hassec = true end
			end
		end
		local hasprim = false
		for _,wep in pairs(ppossibleprimaries) do
			for _,has in pairs(pl:GetWeapons()) do
				if has:GetClass() == wep then hasprim = true end
			end
		end
		if hassec == false and pl.team == 1 then
			pl:Give("rcs_beretta");
			pl:SelectWeapon("rcs_beretta");
		end
		if pl.team == 2 then
			if hassec == false then
				pl:Give(ctsec[pl.Country])
				pl:SelectWeapon(ctsec[pl.Country])
			end
			if hasprim == false then
				pl:Give(ctprim[pl.Country])
				pl:SelectWeapon(ctprim[pl.Country])
			end
		end
	end
end
function GM:EntityTakeDamage() end
function GM:PlayerNoClip(pl)
	if (pl:IsAdmin()) then
		return true;
	end
return false;
end 

	/*________________lolololololololololol_________________  <-
->	|*******************************************************| <-
->	|		blahblahblahblahblahblahblahblahblah			| <-
->	|*******************************************************| <-
->	|________________lolololololololololol________________*/

function GM:CanPlayerSuicide(pl)
	if (pl.team == 1 or pl.team == 2) and pl.IsHostage != true then
		return true
	else
		return false
	end
end

--Called when the player dies
function GM:DoPlayerDeath(Victim, Attacker, dmginfo)
	if Victim.team == 1 or Victim.team == 2 then
		Victim.team = Victim.team + 3
	end
	if (Victim.team == 2 or Victim.team == 5) and #hostages < 4 then
		//table.insert(hostages, Victim) --still working on
	end
	for _, wep in pairs(Victim:GetWeapons()) do
		if wep.NameOfSWEP != "rcs_knife" or wep.NameOfSWEP != "rcs_inventory" then
			if wep:GetClass() != "rcs_knife" && wep:GetClass() != "rcs_hegrenade" && wep:GetClass() != "rcs_inventory" && wep:GetClass() != "rcs_elites" then
				local pl = Victim
				local drop = ents.Create("rcs_droppedweapon")
				drop:SetPos(pl:GetShootPos())
				drop:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
				drop:Spawn()
				local phys = drop:GetPhysicsObject()
				phys:AddAngleVelocity(Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
				phys:ApplyForceCenter(pl:GetAimVector()*500)
				drop.WModel = wep.WorldModel
				drop:SetModel(wep.WorldModel)
				drop.Clip = wep:Clip1()
				drop.SWEP = wep:GetClass()
				wep:Remove()
			elseif wep:GetClass() == "rcs_elites" then
				local pl = Victim
				for i=1,2 do
					local drop = ents.Create("rcs_droppedweapon")
					drop:SetPos(pl:GetShootPos())
					drop:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
					drop:Spawn()
					local phys = drop:GetPhysicsObject()
					phys:AddAngleVelocity(Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
					phys:ApplyForceCenter(pl:GetAimVector()*500)
					drop.WModel = "models/weapons/w_pist_elite_single.mdl"
					drop:SetModel("models/weapons/w_pist_elite_single.mdl")
					if i == 1 then
						drop.Clip = wep.RAmmo
					else
						drop.Clip = wep.LAmmo
					end
					drop.SWEP = "rcs_beretta"
				end
				wep:Remove()
			end
		end
	end
	
	Victim.alive = 0
	Victim.spectate_time = CurTime() + 3
	Victim:CreateRagdoll()
end



--Called after all entities have been spawned
function GM:InitPostEntity()
		terrorist_spawns = ents.FindByClass("info_player_terrorist")
		counterterrorist_spawns = ents.FindByClass("info_player_counterterrorist")
		hostage_spawns = ents.FindByClass("hostage_entity")
	--Get all physics multiplayer entities so we can respawn them
	ppms_info = {}
	for _, old_ppm in pairs(ents.FindByClass("prop_physics_multiplayer","prop_physics")) do
		local ppm_info = {}
		ppm_info.model = old_ppm:GetModel()
		ppm_info.pos = old_ppm:GetPos()
		ppm_info.ang = old_ppm:GetAngles()
		table.insert(ppms_info, ppm_info)
	end
end


--Called while the player is waiting to respawn
function GM:PlayerDeathThink(pl)
	if pl.spectate_time == nil then pl.spectate_time = CurTime()+2 end
	if pl.spectate_time <= CurTime() and pl:KeyDown(IN_ATTACK || IN_ATTACK2) then pl:Spawn() else return end
end

function GM:PlayerDeath( Victim, Inflictor, Attacker )

	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
	end
	if !Attacker.team then
		Victim:AddDeaths(1)
		Victim:AddFrags(-1)
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( Victim )
		umsg.End()
		MsgAll( Victim:Nick() .. " suicided!\n" )
	return
	end
	if (Attacker.team == Victim.team or Attacker.team == Victim.team + 3 or Attacker.team + 3 == Victim.team) and Attacker != Victim and !Attacker:IsPlayer() and Attacker != "player" then
		Victim:AddDeaths(1)
		Victim:AddFrags(-1)
		umsg.Start( "PlayerKilledByPlayer" )
			umsg.Entity( Victim )
			umsg.String( Inflictor:GetClass() )
			umsg.Entity( Attacker )
		umsg.End()
		MsgAll( Attacker:Nick() .. " TKed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. ". What a douchebag.\n" )
	return
	elseif (Attacker == Victim) or !Attacker:IsPlayer() then
		Victim:AddDeaths(1)
		Victim:AddFrags(-1)
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( Victim )
		umsg.End()
		MsgAll( Attacker:Nick() .. " suicided!\n" )
	return
	end
	
	if Attacker == Victim or !Attacker:IsPlayer() or Attacker.team == Victim.team or Attacker.team == Victim.team + 3 or Attacker.team + 3 == Victim.team then
	else
		Attacker:AddFrags(1)
		Victim:AddDeaths(1)
	end

	if Inflictor:GetClass() == "env_explosion" and Attacker:IsPlayer() then
		umsg.Start( "PlayerKilledByPlayer" )
			umsg.Entity( Victim )
			umsg.String( "rcs_hegrenade" )
			umsg.Entity( Attacker )
		umsg.End()
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using rcs_hegrenade.\n" )
	return
	end
	

	if ( Attacker:IsPlayer() ) then
		umsg.Start( "PlayerKilledByPlayer" )
			umsg.Entity( Victim )
			umsg.String( Inflictor:GetClass() )
			umsg.Entity( Attacker )
		umsg.End()
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. ".\n" )
	return
	end
	
	umsg.Start( "PlayerKilled" )
		umsg.Entity( Victim )
		umsg.String( Inflictor:GetClass() )
		umsg.String( Attacker:GetClass() )
	umsg.End()
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. ".\n" )
	Victim:AddDeaths(1)
	Victim:AddFrags(-1)
end


--Called right before the player's first spawn
function GM:PlayerInitialSpawn(pl)
	pl.team = 3
	pl.Country = -1
	pl:ConCommand("TeamMenu")
	--prevent lag when you get a weapon for the first time
	if !precachedweapons then
		local weapons = {"rcs_glock"
			,"rcs_usp"
			,"rcs_p228"
			,"rcs_deagle"
			,"rcs_57"
			,"rcs_elites"
			,"rcs_m3"
			,"rcs_xm1014"
			,"rcs_tmp"
			,"rcs_mac10"
			,"rcs_mp5"
			,"rcs_ump"
			,"rcs_p90"
			,"rcs_famas"
			,"rcs_galil"
			,"rcs_ak47"
			,"rcs_scout"
			,"rcs_m4a1"
			,"rcs_aug"
			,"rcs_sg552"
			,"rcs_sg550"
			,"rcs_g3sg1"
			,"rcs_m249"
			,"rcs_awp"
			,"rcs_hegrenade"
			,"rcs_knife"
			,"rcs_droppedweapon"
			}
			for _,wep in pairs(weapons) do
				local i = ents.Create(wep)
				i:SetPos(Vector(0,0,0))
				i:SetAngles(Angle(0,0,0))
				i:Spawn()
				i:Remove()
			end
		if self.HostageSpawns and self.HostageSpawns != {} then
			for _,s in pairs(self.HostageSpawns) do
				if _ % 2 != 0 then
					local pos = s
					local ang = self.HostageSpawns[_+1]
					local spawn = ents.Create("hostage_entity")
					spawn:GetPos(pos)
					spawn:SetAngles(ang)
				end
			end
		end
		precachedweapons = true
	end
end
local rand_counterterrorist_spawn, rand_counterterrorist_spawns, rand_terrorist_spawn, rand_terrorist_spawns, rand_hostage_spawn, rand_hostage_spawns
function GM:PlayerSelectSpawn(pl)
	local chosen_spawn = nil
	
	--Try to work out the best spawn point for the player in 6 goes
	if pl.IsHostage == true then
		for a=0, 6 do
			rand_hostage_spawn = math.random(1, #hostage_spawns)
			chosen_spawn = hostage_spawns[rand_hostage_spawn]
			if chosen_spawn and chosen_spawn:IsValid() and chosen_spawn:IsInWorld() then
				table.remove(hostage_spawns, rand_hostage_spawn)
				return chosen_spawn
			end
		end
	else
		for a=0, 6 do
			if pl.team and pl.team == 2 then
				rand_counterterrorist_spawn = math.random(1, #counterterrorist_spawns)
				chosen_spawn = counterterrorist_spawns[rand_counterterrorist_spawn]
			else
				rand_terrorist_spawn = math.random(1, #terrorist_spawns)
				chosen_spawn = terrorist_spawns[rand_terrorist_spawn]
			end
			

			--Is this a valid spawn?
			if chosen_spawn and chosen_spawn:IsValid() and chosen_spawn:IsInWorld() then
				if pl.team and pl.team == 2 then
					table.remove(counterterrorist_spawns, rand_counterterrorist_spawn)
				else
					table.remove(terrorist_spawns, rand_terrorist_spawn)
				end
				return chosen_spawn
			end
		end
	end
	--Return
	return chosen_spawn
end
function GM:Random(i)
	return i[math.random(1,#i)] -- so simple, yet so awesome
end

--Called when player needs a model
function GM:PlayerSetModel(pl)
	local player_model
	if pl.teamlol == 1 or pl.team == 4 then
		player_model = "models/player/"..GAMEMODE:Random({"leet", "arctic", "phoenix", "guerilla"})..".mdl"
	elseif pl.teamlol == 2 or pl.team == 5 then
		player_model = "models/player/"..GAMEMODE:Random({"urban", "swat", "gasmask", "riot"})..".mdl"
	end
	if pl.IsHostage == true then
		player_model = "models/player/hostage/hostage_0"..math.random(1,4)..".mdl"
	end
	pl.teamlol = nil
	--Precache and set the model
	pl:SetColor(255,255,255,255)
	util.PrecacheModel(player_model)
	pl:SetModel(player_model)
end

--Called when the player takes damage
function GM:PlayerShouldTakeDamage(Victim, Attacker)
	if Victim.team == Attacker.team and gg_friendly_fire == 0 and Attacker != Victim then
		return false
	elseif Victim.team == 3 or Victim.team == 4 or Victim.team == 5 or Attacker.team == 3 or Attacker.team == 4 or Attacker.team == 5 then
		return false
	else
		return true
	end
end 

--Called when the players spawns
function GM:PlayerSpawn(pl)
	pl.alive = 1
	 --afk is not effected
	pl:UnSpectate()
	pl:SetCollisionGroup(5)
	--Decide what to do based on the team
	if pl.IsHostage == true then
		pl:SetColor(255, 255, 255, 255)		
		pl:SetSolid(SOLID_BBOX)
		pl:SetCollisionGroup(11)
		pl:SetHealth(100)
		--set player model
		GAMEMODE:SetPlayerSpeed(pl, 100, 100)
		GAMEMODE:PlayerSetModel(pl)
		//GAMEMODE:PlayerLoadout(pl)
		pl.notspectator = true
	elseif pl.team == 1 or pl.team == 2 then
		pl.teamlol = pl.team
		--Set color
		pl:SetColor(255, 255, 255, 255)		
		pl:SetSolid(SOLID_BBOX)
		pl:SetCollisionGroup(11)
		pl:SetHealth(100)
		--set player model
		GAMEMODE:SetPlayerSpeed(pl, 250, 250)
		GAMEMODE:PlayerSetModel(pl)
		GAMEMODE:PlayerLoadout(pl)
		pl.notspectator = true
		pl:GiveAmmo(1,"pistol")
		pl:GiveAmmo(1,"357")
		pl:GiveAmmo(1,"buckshot")
		pl:GiveAmmo(1,"smg1")
		pl:GiveAmmo(1,"ar2")
	else
		pl:SetColor(0, 0, 0, 0)
		pl.alive = 0
		pl:Spectate(OBS_MODE_ROAMING)
		pl:StripWeapons()
		pl:RemoveAllAmmo()
	end
	pl.originalteam = pl.team
end

function GM:ShowHelp(pl)
	pl:ConCommand("TeamMenu")
end
local gonnastrip = false
function GM:Think()
	for _, pl in pairs(player.GetAll()) do
		if gg_autoset >= 1 and gg_autoset <= 2 then
			if pl.team == 3 then
					pl.team = gg_autoset + 3
					pl:SetTeam(gg_autoset+3)
			end
		else
			gg_autoset = 0
		end
		//if !pl:SteamID() == "STEAM_0:0:13450160" then
		//	pl.IsHostage = true
		//end
		if pl:Team() != pl.team then
			pl:SetTeam(pl.team)
		end
	end

	if prepping == true and GetGlobalInt("round_start_time") + gg_PrepTime*60 <= CurTime() then
		prepping = false
		//local count = 0
		for intt, block in pairs(self.InvisStatics) do
			block:Remove()
			for k,v in pairs(self.SpawnWeaponsCrap) do
				if v == block then
					table.remove(self.SpawnWeaponsCrap, k)
				end
			end
			//count = count+1
			Msg("YEAH IT WORKS\n");
		end
		for _, pl in pairs(player.GetAll()) do
			local randsound = math.random(1,3)
			if randsound == 1 then
				pl.startsound = "gungame/cs/letsgo.wav"
			elseif randsound == 2 then
				pl.startsound = "gungame/cs/locknload.wav"
			elseif randsound == 3 then
				pl.startsound = "gungame/cs/moveout.wav"
			end
			umsg.Start( "ClientSound", pl )
			umsg.String( pl.startsound )
			umsg.End()
		end
		self.InvisStatics = {}
		if roundinprogress != 2 then 
			roundinprogress = 1
			SetGlobalInt("roundinprogress", 1)
		end
		SetGlobalInt("round_start_time", CurTime())
	end
	--Round start or end
	if ((roundinprogress == 0 and team.NumPlayers(1) + team.NumPlayers(4) >= 1 and team.NumPlayers(2) + team.NumPlayers(5) >= 1) or (team.NumPlayers(4) >= 1 and team.NumPlayers(5) >= 1)) and end_time + 3 <= CurTime() then
		GAMEMODE:StartRound()
		roundinprogress = 1
	elseif roundinprogress == 0 and ( (team.NumPlayers(1) + team.NumPlayers(4) >= 1 and team.NumPlayers(2) + team.NumPlayers(5) == 0) or (team.NumPlayers(2) + team.NumPlayers(5) >= 1 and team.NumPlayers(1) + team.NumPlayers(4) == 0)) and end_time + 3 <= CurTime() then
		GAMEMODE:NoRound()
	elseif (roundinprogress == 1 or roundinprogress == 3)and (GetGlobalInt("round_start_time") + gg_round_time * 60 <= CurTime() or team.NumPlayers(1) == 0 or team.NumPlayers(2) == 0) then
		GAMEMODE:EndRound()
	elseif roundinprogress == 2 and ((team.NumPlayers(1) + team.NumPlayers(2) <= 0) or (team.NumPlayers(1) + team.NumPlayers(4) >= 1 and team.NumPlayers(2) + team.NumPlayers(5) >= 1)) then
		GAMEMODE:EndNoRound()
	end
end

function GM:NoRound() --function where there's nobody on either team but people can still spawn and stuff
	gg_round_time = gg_round_time2
	for _,pl in pairs(player.GetAll()) do
		umsg.Start( "GG_ROUND_TIME", pl )
			umsg.Long( gg_round_time )
		umsg.End()
		pl:ConCommand("r_cleardecals");
		pl:StripWeapons();
	end
	roundinprogress = 2
	prepping = true
	gonnastrip = true
	SetGlobalInt("roundinprogress", 2)
	SetGlobalString("message", "")
	noround = true
	if self.SpawnWeaponsCrap and self.SpawnWeaponsCrap != {} then
		for _,crap in pairs(self.SpawnWeaponsCrap) do 
			if crap and crap:IsValid() then
				crap:Remove()
			end
		end
	end
	self.InvisStatics = {}
	self.SpawnWeaponsCrap = {}
	for _, guns in pairs(ents.FindByClass("rcs_droppedweapon")) do
		guns:Remove()
	end
	for k,v in pairs(ents.FindByClass("info_decal")) do
		v:Remove()
	end
	--Cleanup map
	for _, props in pairs(ents.FindByClass("prop_physics_multiplayer","prop_physics")) do
		props:Remove()
	end
	if completed_round then
		for a, ppm_info in pairs(ppms_info) do
			local new_ppm = ents.Create("prop_physics_multiplayer")
			new_ppm:SetModel(ppm_info.model)
			new_ppm:SetPos(ppm_info.pos)
			new_ppm:SetAngles(ppm_info.ang)
			new_ppm:Spawn()
		end
	end
	GAMEMODE:SpawnWeapons()
	terrorist_spawns = ents.FindByClass("info_player_terrorist")
	counterterrorist_spawns = ents.FindByClass("info_player_counterterrorist")
	hostage_spawns = ents.FindByClass("hostage_entity")
	--Select a team for each player
	for _, pl in pairs(player.GetAll()) do
		pl.gotthrough = false
		pl:UnLock()
		pl:SetNetworkedString("pl_message", "BLANK")
		pl:PrintMessage(HUD_PRINTTALK, "Press F1 to select teams\nPress E to pick up a weapon\nBind a key to dropweapon!")
	end

	for _, pl in pairs(player.GetAll()) do	
		pl:ConCommand("echo noround")
		if pl.team == 1 or pl.team == 4 then
			pl.team = 1
			pl:SetColor(255,255,255,255)
		elseif pl.team == 2 or pl.team == 5 then
			pl.team = 2
			pl:SetColor(255,255,255,255)
		else
			pl.team = 3
		end
		pl:Spawn()
	end
//IDEA FOR NEXT GAMEMDE: KIND OF LIKE BOWLING EXCEPT YOU BUILD THE PINS
	SetGlobalInt("round_start_time", CurTime() - gg_PrepTime*60)
end

function GM:EndNoRound()
	roundinprogress = 0	
	SetGlobalInt("roundinprogress", 0)
	for _, pl in pairs(player.GetAll()) do
		pl:ConCommand("echo endnoround")
		umsg.Start( "ClientSound", pl )
		umsg.String( "gungame/cs/rounddraw.wav" )
		umsg.End()
	end

	--Set main message
	SetGlobalString("message", "Game Starting")

	--Start the round 
	end_time = CurTime()
end

--Called when the round needs to be started
function GM:StartRound()
	gg_round_time = gg_round_time2
	for _,pl in pairs(player.GetAll()) do
		umsg.Start( "GG_ROUND_TIME", pl )
			umsg.Long( gg_round_time )
		umsg.End()
		pl.IsHostage = false
		pl:ConCommand("r_cleardecals");
	end
	if gonnastrip == true then
		for _,pl in pairs(player.GetAll()) do pl:StripWeapons() end
		gonnastrip = false
	end
	for _,h in pairs(hostages) do
		h.IsHostage = true
	end
	hostages = {} --refresh hostages
	SetGlobalInt("round_start_time", CurTime())
	roundinprogress = 3
	prepping = true
	SetGlobalInt("roundinprogress", 3)
	noround = false
	SetGlobalString("message", "")
	if self.SpawnWeaponsCrap and self.SpawnWeaponsCrap != {} then
		for _,crap in pairs(self.SpawnWeaponsCrap) do 
			if crap and crap:IsValid() then
				crap:Remove()
			end
		end
	end
	self.InvisStatics = {}
	self.SpawnWeaponsCrap = {}
	--remove stray guns and nades
	for _, guns in pairs(ents.FindByClass("rcs_droppedweapon")) do
		guns:Remove()
	end
	
	--get rid of blood and shit
	//for _,decals in pairs(ents.FindByClass("*decal*")) do
	//	decals:Remove()
	//end
	
	--Cleanup map
	for _, props in pairs(ents.FindByClass("prop_physics_multiplayer","prop_physics")) do
		props:Remove()
	end
	if completed_round then
		for a, ppm_info in pairs(ppms_info) do
			local new_ppm = ents.Create("prop_physics_multiplayer")
			new_ppm:SetModel(ppm_info.model)
			new_ppm:SetPos(ppm_info.pos)
			new_ppm:SetAngles(ppm_info.ang)
			new_ppm:Spawn()
		end
	end
	GAMEMODE:SpawnWeapons()
	terrorist_spawns = ents.FindByClass("info_player_terrorist")
	counterterrorist_spawns = ents.FindByClass("info_player_counterterrorist")
	hostage_spawns = ents.FindByClass("hostage_entity")
	--Select a team for each player
	for _, pl in pairs(player.GetAll()) do
		pl:UnLock()
		pl:SetNetworkedString("pl_message", "BLANK")
		pl:PrintMessage(HUD_PRINTTALK, "Press F1 to select teams")
		pl:ConCommand("echo startround")
		if pl.team == 1 or pl.team == 4 then
			pl.team = 1
			pl:SetColor(255,255,255,255)
		elseif pl.team == 2 or pl.team == 5 then
			pl.team = 2
			pl:SetColor(255,255,255,255)
		else
			pl.team = 3
		end
		pl:Spawn()
	end

	
	
end 

function GM:WinnerExplode(pl)
	local xplode = ents.Create( "env_explosion" )
	xplode:SetPos( pl.ExplodePos )
	xplode:SetOwner( pl )
	xplode:Spawn()
	xplode:SetKeyValue( "iMagnitude", "100" )
	xplode:Fire( "Explode", 0, 0 )
	xplode:EmitSound( "siege/big_explosion.wav", 500, 500 )

	timer.Simple(0.3, function() WinnerExplode(pl) end)

end
	
function GM:EndRound() --Called when the round needs to be ended
	roundinprogress = 0
	SetGlobalInt("roundinprogress", 0)
	completed_round = true

	--Set main message
	if team.NumPlayers(1) == 0 and team.NumPlayers(2) > 0 then
		SetGlobalString("message", "Counter Terrorists Win")
		umsg.Start( "ClientSound", pl )
		umsg.String( "gungame/cs/ctwin.wav" )
		umsg.End()
	elseif team.NumPlayers(2) == 0 and team.NumPlayers(1) > 0 then
		SetGlobalString("message", "Terrorists Win")
		umsg.Start( "ClientSound", pl )
		umsg.String( "gungame/cs/terwin.wav" )
		umsg.End()
	else
		SetGlobalString("message", "Times UPP")
		umsg.Start( "ClientSound", pl )
		umsg.String( "gungame/cs/rounddraw.wav" )
		umsg.End()
	end

	--little reminder thing for testing purposes
	for _, pl in pairs(player.GetAll()) do
		pl:ConCommand("echo endround")
	end
	end_time = CurTime()
end

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
local function DropWeapon(pl)
	Msg("lol\n")
	local wep = pl:GetActiveWeapon()
	if wep:GetClass() == "rcs_knife" or wep:GetClass() == "rcs_hegrenade" or wep:GetClass() == "rcs_inventory" then return end --hostageidentity/gamemode/init.lua:657: Tried to use a NULL entity!
	local d, worldmodel, class, clip1, saveammo, elite
	d = 1
	elite = false
	saveammo = 0
	worldmodel = wep.WorldModel
	class = wep:GetClass()
	clip1 = wep:Clip1()
	if class == "rcs_elites" then
		worldmodel = "models/weapons/w_pist_elite_single.mdl"
		class = "rcs_beretta"
		elite = true
		if wep.RAmmo > wep.LAmmo then
			clip1 = wep.LAmmo
			saveammo = wep.RAmmo
		else
			clip1 = wep.RAmmo
			saveammo = wep.LAmmo
		end
	end
	for i=1,d do
		local drop = ents.Create("rcs_droppedweapon")
		drop:SetPos(pl:GetShootPos())
		drop:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
		drop:Spawn()
		local phys = drop:GetPhysicsObject()
		phys:AddAngleVelocity(Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
		phys:ApplyForceCenter(pl:GetAimVector()*500)
		drop.WModel =worldmodel
		drop:SetModel(worldmodel)
		drop.Clip = clip1
		drop.SWEP = class
		if wep.Primary.Ammo == "smg1" or wep.Primary.Ammo == "buckshot" or wep.Primary.Ammo == "ar2" then
			pl.HasPrimary = false
		elseif wep.Primary.Ammo == "pistol" or wep.Primary.Ammo == "357" then
			pl.HasSecondary = false
		end
	end
	wep:Remove()
	if elite == true then
		pl:Give("rcs_beretta")
		pl:SelectWeapon("rcs_beretta")
		wep = pl:GetActiveWeapon()
		wep:SetClip1(saveammo)
	else
		pl:SelectWeapon("rcs_knife")
	end
end
concommand.Add("dropweapon", DropWeapon)

local function makehostage(pl)
	local ent = pl:GetEyeTrace().Entity
	if ent:IsPlayer() then
		ent.IsHostage = true
		ent:SetModel("models/player/hostage/hostage_0"..math.random(1,4)..".mdl")
		ent:StripWeapons()
		ent:SetEyeAngles(Angle(4.950006, -144.342102, 0.000000))
		ent:Lock()
	end
end
concommand.Add("makehostage", makehostage)

/* de_Dust2

models/props_lab/blastdoor001c.mdl 
Vector ( -232.7683,2137.7695,-125.2855 ) , Angle ( 0.054,177.0411,0.3368 ) , 
Vector ( -232.75,2137.75,-125.2813 ) , Angle ( 0.0439,177.0333,0.3516 ) , 
Vector ( 615.3167,2222.7524,-88.6513 ) , Angle ( 1.7329,-161.045,0.7407 ) , 
Vector ( 615.3125,2222.75,-88.625 ) , Angle ( 1.714,-161.0353,0.7471 ) , 
Vector ( 291.7138,-383.8095,17.3577 ) , Angle ( -3.2441,-112.7402,-0.5253 ) , 
Vector ( 291.6875,-383.7813,17.3437 ) , Angle ( -3.2524,-112.7335,-0.5275 ) , 
Vector ( 24.538,-554.8881,4.9504 ) , Angle ( -1.0193,-13.536,1.5704 ) , 
Vector ( 24.5312,-554.875,4.9375 ) , Angle ( -1.0109,-13.5369,1.5822 ) , 
Vector ( -102.3946,-632.7591,58.1828 ) , Angle ( 2.189,-91.9676,-14.0838 ) , 
Vector ( -102.375,-632.75,58.1562 ) , Angle ( 2.1975,-91.9449,-14.0643 ) , 
Vector ( -265.9513,-634.4405,98.991 ) , Angle ( -1.7757,-89.1238,-14.0398 ) , 
Vector ( -265.9375,-634.4375,98.9687 ) , Angle ( -1.7581,-89.132,-14.0203 ) , 
Vector ( -430.0785,-634.3214,140.4388 ) , Angle ( -6.4337,-89.2985,-14.1035 ) , 
Vector ( -430.0625,-634.3125,140.4375 ) , Angle ( -6.4169,-89.3078,-14.1082 ) , 
Vector ( -1345.3935,-891.5475,147.0804 ) , Angle ( 2.9572,-0.6113,0.0165 ) , 
Vector ( -1345.375,-891.5313,147.0625 ) , Angle ( 2.9446,-0.6153,0 ) , 
Vector ( -1312.8788,-730.0628,130.8104 ) , Angle ( -0.5415,-26.1847,0.2624 ) , 
Vector ( -1312.875,-730.0625,130.7812 ) , Angle ( -0.5275,-26.1947,0.2637 ) , 
Vector ( -1131.1041,-619.1968,130.8982 ) , Angle ( 2.8581,-104.4963,-0.8351 ) , 
Vector ( -1131.0938,-619.1875,130.875 ) , Angle ( 2.8567,-104.4708,-0.8351 ) , 
Vector ( -1218.1397,-591.9687,130.4524 ) , Angle ( 3.0378,-45.43,-0.1715 ) , 
Vector ( -1218.125,-591.9375,130.4375 ) , Angle ( 3.0325,-45.4451,-0.1759 ) , 
models/props_lab/blastdoor001a.mdl 
Vector ( 170.5119,-351.1153,44.6636 ) , Angle ( 0.2577,-91.4408,-0.0419 ) , 
Vector ( 170.5,-351.0938,44.6562 ) , Angle ( 0.2637,-91.4175,-0.044 ) , 
Vector ( -1004.0458,-641.1091,132.7148 ) , Angle ( 1.9603,-87.7898,1.33 ) , 
Vector ( -1004.0313,-641.0938,132.6875 ) , Angle ( 1.9338,-87.7696,1.3185 ) , 
Vector ( -254.2395,2012.3688,-123.1616 ) , Angle ( -0.5205,155.2819,1.3615 ) , 
Vector ( -254.2188,2012.3437,-123.1563 ) , Angle ( -0.5275,155.2777,1.3624 ) , 
Vector ( 640.9687,2093.75,-73.1875 ) , Angle ( 3.6918,-172.3746,9.4933 ) , 
Vector ( 640.9831,2093.7614,-73.2072 ) , Angle ( 3.693,-172.3949,9.5106 ) , 
models/\props/de_dust/grainbasket01a.mdl
Vector ( -315.6817,1533.4379,-110.9958 ) , Angle ( -28.5256,141.0686,75.9218 ) , 
Vector ( -315.6563,1533.4375,-110.9688 ) , Angle ( -28.524,141.0816,75.9028 ) , 
Vector ( -478.3177,1578.0581,-121.2239 ) , Angle ( -4.1105,-96.8003,-2.5433 ) , 
Vector ( -478.3125,1578.0312,-121.2188 ) , Angle ( -4.0875,-96.7794,-2.5492 ) , 
Vector ( -435.8467,1537.2984,-106.5548 ) , Angle ( -68.9312,-108.7801,-81.6256 ) , 
Vector ( -435.8438,1537.2812,-106.5313 ) , Angle ( -68.9147,-108.778,-81.6164 ) , 
Vector ( -388.9944,1542.7457,-108.9957 ) , Angle ( -62.8883,-70.0498,-69.5078 ) , 
Vector ( -388.9688,1542.7187,-108.9688 ) , Angle ( -62.8935,-70.0574,-69.4861 ) , 
Vector ( -421.0838,1574.9508,-121.4518 ) , Angle ( 8.8768,-134.1512,-9.9997 ) , 
Vector ( -421.0625,1574.9375,-121.4375 ) , Angle ( 8.878,-134.1375,-9.9769 ) , 
Vector ( -405.6315,1590.7065,-106.4981 ) , Angle ( 53.4507,-77.9931,-87.6404 ) , 
Vector ( -405.625,1590.6875,-106.4688 ) , Angle ( 53.444,-78.0125,-87.6377 ) , 
Vector ( -348.4325,1630.0998,-103.5933 ) , Angle ( 39.1816,11.17,101.0043 ) , 
Vector ( -348.4063,1630.0937,-103.5625 ) , Angle ( 39.16,11.1634,100.9986 ) , 
Vector ( -414.5279,1574.1833,-78.3074 ) , Angle ( 1.178,11.7266,11.4387 ) , 
Vector ( -414.5,1574.1562,-78.2813 ) , Angle ( 1.1866,11.7348,11.4271 ) , 
Vector ( -384.7689,1599.9487,-85.775 ) , Angle ( -7.7865,-95.1395,19.9693 ) , 
Vector ( -384.75,1599.9375,-85.75 ) , Angle ( -7.7793,-95.1533,19.9536 ) , 
Vector ( -366.231,1634.3494,-87.3283 ) , Angle ( 8.232,-132.9928,-17.869 ) , 
Vector ( -366.2188,1634.3437,-87.3125 ) , Angle ( 8.2187,-132.9948,-17.844 ) , 
Vector ( -387.2417,1582.899,-28.2629 ) , Angle ( -35.0092,-149.0355,76.2497 ) , 
Vector ( -387.2188,1582.875,-28.25 ) , Angle ( -35.0287,-149.0368,76.2544 ) , 
Vector ( -441.8925,1604.4393,-33.0629 ) , Angle ( -20.0594,-24.9995,-90 ) , 
Vector ( -441.875,1604.4375,-33.0625 ) , Angle ( -20.0416,-25.008,-90.011 ) , 
Vector ( -394.6819,1639.2543,-81.6257 ) , Angle ( -10.6591,-20.035,-5.817 ) , 
Vector ( -394.6563,1639.25,-81.625 ) , Angle ( -10.6361,-20.0416,-5.8015 ) , 
Vector ( -398.9679,1629.4581,-125.6411 ) , Angle ( 0.4873,142.4395,0.4876 ) , 
Vector ( -398.9375,1629.4375,-125.625 ) , Angle ( 0.4834,142.4441,0.4834 ) , 
Vector ( -433.6278,1645.7486,-70.2975 ) , Angle ( -28.4812,-162.0716,-96.6376 ) , 
Vector ( -433.625,1645.7187,-70.2813 ) , Angle ( -28.4801,-162.0902,-96.6476 ) , 
Vector ( -420.0253,1635.601,-110.3236 ) , Angle ( 14.4429,99.3502,-81.9827 ) , 
Vector ( -420,1635.5937,-110.3125 ) , Angle ( 14.4597,99.3285,-81.9681 ) , 
Vector ( -396.0142,1639.2034,18.4135 ) , Angle ( 36.4473,53.8352,-159.9758 ) , 
Vector ( -396,1639.1875,18.4062 ) , Angle ( 36.4351,53.8395,-159.9805 ) , 
models/\props/de_dust/stoneblock01a.mdl 
Vector ( 0.0396,422.6313,112.3965 ) , Angle ( 64.653,-23.2232,-2.347 ) , 
Vector ( 0.0312,422.625,112.375 ) , Angle ( 64.6514,-23.206,-2.3294 ) , 
Vector ( 21.4165,414.3984,34.4679 ) , Angle ( 57.5467,-24.3614,4.0254 ) , 
Vector ( 21.4062,414.375,34.4375 ) , Angle ( 57.5314,-24.3487,3.9995 ) , 
Vector ( -33.915,350.7755,62.104 ) , Angle ( 0.0092,148.4518,-1.8195 ) , 
Vector ( -33.9063,350.75,62.0937 ) , Angle ( 0,148.4653,-1.802 ) , 
Vector ( -27.7123,352.5252,3.4034 ) , Angle ( 0.1602,152.0392,-1.8659 ) , 
Vector ( -27.6875,352.5,3.375 ) , Angle ( 0.1758,152.0253,-1.846 ) , 
Vector ( -53.0656,441.2014,64.589 ) , Angle ( -0.746,125.7128,-1.2307 ) , 
Vector ( -53.0625,441.1875,64.5625 ) , Angle ( -0.7472,125.6989,-1.2307 ) , 
Vector ( -29.7509,437.1424,4.5686 ) , Angle ( -1.1045,152.3214,-2.4313 ) , 
Vector ( -29.75,437.125,4.5625 ) , Angle ( -1.0988,152.333,-2.4173 ) , 
models/\props/de_dust/du_crate_64x64.mdl 
Vector ( -383.7091,1478.9394,-91.4442 ) , Angle ( -1.5657,-95.8577,-0.0033 ) , 
Vector ( -383.6875,1478.9375,-91.4375 ) , Angle ( -1.5823,-95.8565,0 ) , 
Vector ( -420.8863,-35.2749,36.2172 ) , Angle ( 0.0116,81.401,0.0035 ) , 
Vector ( -420.875,-35.25,36.1875 ) , Angle ( 0,81.3966,0 ) , 
Vector ( -426.7149,-28.5046,100.5398 ) , Angle ( -0.0296,94.7423,-0.0701 ) , 
Vector ( -426.6875,-28.5,100.5312 ) , Angle ( -0.044,94.7576,-0.044 ) , 
Vector ( -463.6544,-99.7301,172.4273 ) , Angle ( -31.5552,-176.384,-89.9109 ) , 
Vector ( -463.625,-99.7188,172.4062 ) , Angle ( -31.5566,-176.3741,-89.9231 ) , 


*/
