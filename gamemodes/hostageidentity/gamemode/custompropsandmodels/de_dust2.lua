--pretty much follow these parameters, change what you need
local ts, tsecs, wep2, wep1, igh, igh2, ctsecs, cts, blastdoor001a, blastdoor001c,grainbasket01a, swep1, swep2, sweps, iswep,stoneblock01a,du_crate_64x64,stoneblocks48,it_mkt_table2,it_mkt_shelf1
wep1 = {
"models/weapons/w_shot_xm1014.mdl",
"models/weapons/w_snip_scout.mdl",
"models/weapons/w_rif_ak47.mdl",
"models/weapons/w_smg_mac10.mdl",
"models/weapons/w_smg_p90.mdl",
"models/weapons/w_rif_sg552.mdl",
"models/weapons/w_rif_famas.mdl",
"models/weapons/w_snip_g3sg1.mdl",
"" --THIS IS MANDITORY, IF YOU DON'T PUT THIS, THE GALIL WILL NOT BE A POSSIBILITY
}
wep2 = {
"models/weapons/w_pist_deagle.mdl",
"models/weapons/w_pist_glock18.mdl",
"models/weapons/w_pist_usp.mdl",
"models/weapons/w_pist_elite_single.mdl",
"" --same thing
}
swep1 = {
"rcs_xm1014",
"rcs_scout",
"rcs_ak47",
"rcs_mac10",
"rcs_p90",
"rcs_sg552",
"rcs_famas",
"rcs_g3sg1",
"" --etc.....
}
swep1ammo = {
7,
10,
30,
30,
50,
30,
25,
20,
"" --etc.....
}
swep2 = {
"rcs_deagle",
"rcs_glock",
"rcs_usp",
"rcs_beretta",
""
}
swep2ammo = {
7,
20,
12,
15,
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
	--end
	for lol, wep in pairs(igh) do
		if (lol % 2) != 0 and lol != #igh then
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
	SpawnCrap(grainbasket01a, 1) --1 means static (but visible)
	SpawnCrap(stoneblock01a, 1)
	SpawnCrap(du_crate_64x64, 1)
	SpawnCrap(stoneblocks48, 1)
	SpawnCrap(it_mkt_table2, 1)
	SpawnCrap(it_mkt_shelf1, 1)
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
blastdoor001c = { 
Vector ( -232.7683,2137.7695,-125.2855 ), Angle ( 0.054,177.0411,0.3368 ),
Vector (615.3167,2222.7524,-88.6513), Angle ( 1.7329,-161.045,0.7407 ),
Vector ( 291.7138,-383.8095,17.3577 ) , Angle ( -3.2441,-112.7402,-0.5253 ),
Vector ( 301.4971,-369.425,232.1828 ) , Angle ( -0.1225,66.2007,179.8168 ) ,
Vector ( -416.2813,-416.5,119.5 ) , Angle ( 1.2745,69.5299,179.4945 ) , 
Vector ( -261.1105,2217.27,-11.4991 ) , Angle ( -10.7486,-165.3296,-91.1149 ),
Vector ( -1345.3935,-891.5475,147.0804 ) , Angle ( 2.9572,-0.6113,0.0165 ),
Vector ( -281.8438,2093.2812,-25.7188 ) , Angle ( 0,-179.9781,-90.011 ) ,
Vector ( -1312.8788,-730.0628,130.8104 ) , Angle ( -0.5415,-26.1847,0.2624 ) ,
Vector ( -1131.1041,-619.1968,130.8982 ) , Angle ( 2.8581,-104.4963,-0.8351 ) , 
Vector ( -1218.1397,-591.9687,130.4524 ) , Angle ( 3.0378,-45.43,-0.1715 ) , "models/props_lab/blastdoor001c.mdl"}
blastdoor001a = { 
Vector ( 170.5119,-351.1153,44.6636 ) , Angle ( 0.2577,-91.4408,-0.0419 ) ,
Vector ( -1004.0313,-641.0938,132.6875 ) , Angle ( 1.9338,-87.7696,1.3185 ) , 
Vector ( -254.2395,2012.3688,-123.1616 ) , Angle ( -0.5205,155.2819,1.3615 ) ,
Vector ( 596.2187,2291.1562,-23.2188 ) , Angle ( -7.164,86.1872,7.6913 ) , 
Vector ( 640.9831,2093.7614,-73.2072 ) , Angle ( 3.693,-172.3949,9.5106 ) , "models/props_lab/blastdoor001a.mdl"}
grainbasket01a = {
Vector ( -315.6817,1533.4379,-110.9958 ) , Angle ( -28.5256,141.0686,75.9218 ) , 
Vector ( -478.3125,1578.0312,-121.2188 ) , Angle ( -4.0875,-96.7794,-2.5492 ) , 
Vector ( -435.8467,1537.2984,-106.5548 ) , Angle ( -68.9312,-108.7801,-81.6256 ) ,
Vector ( -388.9688,1542.7187,-108.9688 ) , Angle ( -62.8935,-70.0574,-69.4861 ) , 
Vector ( -421.0838,1574.9508,-121.4518 ) , Angle ( 8.8768,-134.1512,-9.9997 ) , 
Vector ( -405.6315,1590.7065,-106.4981 ) , Angle ( 53.4507,-77.9931,-87.6404 ) , 
Vector ( -348.4325,1630.0998,-103.5933 ) , Angle ( 39.1816,11.17,101.0043 ) , 
Vector ( -414.5279,1574.1833,-78.3074 ) , Angle ( 1.178,11.7266,11.4387 ) , 
Vector ( -384.7689,1599.9487,-85.775 ) , Angle ( -7.7865,-95.1395,19.9693 ) , 
Vector ( -366.231,1634.3494,-87.3283 ) , Angle ( 8.232,-132.9928,-17.869 ) , 
Vector ( -387.2417,1582.899,-28.2629 ) , Angle ( -35.0092,-149.0355,76.2497 ) , 
Vector ( -441.8925,1604.4393,-33.0629 ) , Angle ( -20.0594,-24.9995,-90 ) , 
Vector ( -394.6819,1639.2543,-81.6257 ) , Angle ( -10.6591,-20.035,-5.817 ) , 
Vector ( -398.9679,1629.4581,-125.6411 ) , Angle ( 0.4873,142.4395,0.4876 ) , 
Vector ( -433.6278,1645.7486,-70.2975 ) , Angle ( -28.4812,-162.0716,-96.6376 ) , 
Vector ( -420.0253,1635.601,-110.3236 ) , Angle ( 14.4429,99.3502,-81.9827 ) , 
Vector ( -396,1639.1875,18.4062 ) , Angle ( 36.4351,53.8395,-159.9805 ) , "models/props/de_dust/grainbasket01a.mdl"}
stoneblock01a = {
Vector ( 0.0312,422.625,112.375 ) , Angle ( 64.6514,-23.206,-2.3294 ) , 
Vector ( 21.4165,414.3984,34.4679 ) , Angle ( 57.5467,-24.3614,4.0254 ) , 
Vector ( -24.0313,351.5312,59.875 ) , Angle ( 0,148.4653,-1.802 ) , 
Vector ( -27.7123,352.5252,3.4034 ) , Angle ( 0.1602,152.0392,-1.8659 ) , 
Vector ( -53.0656,441.2014,64.589 ) , Angle ( -0.746,125.7128,-1.2307 ) ,
Vector ( -125.9688,452.9687,6.1875 ) , Angle ( 0,148.4653,-1.802 ), 
Vector ( -29.75,437.125,4.5625 ) , Angle ( -1.0988,152.333,-2.4173 ) , "models/props/de_dust/stoneblock01a.mdl"}
du_crate_64x64 = {
Vector ( -383.7091,1478.9394,-91.4442 ) , Angle ( -1.5657,-95.8577,-0.0033 ) ,
Vector ( -420.875,-35.25,36.1875 ) , Angle ( 0,81.3966,0 ) ,
Vector ( -426.7149,-28.5046,100.5398 ) , Angle ( -0.0296,94.7423,-0.0701 ) ,
Vector ( -429.5313,-27.5625,164.4375 ) , Angle ( 0,81.3966,0 ) , 
Vector ( -463.625,-99.7188,172.4062 ) , Angle ( -31.5566,-176.3741,-89.9231 ) , "models/props/de_dust/du_crate_64x64.mdl"}

stoneblocks48 = {	Vector ( 86.9066,-462.6618,6.2452 ) , Angle ( -0.2179,131.4501,-0.4981 ) , 
Vector ( 120.991,-426.2826,6.2983 ) , Angle ( -0.358,-135.0374,0.6348 ) , 
Vector ( 193.3075,-571.9487,4.903 ) , Angle ( 2.0503,-115.1019,-0.6361 ) , 
Vector ( 328.018,-516.3545,7.9036 ) , Angle ( 6.4125,-161.0593,0.1916 ) , 
Vector ( 353.0836,-558.9836,9.0251 ) , Angle ( 7.1103,-160.9486,-0.5842 ) , 
Vector ( 233.7237,-659.2252,2.9625 ) , Angle ( 1.0559,-131.0884,0.4618 ) , 
Vector ( 355.394,-610.9296,7.8356 ) , Angle ( 2.6995,-169.1458,-2.1573 ) , 
Vector ( 359.4988,-663.3394,5.4075 ) , Angle ( 0.1413,-179.7528,-4.5952 ) , 
Vector ( 390.2073,-725.419,2.7127 ) , Angle ( -1.2727,-179.6954,-2.2342 ) , 
Vector ( 304.2518,-759.4702,4.1733 ) , Angle ( -0.4483,156.3502,1.8607 ) , 
Vector ( 351.0838,-835.9,12.4849 ) , Angle ( 15.1012,102.0606,2.6272 ) , "models/props/de_dust/stoneblocks48.mdl"}



it_mkt_shelf1 = {
Vector ( -26.1159,2022.2031,-125.1254 ) , Angle ( -0.3539,83.7323,0.691 ) , "models/props/cs_italy/it_mkt_shelf1.mdl"}

it_mkt_table2 = {
Vector ( -65.6994,2247.5974,-126.0939 ) , Angle ( -1.6461,-80.7002,0.0482 ) , 
Vector ( 568.3109,2255.2004,-104.1573 ) , Angle ( 15.7881,179.9781,-5.8162 ) , "models/props/cs_italy/it_mkt_table2.mdl"}
cts = {
Vector ( -3.5425,2013.9111,-62.2722 ) , Angle ( 26.6946,76.6508,82.7317 ) , 
Vector ( -16.8058,2012.6029,-60.1061 ) , Angle ( 26.8844,87.7824,-83.1692 ) , 
Vector ( -17.2889,2013.3702,-100.9819 ) , Angle ( 22.1901,45.7143,70.0952 ) , 
Vector ( -36.1343,2018.1158,-101.4134 ) , Angle ( 26.6516,73.8545,-89.5637 ) , 
Vector ( -54.1703,2025.8142,-104.6485 ) , Angle ( 26.444,74.7987,81.9017 ) , 
Vector ( -64.967,2242.9233,-88.0048 ) , Angle ( 2.4873,91.4114,-85.5271 ) , 
Vector ( -109.6527,2245.7265,-88.3355 ) , Angle ( -0.8423,-87.2656,-85.2224 ) , 
Vector ( 549.7131,2223.8881,-73.7331 ) , Angle ( -1.3251,-62.9228,101.8771 ) , 
Vector ( 554.4664,2292.686,-64.4938 ) , Angle ( 17.5612,-163.8239,-86.695 ) , ""}
ctsecs = {
Vector ( 566.2852,2262.5729,-65.6036 ) , Angle ( 18.7205,-147.0812,88.6619 ) , 
Vector ( 542.6937,2239.696,-73.4288 ) , Angle ( -13.8814,32.3176,-87.6019 ) , 
Vector ( -84.6135,2250.3208,-89.5469 ) , Angle ( 1.0614,-96.5121,85.486 ) , 
Vector ( -37.7007,2248.6115,-88.0769 ) , Angle ( 0.997,-24.7659,-86.5031 ) , 
Vector ( -44.588,2013.4658,-60.032 ) , Angle ( 24.3482,47.1509,70.6622 ) , 
Vector ( -52.8466,2014.0758,-58.3709 ) , Angle ( 28.1676,69.8689,-90.59 ) , 
Vector ( -53.735,2014.2479,-78.3841 ) , Angle ( 22.0535,38.8079,-103.013 ) , 
Vector ( -30.0681,2016.6668,-81.1316 ) , Angle ( 21.682,37.6945,-103.3082 ) , 
Vector ( -0.7122,2008.2852,-78.976 ) , Angle ( 28.2627,88.9835,-82.1002 ) , 
Vector ( -22.0739,2014.7239,-100.659 ) , Angle ( 28.3145,79.1,-86.5736 ) , ""}

ts = {
Vector ( 112.9362,-455.7197,55.5331 ) , Angle ( 1.6963,-129.2612,84.5229 ) , 
Vector ( 319.6378,-503.9731,56.6425 ) , Angle ( 5.919,-125.2092,88.2642 ) , 
Vector ( 346.3768,-517.5687,59.1199 ) , Angle ( 6.967,-152.6417,86.2071 ) , 
Vector ( 368.234,-551.4703,60.5293 ) , Angle ( 5.8966,156.9934,78.9719 ) , 
Vector ( 347.8074,-631.6948,56.1513 ) , Angle ( 1.2347,148.8302,-90.6641 ) , 
Vector ( 351.7318,-671.9453,53.8285 ) , Angle ( -2.9866,121.8467,81.7717 ) , 
Vector ( 404.7738,-740.9999,51.3624 ) , Angle ( -1.8073,134.8275,-87.0912 ) , 
Vector ( 333.8303,-821.0311,59.5503 ) , Angle ( -10.2091,-45.1573,-94.6123 ) , 
Vector ( 303.6903,-752.5748,53.5957 ) , Angle ( 1.4879,125.3233,-83.3796 ) , 
Vector ( 235.0904,-653.668,52.0283 ) , Angle ( 1.7548,173.794,84.1117 ) , 
Vector ( 195.7254,-564.2295,54.2169 ) , Angle ( 2.4955,-127.6233,84.1237 ) , 
Vector ( 206.5402,-578.9209,53.7257 ) , Angle ( 2.5431,-125.0724,84.1885 ) , ""}
tsecs = {
Vector ( 85.0981,-463.7302,54.4663 ) , Angle ( 1.909,-141.1562,86.4169 ) , 
Vector ( 91.5803,-447.8487,55.8109 ) , Angle ( 1.9063,-72.8989,-85.9206 ) , 
Vector ( 112.817,-410.5562,54.3905 ) , Angle ( 2.5427,-12.5933,83.0488 ) , 
Vector ( 336.6018,-552.5706,56.0446 ) , Angle ( 8.354,-171.611,84.7021 ) , 
Vector ( 359.8231,-578.5178,57.3646 ) , Angle ( 6.6485,164.2962,83.2323 ) , 
Vector ( 343.4943,-590.7034,57.9563 ) , Angle ( 4.8578,-166.9195,-87.9786 ) , 
Vector ( 347.2247,-808.5447,55.0189 ) , Angle ( 16.4531,71.9119,81.5653 ) , 
Vector ( 379.7089,-750.3342,50.3115 ) , Angle ( 0.4079,62.2258,88.2429 ) , 
Vector ( 282.6525,-770.6634,53.1706 ) , Angle ( 3.3791,66.5484,87.3718 ) , 
Vector ( 300.7572,-771.6916,54.0887 ) , Angle ( 3.2939,70.1487,-86.152 ) , 
Vector ( 233.0062,-670.3771,52.4827 ) , Angle ( 3.8746,141.2247,-84.5748 ) , 
Vector ( 183.1162,-569.3771,53.3171 ) , Angle ( 2.3988,157.9998,82.1165 ) , ""}




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