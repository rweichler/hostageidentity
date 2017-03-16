include("ply.lua")
include("concommands.lua")
include("umsg.lua")

function GM:Initialize()

	if !gg_going_to_be_non_traditional then
		gg_notvanilla = false
		LAST_LEVEL = 25
	elseif gg_going_to_be_non_traditional then
		gg_notvanilla = true
		--LAST_LEVEL = something else
	end

	precachedweapons = false
	Gamefinished = false
	current_map = game.GetMap()
	end_time = 0
	completed_round = false
	for _, pl in pairs(player.GetAll()) do
		pl.GGLevel = 0
	end
	--Set next map
	for a, map in pairs(gg_mapcycle) do
		if map == current_map then
			next_map = gg_mapcycle[a + 1]
		end
	end
	
	--Check to see if it is valid
	if !next_map then
		next_map = gg_mapcycle[1]
	end
	
	--Set globals
	roundinprogress = 0
	
	--No flashlight and regular fall damage
	game.ConsoleCommand("mp_flashlight 0\n")
	game.ConsoleCommand("mp_falldamage 1\n")
end

--precache teh sounds
util.PrecacheSound("gungame/endround/basscreator.mp3")
util.PrecacheSound("gungame/endround/becauseigothigh.mp3")
util.PrecacheSound("gungame/endround/breakstuff.mp3")
util.PrecacheSound("gungame/endround/lastresort.mp3")
util.PrecacheSound("gungame/levelup.wav")
util.PrecacheSound("gungame/leveldown.wav")

--Defaults for console commands
gg_round_time = 4;
gg_round_time2 = gg_round_time --do not change this.
gg_overstocklimit = 2
gg_server_name = "Hostage Identity Test Server";
gg_friendly_fire = 0;
gg_autoset = 0;
gg_PrepTime = .25
--info
/*if gg_server_name != "" and gg_server_name != "Gun Game Official Server" then
	GM.Name = "GunGame on "..gg_server_name
else*/
	GM.Name = "Hostage Identity [BETA]"
//end
GM.Author = "cheesylard"
GM.Email = "cheesylard@hotmail.com"
GM.Website = ""

--teams
team.SetUp(1, "Terrorists", Color(255, 50, 50, 255))
team.SetUp(2, "CTs", Color(50, 50, 255, 255))
team.SetUp(3, "Spectator", Color(255, 255, 255, 255))
team.SetUp(4, "Dead Terrorists", Color(255, 140, 140, 180))
team.SetUp(5, "Dead CTs", Color(140, 140, 255, 180))