--[[   _                                 
     ( )                                
    _| |   __   _ __   ___ ___     _ _  
  /'_` | /'__`\( '__)/' _ ` _ `\ /'_` ) 
 ( (_| |(  ___/| |   | ( ) ( ) |( (_| | 
 `\__,_)`\____)(_)   (_) (_) (_)`\__,_)  
  
 	DFrame 
 	 
 	A window. 
  
 ]] 
   
 PANEL = {} 
   
 AccessorFunc( PANEL, "m_bDraggable", 		"Draggable", 		FORCE_BOOL ) 
 AccessorFunc( PANEL, "m_bSizable", 			"Sizable", 			FORCE_BOOL ) 
 AccessorFunc( PANEL, "m_bScreenLock", 		"ScreenLock", 		FORCE_BOOL ) 
 AccessorFunc( PANEL, "m_bDeleteOnClose", 	"DeleteOnClose", 	FORCE_BOOL ) 
   
 AccessorFunc( PANEL, "m_bBackgroundBlur", 	"BackgroundBlur", 	FORCE_BOOL ) 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:Init() 
   
 	self:SetFocusTopLevel( true ) 
   
 //	self:SetCursor( "sizeall" ) 
 	 
 	self.btnClose = vgui.Create( "DSysButton", self ) 
 	self.btnClose:SetType( "close" ) 
 	self.btnClose.DoClick = function ( button ) self:Close() end 
 	self.btnClose:SetDrawBorder( false ) 
 	self.btnClose:SetDrawBackground( false ) 
 	 
 	self.lblTitle = vgui.Create( "DLabel", self ) 
 	 
 	self:SetDraggable( true ) 
 	self:SetSizable( false ) 
 	self:SetScreenLock( true ) 
 	self:SetDeleteOnClose( true ) 
 	self:SetTitle( "#Untitled DFrame" ) 
 	 
 	// This turns off the engine drawing 
 	self:SetPaintBackgroundEnabled( false ) 
 	self:SetPaintBorderEnabled( false ) 
 	 
 	self.m_fCreateTime = SysTime() 
   
 end 
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:ShowCloseButton( bShow ) 
   
 	self.btnClose:SetVisible( bShow ) 
   
 end 
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:SetTitle( strTitle ) 
   
 	self.lblTitle:SetText( strTitle ) 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:Close() 
   
 	self:SetVisible( false ) 
   
 	if ( self:GetDeleteOnClose() ) then 
 		self:Remove() 
 	end 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:Center() 
   
 	self:InvalidateLayout( true ) 
 	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 ) 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:Think() 
   
 	if (!self.Dragging) then return end 
 	 
 	local x = gui.MouseX() - self.Dragging[1] 
 	local y = gui.MouseY() - self.Dragging[2] 
   
 	-- Lock to screen bounds if screenlock is enabled 
 	if ( self:GetScreenLock() ) then 
 	 
 		x = math.Clamp( x, 0, ScrW() - self:GetWide() ) 
 		y = math.Clamp( y, 0, ScrH() - self:GetTall() ) 
 	 
 	end 
 	 
 	self:SetPos( x, y ) 
 	 
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:Paint() 
   
 	--[[if ( self.m_bBackgroundBlur ) then 
 		Derma_DrawBackgroundBlur( self, self.m_fCreateTime ) 
 	end 
   
 	derma.SkinHook( "Paint", "Frame", self ) ]]
 	return true 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:OnMousePressed() 
   
 	if ( !self:GetDraggable() ) then return end 
   
 	self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y } 
 	self:MouseCapture( true ) 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:OnMouseReleased() 
   
 	self.Dragging = nil 
 	self:MouseCapture( false ) 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:PerformLayout() 
   
 	derma.SkinHook( "Layout", "Frame", self ) 
   
 end 
   
   
 --[[--------------------------------------------------------- 
  
 ---------------------------------------------------------]] 
 function PANEL:IsActive() 
   
 	if ( self:HasFocus() ) then return true end 
 	if ( vgui.FocusedHasParent( self ) ) then return true end 
 	 
 	return false 
   
 end 
   
   
 derma.DefineControl( "HIFrame", "A simplle window", PANEL, "EditablePanel" ) 
 
 
 


--team select menu
local COUNTRY_UK = 1
local COUNTRY_US = 2
local COUNTRY_FRANCE = 3
local COUNTRY_BELGIUM = 4
local COUNTRY_SWITZ = 5
local COUNTRY_AUSTRIA = 6
local COUNTRY_GERMANY = 7
local COUNTRY_ISRAEL = 8
local dir = "hostident/hud/"
local dir2 = "hostident/flags/"
local lolwut = "select.vtf"
local imgh = Material(dir.."Tselect"):GetMaterialTexture( "$basetexture" ):GetActualHeight()*ScrH()/768
local imgw = Material(dir.."Tselect"):GetMaterialTexture( "$basetexture" ):GetActualWidth()*ScrH()/768

local function SetCT(pl)
	if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(2) + team.NumPlayers(5) + team.NumPlayers(1) + team.NumPlayers(4) >=1) then
		pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter Terrorists!")
	else
		local dim = (ScrW()-20)/4
		local teammenu = vgui.Create("HIFrame")
		local UK = vgui.Create( "DImageButton", DermaPanel )
		local US = vgui.Create( "DImageButton", DermaPanel )
		local FRANCE = vgui.Create( "DImageButton", DermaPanel )
		local BELGIUM = vgui.Create( "DImageButton", DermaPanel )
		local SWITZ = vgui.Create( "DImageButton", DermaPanel )
		local AUSTRIA = vgui.Create( "DImageButton", DermaPanel )
		local GERMANY = vgui.Create( "DImageButton", DermaPanel )
		local ISRAEL = vgui.Create( "DImageButton", DermaPanel )
		local close = vgui.Create( "DImageButton", DermaPanel )
		UK:SetImage(dir2.."UK")
		US:SetImage(dir2.."US")
		FRANCE:SetImage(dir2.."FRANCE")
		BELGIUM:SetImage(dir2.."BELGIUM")
		SWITZ:SetImage(dir2.."SWITZ")
		AUSTRIA:SetImage(dir2.."AUSTRIA")
		GERMANY:SetImage(dir2.."GERMANY")
		ISRAEL:SetImage(dir2.."ISRAEL")
		close:SetImage(dir.."closewindow.vtf")
		UK:SizeToContents()
		US:SizeToContents()
		FRANCE:SizeToContents()
		BELGIUM:SizeToContents()
		SWITZ:SizeToContents()
		AUSTRIA:SizeToContents()
		GERMANY:SizeToContents()
		ISRAEL:SizeToContents()
		close:SizeToContents()
		teammenu:SetPos(0,-10)
		teammenu:SetSize(ScrW(),ScrH())
		teammenu:SetDraggable(false)
		teammenu:SetTitle( "Select Country" )
		teammenu:SetVisible( true )
		teammenu:ShowCloseButton(false)
		teammenu:MakePopup()
		US:SetParent( teammenu )
		UK:SetParent( teammenu )
		FRANCE:SetParent( teammenu )
		BELGIUM:SetParent( teammenu )
		SWITZ:SetParent( teammenu )
		AUSTRIA:SetParent( teammenu )
		GERMANY:SetParent( teammenu )
		ISRAEL:SetParent( teammenu )
	    local yC = ScrH()/2
	    local space = ScrH()/6
	    local sY = space
	    local eY = ScrH()-space
	    local hBox = (eY-sY)/4
	    local wBox = ((eY-sY)/4)*4/3
	    local xToStartBox = (ScrW()-(wBox*2))/2
	    //g.fillRect( + 3, wBox,hBox);
		US:SetPos(xToStartBox, space)
		US:SetSize( wBox,hBox )
		US.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_US)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		UK:SetPos(xToStartBox + wBox, space)
		UK:SetSize( wBox,hBox )
		UK.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_UK)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		FRANCE:SetPos(xToStartBox, space+hBox)
		FRANCE:SetSize( wBox,hBox )
		FRANCE.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_FRANCE)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		BELGIUM:SetPos(xToStartBox+wBox, space+ hBox)
		BELGIUM:SetSize( wBox,hBox )
		BELGIUM.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_BELGIUM)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		SWITZ:SetPos(xToStartBox, space + hBox * 2)
		SWITZ:SetSize( wBox,hBox )
		SWITZ.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_SWITZ)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		AUSTRIA:SetPos(xToStartBox + wBox, space+ hBox * 2)
		AUSTRIA:SetSize( wBox,hBox )
		AUSTRIA.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_AUSTRIA)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		GERMANY:SetPos(xToStartBox, space+ hBox * 3)
		GERMANY:SetSize( wBox,hBox )
		GERMANY.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_GERMANY)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		
		ISRAEL:SetPos(xToStartBox + wBox,   space + hBox * 3)
		ISRAEL:SetSize( wBox,hBox )
		ISRAEL.DoClick = function ( btn )
			if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(1) + team.NumPlayers(4) + team.NumPlayers(2) + team.NumPlayers(5) >=1) then
				pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter-Terrorists!")
			else
				pl:ConCommand("teamset 5 "..COUNTRY_ISRAEL)
				HOSTAGEIDENTITYteammenuenabled = false
				pl.alive = 0
				pl.notspectator = true
				teammenu:Close()
			end
		end
		
		close:SetText( "cloze" )
		close:SetPos(ScrH()-50*(ScrH()/768), ScrH()-50*(ScrH()/768))
		close:SetSize( 50*(ScrH()/768), 50*(ScrH()/768) )
		close.DoClick = function ( btn )
			HOSTAGEIDENTITYteammenuenabled = false
			teammenu:Close()
		end
		close:SetParent( teammenu )
		
	end
end
local function TeamMenu(pl)
	HOSTAGEIDENTITYteammenuenabled = true
	local teammenu = vgui.Create("HIFrame")
	local terr = vgui.Create( "DImageButton", DermaPanel )
	local ct = vgui.Create( "DImageButton", DermaPanel )
	local spec = vgui.Create( "DImageButton", DermaPanel )
	local close = vgui.Create( "DImageButton", DermaPanel )
	local dim = (ScrW()-20)/4
	terr:SetImage(dir.."T"..lolwut)
	ct:SetImage(dir.."CT"..lolwut)
	spec:SetImage(dir.."SPEC"..lolwut)
	close:SetImage(dir.."closewindow.vtf")
	ct:SizeToContents()
	close:SizeToContents()
	terr:SizeToContents()
	spec:SizeToContents()
	teammenu:SetPos(ScrW()/2-dim,-10)
	teammenu:SetSize(dim + ScrW()/2, ScrH()+(dim+ScrH()-dim*2.5)*0)
	teammenu:SetTitle( "Select Team" )
	teammenu:SetVisible( true )
	teammenu:SetDraggable(false)
	teammenu:ShowCloseButton(false)
	teammenu:MakePopup()
	
	//local actualwidth = imgw*((ScrH()-20)/3-5)/imgh
	terr:SetParent( teammenu )
	terr:SetText( "Terrorists" )
	terr:SetPos(0, 20)//ScrW()/2-dim
	//terr:SetSize( actualwidth, (ScrH()-20)/3-5 )
	terr:SetSize( dim, dim )
	terr.DoClick = function ( btn )
		if (team.NumPlayers(1) + team.NumPlayers(4) > team.NumPlayers(2) + team.NumPlayers(5) + gg_overstocklimit) and (team.NumPlayers(2) + team.NumPlayers(5) + team.NumPlayers(1) + team.NumPlayers(4) >=1) then
			pl:PrintMessage (HUD_PRINTCENTER, "There are too many Terrorists!")
		else
			pl:ConCommand("teamset 4")
			HOSTAGEIDENTITYteammenuenabled = false
			pl.alive = 0
			pl.notspectator = true
			teammenu:Close()
		end
	end
	
	ct:SetParent( teammenu ) -- parent the button to the frame
	ct:SetText( "Counter Terrorists" ) -- set the button text
	//ct:SetPos(5, (ScrH()-20)/3+15) -- set the button position in the frame
	ct:SetPos(dim, 20) -- set the button position in the frame //ScrW()/2
	//ct:SetSize( actualwidth, (ScrH()-20)/3-5 ) -- set the button size
	ct:SetSize( dim, dim )
	ct.DoClick = function ( btn )
		if (team.NumPlayers(2) + team.NumPlayers(5) > team.NumPlayers(1) + team.NumPlayers(4) + gg_overstocklimit) and (team.NumPlayers(2) + team.NumPlayers(5) + team.NumPlayers(1) + team.NumPlayers(4) >=1) then
			pl:PrintMessage (HUD_PRINTCENTER, "There are too many Counter Terrorists!")
		else
			//pl:ConCommand("teamset 5")
			//pl.alive = 0
			HOSTAGEIDENTITYteammenuenabled = false
			//pl.notspectator = true
			teammenu:Close()
			SetCT(pl)
		end
	end -- ending the doclick function
	
	spec:SetParent( teammenu ) -- parent the button to the frame
	spec:SetText( "Spectator" ) -- set the button text
	//spec:SetPos(5, (ScrH()-20)*2/3+5) -- set the button position in the frame
	//spec:SetSize(actualwidth, (ScrH()-20)/3-5 ) -- set the button size
	spec:SetPos(0, dim+25) -- set the button position in the frame//ScrW()/2-dim
	spec:SetSize( dim*2, ScrH()-dim*2.5-5 )
	spec.DoClick = function ( btn )
		pl:SetColor(255, 255, 255, 0)
		pl.alive = 0
		HOSTAGEIDENTITYteammenuenabled = false
		pl:ConCommand("teamset 3")
		pl.was_alive = 0
		pl.notspectator = false
		teammenu:Close()
	end -- ending the doclick function
	
	close:SetText( "cloze" )
	close:SetPos(ScrH()-50*(ScrH()/768), ScrH()-50*(ScrH()/768))
	close:SetSize( 50*(ScrH()/768), 50*(ScrH()/768) )
	close.DoClick = function ( btn )
		HOSTAGEIDENTITYteammenuenabled = false
		teammenu:Close()
	end
	close:SetParent( teammenu )
end
concommand.Add("TeamMenu",TeamMenu)
concommand.Add("TeamMenu_ct",SetCT)