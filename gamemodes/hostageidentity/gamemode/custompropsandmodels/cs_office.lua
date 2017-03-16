--pretty much follow these parameters, change what you need

--GO TO LINE 150 IF YOU'RE JUST IMORTING A MAP
local ts, tsecs, wep2, wep1, igh, igh2, ctsecs, cts, blastdoor001a, blastdoor001c, controlroom_desk001b, swep1, swep2, sweps, iswep, ammo1
wep1 = {
"models/weapons/w_shot_m3super90.mdl",
"models/weapons/w_snip_awp.mdl",
"models/weapons/w_smg_tmp.mdl",
"models/weapons/w_smg_mp5.mdl",
"models/weapons/w_rif_m4a1.mdl",
"models/weapons/w_rif_aug.mdl",
"models/weapons/w_rif_galil.mdl",
"models/weapons/w_snip_sg550.mdl",
"" --THIS IS MANDITORY, IF YOU DON'T PUT THIS, THE GALIL WILL NOT BE A POSSIBILITY
}
wep2 = {
"models/weapons/w_pist_deagle.mdl",
"models/weapons/w_pist_glock18.mdl",
"models/weapons/w_pist_usp.mdl",
"models/weapons/w_pist_p228.mdl",
"" --same thing
}


swep1 = {
"rcs_m3",
"rcs_awp",
"rcs_tmp",
"rcs_mp5",
"rcs_m4a1",
"rcs_aug",
"rcs_galil",
"rcs_sg550",
"" --etc.....
}
swep1ammo = {
8,
10,
30,
30,
30,
30,
35,
30,
"" --etc.....
}
swep2 = {
"rcs_deagle",
"rcs_glock",
"rcs_usp",
"rcs_p228",
""
}
swep2ammo = {
7,
20,
12,
13,
""
}
local function SpawnCrap(modtype, static)
	igh2 = {modtype, modtype}
	iswep = false
	if modtype == "t_prim" then
		igh = ts
		igh2 = wep1
		sweps = swep1
		ammo1 = swep1ammo
		iswep = true
	elseif modtype == "t_sec" then
		igh = tsecs
		igh2 = wep2
		sweps = swep2
		ammo1 = swep2ammo
		iswep = true
	elseif modtype == "ct_prim" then
		igh = cts
		igh2 = wep1
		sweps = swep1
		ammo1 = swep1ammo
		iswep = true
	elseif modtype == "ct_sec" then
		igh = ctsecs
		igh2 = wep2
		sweps = swep2
		ammo1 = swep2ammo
		iswep = true
	else
		igh = modtype
		igh2 = {modtype[#modtype], modtype[#modtype]}
	end
	//elseif modtype == "models/props_lab/blastdoor001a.mdl" then
	//	igh = blastdoor001a
	//elseif modtype == "models/props_lab/blastdoor001c.mdl" then
	//	igh = blastdoor001c
	//elseif modtype == "models/props_wasteland/controlroom_desk001b.mdl" then
	//	igh = controlroom_desk001b
	//end
	for lol, wep in pairs(igh) do
		if ((lol % 2) != 0) and lol != #igh then
			local prop
			local weaponspawn = math.random(1,#igh2-1)
			if iswep == true then
				prop = ents.Create("rcs_droppedweapon")
				prop:SetModel(igh2[weaponspawn])
				prop:SetPos(wep)
				prop:SetAngles(igh[lol+1])
				prop:Spawn()
				prop:SetMoveType(MOVETYPE_NONE)
				local ammo = "pistol"
				if igh == ts or igh == cts then
					if lol == 1 then
						ammo = "buckshot"
					else
						ammo = "smg1"
					end
				end
				prop.WModel = igh2[weaponspawn]
				prop:SetModel(igh2[weaponspawn])
				prop.SWEP = sweps[weaponspawn]
				prop.Clip = ammo1[weaponspawn]
				prop.AmmoType = ammo
			else
				prop = ents.Create("prop_physics")
				prop:SetModel(igh2[weaponspawn])
				prop:SetPos(wep)
				prop:SetAngles(igh[lol+1])
				prop:Spawn()
				prop.Custom = 0
			end
			if static then
				--movetype none
				prop:SetMoveType(MOVETYPE_NONE)
				prop.Custom = 1
				if static == 2 then
					prop:SetColor(255,0,0,50) --make invisible if it's 2
					prop.Custom = 2
					table.insert(GAMEMODE.InvisStatics, prop)
				end
			end
			table.insert(GAMEMODE.SpawnWeaponsCrap, prop)
		end
	end
	
end
function GM:SpawnWeapons() --this is the function that gets called
	SpawnCrap("t_prim") --0 or nothing means weapon
	SpawnCrap("t_sec")
	SpawnCrap("ct_sec")
	SpawnCrap("ct_prim")
	SpawnCrap(blastdoor001c, 2) --2 means invisible and static
	SpawnCrap(blastdoor001a, 2)
	SpawnCrap(controlroom_desk001b, 1) --1 means static (but visible)
end

















--ok
--you're going to want to do the stuff in the order
--like, shoot all the CT awps first, type a marker into the console, do all the CT deagles, type a marker, do all the T deagles, type a marker, etc.
--here's what you're going to be doing:
--[[
Spawn m249's where you want all of the primary weapons to be spawned (For CT and T)
Spawn deagles' where you want the secondaries to be spawned
Spawn all of the tables (for extra places to put weapons (OPTIONAL) )
Spawn blast door blockages (going to be invisible)
-Then, for each prop/ section, use the SWep and shoot each part of each part (like just the CT secondaries) then when your done, put a little marker in the console, like ct secondaries done or something,
And when you're done, just follow the format below for your map
]]




--this is the part you're going to be editing
	ts = { --t primaries

	Vector ( 1373.7502,41.5179,-128.0576 ) , Angle ( 1.0945,57.2206,-84.481 ) , 
	Vector ( 1301.4628,41.014,-128.0709 ) , Angle ( 1.0561,92.5938,-84.8014 ) , 
	Vector ( 1288.7752,90.8125,-158.6648 ) , Angle ( 0.6021,128.767,85.4188 ) , 
	Vector ( 1497.6975,-656.6092,-77.9815 ) , Angle ( 0.9425,71.6828,-84.4764 ) , 
	Vector ( 1343.2084,-650.809,-126.5857 ) , Angle ( 0.7553,-14.0307,84.783 ) , 
	Vector ( 1612.1647,-596.3259,-98.3019 ) , Angle ( 0.438,110.514,-107.3762 ) , 
	Vector ( 1617.8411,-594.4164,-100.3247 ) , Angle ( -0.7778,94.059,-90.8286 ) , 
	Vector ( 1326.1228,-417.0729,-77.9401 ) , Angle ( 0.9107,-7.3534,-85.2051 ) , 
	Vector ( 1317.8358,-427.6495,-100.8985 ) , Angle ( 0.6176,-74.7662,84.8181 ) , 
	Vector ( 1335.5969,-423.2774,-100.9065 ) , Angle ( 0.5016,-92.1016,85.5892 ) , 
	Vector ( 1329.3709,-414.4809,-150.6094 ) , Angle ( -3.2969,-95.6597,-77.2461 ) , 
	Vector ( 1325.6257,-442.6037,-151.9736 ) , Angle ( -0.5625,36.1475,-90.2708 ) , "" --again, this empty string is manditory
	}
	tsecs = { --t secondaries
	Vector ( 1616.3437,-579.9158,-126.0838 ) , Angle ( 1.4137,80.1299,-86.8149 ) , 
	Vector ( 1348.1018,-648.8854,-100.2231 ) , Angle ( 3.0912,49.5386,-83.9198 ) , 
	Vector ( 1331.7248,-445.263,-127.2636 ) , Angle ( 2.037,-102.8644,85.3763 ) , 
	Vector ( 1324.8343,-429.1807,-127.3017 ) , Angle ( 1.6549,-79.6599,86.2734 ) , 
	Vector ( 1335.2001,-417.4497,-125.9846 ) , Angle ( 2.8607,-68.09,-83.7318 ) , 
	Vector ( 1391.3876,-462.8617,-158.0462 ) , Angle ( 3.0991,-100.206,-83.4157 ) , 
	Vector ( 1321.7181,39.1009,-128.0772 ) , Angle ( 2.5246,62.6459,-83.8254 ) , 
	Vector ( 1309.4285,62.0178,-128.0793 ) , Angle ( 3.0504,-114.7575,-82.8148 ) , 
	Vector ( 1289.1894,26.7401,-129.3072 ) , Angle ( 2.3358,118.4938,85.0136 ) , 
	Vector ( 1274.2584,34.4466,-128.0847 ) , Angle ( 2.5445,65.4331,-83.6366 ) , 
	Vector ( 1257.5217,51.9909,-128.105 ) , Angle ( 2.4178,86.1346,-83.4248 ) , "" --again, this empty string is manditory
	}
	--ct primaries
	cts = {
	Vector ( -1473.0856,-1993.4764,-300.4036 ) , Angle ( 1.0937,18.0227,-85.3731 ) , 
	Vector ( -1462.9129,-1960.1951,-300.4604 ) , Angle ( 1.1098,-2.9004,-85.4746 ) , 
	Vector ( -1461.4728,-1945.787,-301.0603 ) , Angle ( 0.9541,3.2746,85.1518 ) , 
	Vector ( -1459.1473,-1927.7463,-301.1472 ) , Angle ( 0.6286,4.4981,85.1886 ) , 
	Vector ( -1459.3182,-1698.9609,-300.9319 ) , Angle ( 0.8196,-58.3795,84.9042 ) , 
	Vector ( 36.9804,-1582.871,-300.8976 ) , Angle ( 0.8423,-132.8712,84.9474 ) , 
	Vector ( 109.0026,-1589.3116,-300.9184 ) , Angle ( 0.8743,-120.8196,85.0057 ) , 
	Vector ( 152.1378,-1589.0807,-300.9157 ) , Angle ( 0.834,-131.9814,85.003 ) , 
	Vector ( 249.7271,-1583.7144,-300.9876 ) , Angle ( 0.7561,-151.686,85.006 ) , 
	Vector ( 271.1342,-1596.0389,-301.044 ) , Angle ( 0.7216,-160.2625,84.965 ) , "" --again, this empty string is manditory
	}
	--ct secondaries 
	ctsecs = {
	Vector ( 294.4571,-1598.8411,-300.4311 ) , Angle ( 2.4467,-178.3393,-84.6128 ) , 
	Vector ( 216.8038,-1580.8461,-301.6906 ) , Angle ( 1.7866,-127.0299,87.0214 ) , 
	Vector ( 61.8952,-1589.0877,-300.3299 ) , Angle ( 3.4773,-113.4984,-82.964 ) , 
	Vector ( 129.2579,-1597.8846,-301.5831 ) , Angle ( 2.4247,-178.9294,84.76 ) , 
	Vector ( -19.4641,-1593.6683,-301.5629 ) , Angle ( 2.7051,-89.9589,85.2418 ) , 
	Vector ( -1464.4521,-1880.5091,-300.3921 ) , Angle ( 2.6536,-5.4863,-85.1327 ) , 
	Vector ( -1462.866,-1849.5967,-300.3997 ) , Angle ( 2.6394,-22.4267,-85.194 ) , 
	Vector ( -1462.0508,-1824.8793,-300.4164 ) , Angle ( 2.6911,-37.2281,-84.8221 ) , 
	Vector ( -1451.0077,-1800.3254,-300.5251 ) , Angle ( 2.3949,-53.2853,-84.1183 ) , 
	Vector ( -1449.8018,-1682.1014,-300.3984 ) , Angle ( 3.0245,-45.9595,-83.6549 ) , "" --again, this empty string is manditory
	}

--------------------------------------------------------------------------
--------------               Props and crap                  -------------------
--------------------------------------------------------------------------
--models/props_lab/blastdoor001a.mdl 
blastdoor001a = {
Vector ( 1407.1739,818.5612,-159.5165 ) , Angle ( -0.0012,-72.9457,-0.0004 ) , 
Vector ( 959.5439,-316.5264,-158.1494 ) , Angle ( -0.0045,94.1466,0.0333 ) , 
Vector ( 1929.8549,-5.3411,-112.2549 ) , Angle ( 1.8654,164.1042,89.2729 ) , 
Vector ( 1958.1074,-373.5755,-109.1926 ) , Angle ( 0,-155.5754,90 ) , 
Vector ( -1383.41,-1410.0252,-326.2813 ) , Angle ( 18.4312,6.085,0.0657 ) , 
Vector ( -987.3708,-1406.0241,-325.5674 ) , Angle ( 20.4374,-175.644,0.766 ) , 
Vector ( -1101.2588,-1121.8442,-319.7118 ) , Angle ( 2.6547,-44.8913,6.259 ) , 
Vector ( 372.6989,-1603.117,-296.9848 ) , Angle ( 0.3923,-0.1079,26.5576 ) , 
"models/props_lab/blastdoor001a.mdl"} --get it now?
--models/props_lab/blastdoor001c.mdl
blastdoor001c = {
Vector ( -1222.0892,-1155.4284,-327.6317 ) , Angle ( 0,-89.0404,0 ) , 
Vector ( 355.1544,-1820.9666,-320.7377 ) , Angle ( -0.3,-175,-0.0019 ) , 
Vector ( 410.5048,-1979.0823,-318.4442 ) , Angle ( 0.929,-146.6518,0.9536 ) , "models/props_lab/blastdoor001c.mdl"}
--models/props_wasteland/controlroom_desk001b.mdl 
controlroom_desk001b = {
Vector ( 246.3151,-1588.1601,-319.1253 ) , Angle ( -0.2755,89.8923,-0.0007 ) , 
Vector ( 134.6416,-1588.1063,-319.0596 ) , Angle ( -0.2718,89.9045,-0.0001 ) , 
Vector ( 22.9397,-1587.1819,-319.0668 ) , Angle ( -0.257,89.8918,-0.0021 ) , 
Vector ( -1466.7996,-1949.2048,-319.1806 ) , Angle ( -0.3074,-179.9067,0.0033 ) , 
Vector ( -1464.179,-1837.1832,-319.17 ) , Angle ( -0.2671,179.8679,0.0003 ) , 
Vector ( -1463.9554,-1725.5081,-319.0615 ) , Angle ( -0.3251,179.8808,-0.0148 ) , "models/props_wasteland/controlroom_desk001b.mdl"}


//ignore this part, it's for something else.
--[[
local positions =	{
					Vector(1730.906250, 666.281250, -155.968750),
					Vector(1531.312500, 1015.250000, -155.968750),
					Vector(602.312500, 1026.375000, -155.968750),
					Vector(744.062500, -210.406250, -123.968750),
					Vector(88.968750, 298.500000, -155.968750),
					Vector(1204.875000, 464.218750, -155.968750),
					Vector(1240.125000, -120.562500, -155.968750),
					Vector(1560.937500, -610.875000, -155.968750),
					Vector(1643.312500, -87.031250, -155.968750),
					Vector(2293.250000, -357.375000, -155.968750),
					Vector(1912.500000, 182.000000, -155.968750),
					Vector(1153.687500, -898.125000, -155.968750),
					Vector(409.968750, -870.218750, -219.968750),
					Vector(85.156250, -1091.437500, -219.968750),
					Vector(-140.687500, -768.781250, -275.968750),
					Vector(-418.281250, 667.062500, -155.968750),
					Vector(-884.406250, -203.937500, -155.968750),
					Vector(-360.975494, -209.098770, -155.968750),
					Vector(-567.437500, -331.625000, -143.968750),
					Vector(-1682.843750, -1543.000000, -323.968750),
					Vector(-1607.562500, -151.906250, -235.968750),
					Vector(-816.093750, 319.000000, -357.156250),
					Vector(-696.281250, 549.406250, -363.968750),
					Vector(-1402.593750, 1222.343750, -324.968750),
					Vector(-655.218750, -1387.812500, -243.968750),
					Vector(-874.437500, -1198.000000, -235.968750),
					Vector(-934.906250, -1635.343750, -331.968750),
					Vector(-101.906250, -1763.250000, -227.218750),
					Vector(421.781250, -2109.781250, -331.968750),
					Vector(298.343750, -1347.500000, -275.968750),
					Vector(1216.906250, -2041.406250, -282.156250)
					}
local angles = 		{
					Angle(3.595968, -149.382172, 0.000000),
					Angle(6.235968, -149.118179, 0.000000),
					Angle(5.773968, -51.504246, 0.000000),
					Angle(17.191971, 169.895752, 0.000000),
					Angle(2.143965, -88.794350, 0.000000),
					Angle(4.387965, -89.190399, 0.000000),
					Angle(4.321965, -157.896347, 0.000000),
					Angle(2.935963, 95.081711, 0.000000),
					Angle(9.271963, 12.119641, 0.000000),
					Angle(6.961967, 138.047714, 0.000000),
					Angle(5.641967, -169.086273, 0.000000),
					Angle(0.031970, 177.449738, 0.000000),
					Angle(0.955971, -51.342216, 0.000000),
					Angle(3.397980, 125.075729, 0.000000),
					Angle(3.925981, -155.724304, 0.000000),
					Angle(4.189981, -147.576355, 0.000000),
					Angle(4.255980, 46.991688, 0.000000),
					Angle(6.433980, 108.107681, 0.000000),
					Angle(8.677981, -87.084328, 0.000000),
					Angle(2.671982, 49.901596, 0.000000),
					Angle(4.255981, -67.380409, 0.000000),
					Angle(11.515984, -16.362446, 0.000000),
					Angle(4.455996, -132.126358, 0.000000),
					Angle(-2.869992, -52.362312, 0.000000),
					Angle(1.024005, 134.717758, 0.000000),
					Angle(3.664005, 46.409828, 0.000000),
					Angle(3.466005, -50.940281, 0.000000),
					Angle(22.738035, -50.412231, 0.000000),
					Angle(2.872036, 101.585754, 0.000000),
					Angle(4.654036, -0.714261, 0.000000),
					Angle(3.334037, 137.327713, 0.000000)
					}
local function LolWow()
	if game.GetMap() != "cs_office" then return end
	for anus, ang in pairs(angles) do
		for rectum, pos in pairs(positions) do
			local spawn = ents.Create("info_player_start")
			spawn:SetPos(pos)
			spawn:SetAngles(ang)
			spawn:Spawn()
		end
	end
end
hook.Add("PlayerInitialSpawn", "penisersaresfd", LolWow)
local function RandPos(pl)
	local thing = math.random (1, #positions)
	pl:SetPos(positions[thing])
	pl:SetEyeAngles(angles[thing])
end
concommand.Add("setrandomposition", RandPos)]]