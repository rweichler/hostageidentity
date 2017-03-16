local COUNTRY_UK = 1
local COUNTRY_US = 2
local COUNTRY_FRANCE = 3
local COUNTRY_BELGIUM = 4
local COUNTRY_SWITZ = 5
local COUNTRY_AUSTRIA = 6
local COUNTRY_GERMANY = 7
local COUNTRY_ISRAEL = 8
local d = " is joining the "
function teamset(pl,commandName,args)
	local teem = tonumber(args[1])
	if (tonumber(args[1]) < 3 or tonumber(args[1]) > 5) and tonumber(args[1]) != 1 and tonumber(args[1]) != 2 then
		local l11 = "Please choose a REAL team."
		pl:PrintMessage(HUD_PRINTCENTER, l11)
		pl:ConCommand("echo "..l11.."\nT = 1, CT = 2, Spec = 3")
	return;
	elseif tonumber(args[1]) == 1 or tonumber(args[1]) == 2 then
		teem = tonumber(args[1]) + 3
	end --prevent someone 'accidentally' typing teamset 32948293 in the console and ruining the game
	if pl.team != teem and not ( (pl.team == 2 or pl.team == 5) and teem == 5 ) and not ( (pl.team == 1 or pl.team == 4) and teem == 4)  then
		if pl.team != 3 and pl.team != 4 and pl.team != 5 then
			pl:Kill()
		end
		pl.team=teem
		if teem == 3 then
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK, pl:Name()..d.."Spectators")
			end
			pl.Country = -1
		elseif teem == 4 then
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK, pl:Name()..d.."Terrorist"..GAMEMODE:Random({"s","s","s","s"," force (YES, FORCE. IT IS THAT AWESOME)"}))
			end
			pl.Country = 0
		elseif teem == 5 then
			if tonumber(args[2]) and tonumber(args[2]) > 0 and tonumber(args[2]) < 9 then
				pl.Country = tonumber(args[2])
			else
				pl.Country = math.random(1,8)
			end
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage(HUD_PRINTTALK, pl:Name()..d.."Counter-Terrorist"..GAMEMODE:Random({"s","s","s","s"," attack squad (IT IS MORE AWESOME THAN FORCE BY A LONG SHOT)"}))
			end
		end
		pl.CountryChange = nil
	else
		if teem == 5 and tonumber(args[2]) then
			if tonumber(args[2]) != pl.Country and tonumber(args[2]) > 0 and tonumber(args[2]) < 9 then
				pl.CountryChange = tonumber(args[2])
			else
				pl:PrintMessage(HUD_PRINTCENTER, "You are already assigned to this country!")
			end
		else
			pl:PrintMessage(HUD_PRINTCENTER, "You are already on this team!")
		end
	end
end
concommand.Add("teamset",teamset)



