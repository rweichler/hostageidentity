--this basically transfers crap from the server to client, so I can display it in the HUD.
-- I think aska told me about this, thank you as well
if CLIENT then
	--somebody whose name escapes me helped me with this, thank you whoever you are
	local function GetClientSound(um)
		-- read and precache
		local sound = Sound( um:ReadString() )
		-- play
		surface.PlaySound(sound)
	end
	local function GetClientGGLevel (um)
		GGLEVEL = um:ReadString()
	end
	local function GetGGLeader(um)
		GG_LEADER = um:ReadString()
	end
	local function GetGGLeaderLevel(um)
		GG_LEADER_LEVEL = um:ReadString()
	end
	local function ggRoundTime(um)
		gg_round_time = um:ReadLong()
	end
	-- hook it
	usermessage.Hook( "GGLevelSet", GetClientGGLevel )
	usermessage.Hook( "ClientSound", GetClientSound )
	usermessage.Hook( "GGLeader", GetGGLeader )
	usermessage.Hook( "GGLeader_Level", GetGGLeaderLevel )
	usermessage.Hook( "GG_ROUND_TIME", ggRoundTime )
end

--[[ Copypasta convieinience, server only
	umsg.Start( "ClientSound/GGLevelSet/GGLeader_Level", pl )
	umsg.String( value )
	umsg.End()
]]