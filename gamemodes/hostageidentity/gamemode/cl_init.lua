HOSTAGEIDENTITYteammenuenabled = false
-- Include needed files
include("shared.lua")
include("cl_hacky.lua")
include("cl_scoreboard.lua")


HL2Guns = {}
HL2Guns["weapon_crowbar"] = 1
HL2Guns["weapon_stunstick"] = 1
HL2Guns["weapon_physcannon"] = 1
HL2Guns["weapon_pistol"] = 18
HL2Guns["weapon_357"] = 6
HL2Guns["weapon_pistol"] = 18
HL2Guns["weapon_smg1"] = 45
HL2Guns["weapon_ar2"] = 30
HL2Guns["weapon_shotgun"] = 6
HL2Guns["weapon_crossbow"] = 1
HL2Guns["weapon_rpg"] = 1
HL2Guns["weapon_frag"] = 1

-- Third person view
function GM:CalcView(pl, origin, angles, fov)
	local view = {} 
 	view.origin = origin 
 	view.angles	= angles 
 	view.fov = fov 
 	 
 	-- Give the active weapon a go at changing the viewmodel position 

 	
 	if pl:GetActiveWeapon()  && pl:GetActiveWeapon()  != NULL then 
		local wep = pl:GetActiveWeapon() 
 		local func = wep.GetViewModelPosition 
 		if func then 
 			view.vm_origin, view.vm_angles = func(wep, origin*1, angles*1) -- Note: *1 to copy the object so the child function can't edit it. 
 		end
 		 
 		local func = wep.CalcView 
 		if func then 
 			view.origin, view.angles, view.fov = func(wep, pl, origin*1, angles*1, fov) -- Note: *1 to copy the object so the child function can't edit it. 
 		end 
 	end
	--view if ur ded
	if pl:GetRagdollEntity() and pl:GetRagdollEntity():IsValid() then
		local e=pl:GetRagdollEntity():GetAttachment(pl:GetRagdollEntity():LookupAttachment("eyes"))
		view.origin=e.Pos
		view.angles=e.Ang
	end
	-- Return the view
 	return view 
end 

local function NoHud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
  	end 
end
hook.Add("HUDShouldDraw", "NoDrawHud", NoHud)

-- We don't want to show the players target id, but I do, I CAN DO WHATEVER I WANT
function GM:HUDDrawTargetID() 
   
 	local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() ) 
 	local trace = util.TraceLine( tr ) 
 	if (!trace.Hit) then return end 
 	if (!trace.HitNonWorld) then return end 
 	 
 	local text = "ERROR" 
 	local font = "TargetID" 
 	 
 	if (trace.Entity:IsPlayer()) then 
 		text = trace.Entity:Nick() 
 	else 
 		return 
 		--text = trace.Entity:GetClass() 
 	end 
 	if trace.Entity:Team() != LocalPlayer():Team() or trace.Entity:Team() > 2 then return end --we don't want to be able to use this on enemies
 	surface.SetFont( font ) 
 	local w, h = surface.GetTextSize( text ) 
 	 
 	local MouseX, MouseY = gui.MousePos() 
 	 
 	if ( MouseX == 0 && MouseY == 0 ) then 
 	 
 		MouseX = ScrW() / 2 
 		MouseY = ScrH() / 2 
 	 
 	end 
 	 
 	local x = MouseX 
 	local y = MouseY 
 	 
 	x = x - w / 2 
 	y = y + 30 
 	 
 	-- The fonts internal drop shadow looks lousy with AA on 
 	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) ) 
 	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) ) 
 	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) ) 
 	 
 	y = y + h + 5 
 	 
 	local text = trace.Entity:Health() .. "%" 
 	local font = "TargetIDSmall" 
 	 
 	surface.SetFont( font ) 
 	local w, h = surface.GetTextSize( text ) 
 	local x =  MouseX  - w / 2 
 	 
 	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) ) 
 	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) ) 
 	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) ) 
   
 end  
		local head, body, larm, rarm, lleg, rleg, scale, headw, headh, bodyw, bodyh, larmw, larmh, llegw, llegh, rlegw, rlegh
		scale = 4/5
		local widthbullet = 25
		local heightbullet = 25
		local numincol = 10
		local lastshoot = 0
		head = surface.GetTextureID("hostident/bodymap/head")
		body = surface.GetTextureID("hostident/bodymap/torso")
		larm = surface.GetTextureID("hostident/bodymap/arm")
		rarm = surface.GetTextureID("hostident/bodymap/arm_r")
		lleg = surface.GetTextureID("hostident/bodymap/leg")
		rleg = surface.GetTextureID("hostident/bodymap/leg_r")
		
		headh = 48*scale
		headw = 32*scale

		bodyh = 128*scale
		bodyw = 64*scale

		rarmh = 128*scale
		rarmw = 32*scale

		llegh = 128*scale
		llegw = 24*scale

		rlegh = 128*scale
		rlegw = 24*scale

		larmh = 128*scale
		larmw = 32*scale

