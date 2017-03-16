--gg concommands
local function hi_roundtime(pl, cmd, input)
	if !pl:IsAdmin() then return end --only admins can set server commands
	if tonumber(input[1]) < 0 then return end --we don't want a negative roundtime
	gg_round_time2 = tonumber(input[1]) --set the value
end
local function hi_friendlyfire(pl, cmd, input)
	if !pl:IsAdmin() then return end
	if tonumber(input[1]) < 0 then return end
	gg_friendly_fire = tonumber(input[1])
end
local function hi_overstock_limit(pl, cmd, input)
	if !pl:IsAdmin() then return end
	if tonumber(input[1]) < 0 then return end
	gg_overstocklimit = tonumber(input[1])
end
local function hi_autoteamset(pl, cmd, input)
	if !pl:IsAdmin() then return end
	if tonumber(input[1]) == 0 or tonumber(input[1]) == 1 or tonumber(input[1]) == 2 then
		gg_autoset = tonumber(input[1])
	else
		pl:ConCommand("echo Use either 0, 1 or 2.")
		pl:ConCommand("echo 0 = none   |   1 = Terrorist   |   2 = CT")
	end
end
local function hi_servername(pl, cmd, input)
	if pl:IsAdmin() then gg_server_name = tonumber(input[1]) end
end
concommand.Add("hi_roundtime",hi_roundtime) --add the concommand
concommand.Add("hi_friendlyfire",hi_friendlyfire)
concommand.Add("hi_overstock_limit",hi_overstock_limit)
concommand.Add("hi_autoteamset",hi_autoteamset)
concommand.Add("hi_servername",hi_servername)