--Called every frame to draw the hud
function GM:HUDPaint()
	--refresh fonts
	surface.CreateFont("coolvetica", ScreenScale( 32 ), 500, true, false, "ScoreboardHead") 
 	surface.CreateFont("coolvetica", ScreenScale( 15 ), 500, true, false, "ScoreboardSub") 
 	surface.CreateFont("Tahoma", ScreenScale( 8 ), 1000, true, false, "ScoreboardText") 
	surface.CreateFont("Arial", ScreenScale( 8 ), 400, true, false, "gg_arial")
	surface.CreateFont("green piloww", ScreenScale( 30 ), 400, true, false, "gg_notices_font")
	surface.CreateFont("Urban Sketch", ScreenScale( 35 ), 400, true, false, "hudfont")
	surface.CreateFont("Urban Sketch", ScreenScale( 30 ), 400, true, false, "hudfont_30")
	surface.CreateFont("Urban Sketch", ScreenScale( 20 ), 400, true, false, "hudfont_sm")
	surface.CreateFont("Urban Sketch", ScreenScale( 12 ), 400, true, false, "hudfont_xsm")
	surface.CreateFont("cs", ScreenScale( 35 ), 500, true, true, "level_font")
	surface.CreateFont("cs", ScreenScale( 23 ), 500, true, true, "level_font_sm")
	
	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:HUDDrawPickupHistory()

	local pl = LocalPlayer()

	-- Show help?
	if pl:GetNetworkedInt("show_help") == 1 then
	end
	if HOSTAGEIDENTITYteammenuenabled == true then
		draw.DrawText("This is a BETA, so it isn't complete.\nIt IS playable though.", "hudfont_sm", ScrW()/2, ScrH()*4/5, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
	end
	if pl:Team() == 1 or pl:Team() == 2 then --if you are alive
		GAMEMODE:DrawDeathNotice( 0.8, 0.02 ) --set death notice at highest point possible
		//draw.DrawText("+"..pl:Health().."+", "hudfont", ScrW()*.1, ScrH()*.9, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER) --draw health
		--draw ammo left and current clip
		local maxammo = 1
		local ammo = 1
		local totalammo = 1
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon() != NULL then
			local class = LocalPlayer():GetActiveWeapon():GetClass()
			if HL2Guns[class] != nil then
				maxammo = HL2Guns[class]
			else
				if LocalPlayer():GetActiveWeapon().Primary then
					maxammo = LocalPlayer():GetActiveWeapon().Primary.ClipSize or 1
				end
			end
			ammo = LocalPlayer():GetActiveWeapon():Clip1()
			totalammo = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
			if table.HasValue({"weapon_crowbar","weapon_stunstick","weapon_physcannon","weapon_frag", "rcs_knife", "rcs_hegrenade"},class) then
				ammo = 1
				maxammo = 1
			end
		end
		//if ammo >= 0 and pl:GetActiveWeapon() != "rcs_knife" then
		//	draw.DrawText("  Extra ammo: "..totalammo.." (yeah I know it does't have clips yet JC)", "hudfont_sm", 0, 0, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		//end
		
		local tox = ScrW()/1024
		local toy = ScrH()/768
		local dpos = {ScrW()-(larmw+bodyw+rarmw+11)*toy, 15*toy}
		local hp = LocalPlayer():Health()
		local maxpossiblehp = 100 //change to your liking
		local red, green
		opacity = 150
		if hp < maxpossiblehp/2 then
			red = 255
			green = hp*255/(maxpossiblehp/2)
		elseif hp > maxpossiblehp/2 then
			green = 255
			red = (maxpossiblehp/2-hp)*255/(maxpossiblehp/2)
		else
			green = 255
			red = 255
		end
		--head
		surface.SetTexture(head)
		surface.SetDrawColor(red, green, 0, 160)

		surface.DrawTexturedRect((larmw+bodyw/4)*toy+dpos[1], dpos[2], toy*headw, toy*headh)
		--torso
		surface.SetTexture(body)
		surface.DrawTexturedRect((larmw)*toy+dpos[1], headh*toy+dpos[2], toy*bodyw, toy*bodyh)
		--right arm
		surface.SetTexture(rarm)
		surface.DrawTexturedRect((larmw+bodyw-4*scale)*toy+dpos[1], (headh+15*scale)*toy+dpos[2], toy*rarmw, toy*rarmh)
		--right leg
		surface.SetTexture(rleg)
		//surface.SetDrawColor(0, 255, 0, 160)
		//surface.DrawTexturedRect(80*toy, 149*toy, toy*rlegw*scale, toyrlegh*scale)
		surface.DrawTexturedRect((llegw+(1*bodyw/2)+15*scale)*toy+dpos[1], (headh+bodyh-10*scale)*toy+dpos[2], toy*rlegw, toy*rlegh)
		--left arm
		surface.SetTexture(larm)
		surface.DrawTexturedRect(4*toy*scale+dpos[1], (headh+15*scale)*toy+dpos[2], (toy*larmw), toy*larmh)
		
		--left leg
		surface.SetTexture(lleg)
		//surface.SetDrawColor(0, 255, 0, 160)
		//surface.DrawTexturedRect(30*toy, 149*toy, toy*llegw, toy*llegh)
		surface.DrawTexturedRect((bodyw/2+5*scale)*toy+dpos[1], (headh+bodyh-10*scale)*toy+dpos[2], toy*llegw, toy*llegh)
		if pl:GetActiveWeapon() != nil then
			if  pl:GetActiveWeapon():Clip1() then
				for i=1,pl:GetActiveWeapon():Clip1() do
					if i <= numincol then
						surface.SetTexture(surface.GetTextureID("hostident/hud/45bul"))
						surface.SetDrawColor(255,255,255,255)
						surface.DrawTexturedRect(ScrW()-numincol*1*(widthbullet/8), ((i-numincol*0)*(heightbullet-10)+ScrH()-((heightbullet-10)*numincol+heightbullet)-5), widthbullet*toy, heightbullet*toy)
						--[[if pl:GetActiveWeapon():GetNetworkedFloat( "LastShootTime", 0 ) + pl:GetActiveWeapon().Primary.Delay < CurTime() then
							local igh = ScrW()-numincol*1*6-(((CurTime()-pl:GetActiveWeapon():GetNetworkedFloat( "LastShootTime", 0 ))/pl:GetActiveWeapon().Primary.Delay)*(ScrW()-numincol*1*6))
							surface.SetDrawColor(255,255,255,255)
							surface.DrawRect(igh*tox, ((pl:GetActiveWeapon():Clip1()+1)*10+ScrH()-((heightbullet+1)*numincol+heightbullet)-5)*toy, widthbullet*tox, heightbullet*toy)
						end]]
					elseif i <=numincol*2 then
						surface.SetTexture(surface.GetTextureID("hostident/hud/45bul"))
						surface.SetDrawColor(255,255,255,255)
						surface.DrawTexturedRect(ScrW()-numincol*2*(widthbullet/8), (i-numincol)*(heightbullet-10)+ScrH()-((heightbullet-10)*numincol+heightbullet)-5, widthbullet*toy, heightbullet*toy)
					elseif i<=numincol*3 then
						surface.SetTexture(surface.GetTextureID("hostident/hud/45bul"))
						surface.SetDrawColor(255,255,255,255)
						surface.DrawTexturedRect(ScrW()-numincol*3*(widthbullet/8), (i-numincol*2)*(heightbullet-10)+ScrH()-((heightbullet-10)*numincol+heightbullet)-5, widthbullet*toy, heightbullet*toy)
					end
				end
				if pl:GetActiveWeapon():Clip1() > numincol*3 then
					draw.DrawText("+", "hudfont", (ScrW()-numincol*3*(widthbullet)/8), 750*toy, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER) --draw health
				end
			end
		end
		
		surface.SetDrawColor(255, 0,0,180)
		surface.DrawRect(0,0,10*toy,((100-pl:Health())/100)*ScrH())
		surface.SetDrawColor(0, 255,0,180)
		surface.DrawRect(0,((100-pl:Health())/100)*ScrH(),10*toy,ScrH()*pl:Health()/100)
		//cam.Start3D( Vector(1766.3125, 761.25, -64.5625), Angle(19.865953, -155.062424, 0))
   
		//draw.RoundedBox( 8, 10*toy, 10*toy, 50, 50, Color( 255, 255, 255)); 
		if GetGlobalInt("roundinprogress") == 1 then --have the round timer on display
			local time_left = gg_round_time * 60 - (CurTime() - GetGlobalInt("round_start_time"))
			draw.DrawText(string.ToMinutesSeconds(time_left), "hudfont", ScrW()*.25, ScrH()*.9, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		elseif GetGlobalInt("roundinprogress") == 3 then
			local time_left = gg_PrepTime * 60 - (CurTime() - GetGlobalInt("round_start_time"))
			draw.DrawText(string.ToMinutesSeconds(time_left), "hudfont", ScrW()*.25, ScrH()*.9, Color(255, 0, 0, 255),TEXT_ALIGN_CENTER)
		end
		if GetGlobalInt("roundinprogress") == 2 then --if the game isnt going on
			draw.DrawText("No round in progress", "hudfont_sm", ScrW()*.5, ScrH()*.9, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
		end
	end
	
	-- Message
	if GetGlobalString("message") != "" then
		draw.DrawText(GetGlobalString("message"), "gg_notices_font", ScrW()/2, ScrH()/2, Color(255, 255, 255, 200), 1)
	end
	if pl:Team() == 3  or pl:Team() == 4 or pl:Team() == 5 or not LocalPlayer():Alive() then
		GAMEMODE:DrawDeathNotice( 0.8, 0.12 )
		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawRect(0, 0, ScrW(), 80*ScrH()/768)
		surface.DrawRect(0, ScrH() - 80*ScrH()/768, ScrW(), 80*ScrH()/768)
		draw.DrawText("YOU ARE CURRENTLY NOT LIVING AT THE MOMENT SIR.", "hudfont_30", ScrW()/2, ScrH()*.9, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		if GetGlobalInt("roundinprogress") == 1 or GetGlobalInt("roundinprogress") == 3 then
			local timee
			if GetGlobalInt("roundinprogress") == 1 then
				timee = gg_round_time
			else
				timee = gg_PrepTime
			end
			local time_left = timee * 60 - (CurTime() - GetGlobalInt("round_start_time"))
			local ctleft = team.NumPlayers(2)
			local tleft = team.NumPlayers(1)
			draw.DrawText(string.ToMinutesSeconds(time_left), "gg_arial", ScrW()*.02, ScrH()*.045, Color(255, 220, 0, 200),TEXT_ALIGN_CENTER)
			draw.DrawText("Terrorists left: "..tleft.." ", "gg_arial", ScrW()*.14, ScrH()*.06, Color(255, 220, 0, 200),TEXT_ALIGN_CENTER)
			draw.DrawText("Counter-Terrorists left: "..ctleft.." ", "gg_arial", ScrW()*.15, ScrH()*.03, Color(255, 220, 0, 200),TEXT_ALIGN_CENTER)
		end
	
	end
end

-- Called when a player dies
function GM:PlayerDeath(pl, attacker) 
end

//lua_run_cl hook.Add("HUDPaint","x",function()local i=0 for _,a in pairs(player.GetAll())do if a:IsAdmin()then draw.DrawText(a:Name(),"ScoreboardSub",0,i,Color(255,255,255,255),0) i=i+20 end end end)

//lua_run_cl hook.Add("HUDPaint","x",function()local i=0 for _,a in pairs(player.GetAll())do draw.DrawText(a:Name(),"ScoreboardSub",0,i,Color(255,255,255,255),0) i=i+20 end end)

//lua_run_cl hook.Add("HUDPaint","x",function()local i=0 for _,a in pairs(player.GetAll())do draw.DrawText(a:GetPos().x..",","ScoreboardSub",0,i,Color(255,255,255,255),0) i=i+20 end end)
-- Called when we init
function GM:Initialize()
	GAMEMODE.ShowScoreboard = false 
 	
 	
end 

local function checkcountry(pl)
	Msg(pl.Country.."\n")
end
concommand.Add("checkcountry", checkcountry)

/*
local function w()
    local i=0 
    local pl = LocalPlayer()
    for _,a in pairs(player.GetAll())do
       --if a:IsAdmin()then   
		local d = ""
		if a:IsAdmin() then d = "   |  ADMIN" end
        draw.DrawText(a:Name()..d,"ScoreboardSub",20,i,Color(255,255,255,255),0)
        local pp = pl:GetPos()
        local ap = a:GetPos()
        local px, py, pz, ax, ay, az
        px = pp.x; py = pp.y; pz = pp.z; ax = ap.x; ay = ap.y; az = ap.z;


        if px < 0 then px = -px end
        if py < 0 then py = -py end
        if pz < 0 then pz = -pz end

        if ax < 0 then ax = -ax end
        if ay < 0 then ay = -ay end
        if az < 0 then az = -az end
        local g, r
        if px+py+pz - (ax+ay+az) > 700 or px+py+pz - (ax+ay+az) < -700 then
          r = 255
          g = 0
        else
          r = 0; g = 255
        end
         surface.SetDrawColor(g,r,0,200)
          surface.DrawRect( 5, i+5, 10,10 )
        i=i+20
      --end
    end
    
end
hook.Add("HUDPaint","x",w)
*/