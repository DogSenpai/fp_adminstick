local ply = LocalPlayer()

---------------------------------------------------------------------------------NOTIFICATION HANDLER-----------------------------------------------------------------
net.Receive("fp_as_notificationHandler", function(ply,len)

    local string = net.ReadString()
    local icon = net.ReadDouble()

    notification.AddLegacy(string, icon, 5)
    surface.PlaySound( "buttons/button15.wav" )

end)

---------------------------------------------------------------------------------MAIN MENU (LEFT CLICK)-----------------------------------------------------------------
net.Receive("fp_as_moderate", function()

	local m = vgui.Create("DMenu", p)
	local tar = net.ReadEntity()
	local plyPic = "icon16/user.png"
	
	if tar:IsBot() then plyPic = "icon16/drive_user.png" end

	m:AddOption(tar:Nick().." | "..tar:SteamID()):SetIcon(plyPic)

	m:AddSpacer()
		
	m:AddOption("Return", function()
		RunConsoleCommand("ulx","return",tar:Name())
	end):SetIcon("icon16/arrow_undo.png")

	local sm1 = m:AddSubMenu("Additional Information:")
		sm1:AddOption(tar:getDarkRPVar("rpname")):SetIcon("icon16/page_white.png")
		sm1:AddOption(tar:SteamID()):SetIcon("icon16/vcard.png")
		sm1:AddOption(tar:Health()):SetIcon("icon16/heart.png")
		sm1:AddOption(tar:Armor()):SetIcon("icon16/shield.png")
		sm1:AddOption(tar:getDarkRPVar("job")):SetIcon("icon16/user_suit.png")
		sm1:AddOption(tar:getDarkRPVar("money")):SetIcon("icon16/money.png")
		
		local sm2 = m:AddSubMenu("Administration:") --ADMINISTRATION
	sm2:AddOption("Add/Subtract Money", function()
		moneyMenu(tar)
	end):SetIcon("icon16/money.png")
		
	sm2:AddOption("Kick", function()
		kickMenu(tar)
	end):SetIcon("icon16/door_out.png")
	
	sm2:AddOption("Ban", function()
		banMenu(tar)
	end):SetIcon("icon16/cancel.png")
	
	sm2:AddOption("Noclip", function()
		RunConsoleCommand("ulx","noclip",tar:Name())
	end):SetIcon("icon16/attach.png")
	
		local sm3 = m:AddSubMenu("Moderation:") --MODERATION
	sm3:AddOption("Set Health", function()
		healthMenu(tar)
	end):SetIcon("icon16/heart.png")

	sm3:AddOption("Set Armor", function()
		armorMenu(tar)
	end):SetIcon("icon16/shield.png")
	
	if cfg_buildermode then
		sm3:AddOption("Toggle Buildermode", function()
			net.Start("fp_as_stickToggle")
				net.WriteEntity(tar)
			net.SendToServer(ply)
		end):SetIcon("icon16/wrench.png")
	end
	
	if cfg_usesdistress then
		sm3:AddOption("Toggle Distress", function()
			if tar:GetNWBool("distress") then
				tar:SetNWBool("distress", false)
			else
				tar:SetNWBool("distress", true)
			end
		end):SetIcon("icon16/exclamation.png")
	end
	
	sm3:AddOption("Jail", function()
		jailMenu(tar)
	end):SetIcon("icon16/lock_add.png")
	
	sm3:AddOption("Quick-jail (2 min.)", function()
		RunConsoleCommand("ulx","jail",tar:Name(),120)
	end):SetIcon("icon16/lock_go.png")
	
	sm3:AddOption("Slay", function()
		RunConsoleCommand("ulx","slay",tar:Name())
	end):SetIcon("icon16/emoticon_tongue.png")
	
	sm3:AddOption("Gag/Ungag (mute/unmute microphone)", function()
		if tar:GetNWBool("ulx_gagged", true) then
			RunConsoleCommand("ulx","ungag",tar:Name())
		else
			RunConsoleCommand("ulx","gag",tar:Name())
		end
	end):SetIcon("icon16/sound_mute.png")

	sm3:AddOption("Gimp/Ungimp (mute/unmute chat)", function()
		if tar:GetNWBool("ulx_gimped", true) then
			RunConsoleCommand("ulx","ungimp",tar:Name())
		else
			RunConsoleCommand("ulx","gimp",tar:Name())
		end
	end):SetIcon("icon16/comment_delete.png")
	
	sm3:AddOption("Strip Weapons", function()
		RunConsoleCommand("ulx","strip",tar:Name())
	end):SetIcon("icon16/package_delete.png")

	m:Open()
	m:SetPos(ScrW()/2, ScrH()/2)

end)

----------------------------------------------------PLAYER LIST (RELOAD)----------------------------------------------------------------
net.Receive("fp_as_listPlayers", function()

	local m = vgui.Create("DMenu", p)
	m:AddOption("Player List"):SetIcon("icon16/script.png")
	m:AddSpacer()
	
	for _,v in ipairs(player.GetAll()) do
	
		local sm = m:AddSubMenu(v:Nick())
		
		sm:AddOption("Bring", function()
			RunConsoleCommand("ulx","bring",v:Name())
		end):SetIcon("icon16/user_go.png")
		
		sm:AddOption("Goto", function()
			RunConsoleCommand("ulx","goto",v:Name())
		end):SetIcon("icon16/shield_go.png")
		
		sm:AddOption("Unjail", function()
			RunConsoleCommand("ulx","unjail",v:Name())
		end):SetIcon("icon16/lock_open.png")
		
	end
	
	m:Open()
	m:SetPos(ScrW()/2, ScrH()/2)

end)

----------------------------------------------------DERMA MENUES----------------------------------------------------------------
function armorMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,50)
		dp:Center()
		dp:SetTitle("Provide Armor Amount")
		dp:MakePopup()
		
		local dte = vgui.Create("DTextEntry",dp)
		dte:SetSize(175,20)
		dte:SetPos(0,25)
		dte:CenterHorizontal()
		dte:SetValue("Armor amount...")
		dte.OnGetFocus = function(self) self:SetValue("") end
		dte.OnEnter = function(self)
			local val = tonumber(self:GetValue())
			RunConsoleCommand("ulx","armor",tar:Name(),val)
			dp:Close()
		end 

end

function healthMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,50)
		dp:Center()
		dp:SetTitle("Provide Health Amount")
		dp:MakePopup()
		
		local dte = vgui.Create("DTextEntry",dp)
		dte:SetSize(175,20)
		dte:SetPos(0,25)
		dte:CenterHorizontal()
		dte:SetValue("Health amount...")
		dte.OnGetFocus = function(self) self:SetValue("") end
		dte.OnEnter = function(self)
			local val = tonumber(self:GetValue())
			RunConsoleCommand("ulx","hp",tar:Name(),val)
			dp:Close()
		end 

end

function moneyMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,50)
		dp:Center()
		dp:SetTitle("Provide Money Amount")
		dp:MakePopup()
		
		local dte = vgui.Create("DTextEntry",dp)
		dte:SetSize(175,20)
		dte:SetPos(0,25)
		dte:CenterHorizontal()
		dte:SetValue("Amount... (add a '-' for subtraction)")
		dte.OnGetFocus = function(self) self:SetValue("") end
		dte.OnEnter = function(self)
			val = self:GetValue():gsub(";", "")
			
			net.Start("fp_as_moneyHandler")
				net.WriteEntity(tar)
				net.WriteDouble(val)
			net.SendToServer(ply)
			
			dp:Close()
		end 

end

function jailMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,50)
		dp:Center()
		dp:SetTitle("Provide Jail Time")
		dp:MakePopup()
		
		local dte = vgui.Create("DTextEntry",dp)
		dte:SetSize(175,20)
		dte:SetPos(0,25)
		dte:CenterHorizontal()
		dte:SetValue("How long (in seconds) to jail...")
		dte.OnGetFocus = function(self) self:SetValue("") end
		dte.OnEnter = function(self)
			local val = tonumber(self:GetValue())
			if val == 0 or val > 1800 then
				notification.AddLegacy("Jail time must be higher than 0 and lower than 1800!", 1, 5)
				surface.PlaySound( "buttons/button15.wav" )
			else
				RunConsoleCommand("ulx","jail",tar:Name(),val)
				dp:Close()
			end
		end 
		
end

function banMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,100)
		dp:Center()
		dp:SetTitle("Provide Reason & Time")
		dp:MakePopup()

		local dte1 = vgui.Create("DTextEntry",dp)
		dte1:SetSize(175,20)
		dte1:SetPos(0,25)
		dte1:CenterHorizontal()
		dte1:SetValue("Please provide a reason for banning...")
		dte1.OnGetFocus = function(self) self:SetValue("") end

		local dcb = vgui.Create("DComboBox", dp)
		dcb:SetPos(0,25+20+5)
		dcb:SetSize(120,20)
		dcb:SetValue("Ban time (minutes)")
		dcb:CenterHorizontal()
		dcb:AddChoice("10")
		dcb:AddChoice("30")
		dcb:AddChoice("60")
		dcb:AddChoice("120")
		dcb:AddChoice("300")
		dcb:AddChoice("600")
		dcb:AddChoice("1440")
		dcb:AddChoice("10080")
		dcb:AddChoice("40320")
		dcb:AddChoice("Permanently")
		dcb.OnSelect = function(pnl, index, value)
			if value == "Permanently" then value = 0 end
			newVal = tonumber(value)
			reason = dte1:GetValue():gsub(";", "")
			RunConsoleCommand("ulx","ban",tar:Name(),newVal,reason)
		end

		local dl = vgui.Create("DLabel",dp)
		dl:SetPos(0,25+20+5+20)
		dl:SetText([[Note: the moment you pick the
			ban time, the ban initiates!]])
		dl:SizeToContents()
		dl:CenterHorizontal()

end

function kickMenu(tar)

		local dp = vgui.Create("DFrame")
		dp:SetSize(200,50)
		dp:Center()
		dp:SetTitle("Provide Reason")
		dp:MakePopup()

		local dte = vgui.Create("DTextEntry",dp)
		dte:SetSize(175,20)
		dte:SetPos(0,25)
		dte:CenterHorizontal()
		dte:SetValue("Please provide a reason for kicking...")
		dte.OnGetFocus = function(self) self:SetValue("") end
		dte.OnEnter = function(self)
			reason = self:GetValue():gsub(";", "")
			RunConsoleCommand("ulx","kick",tar:Name(),reason)
			dp:Close()
		end

end

----------------------------------------------------------------------DOOR HANDLER--------------------------------------------------------------
net.Receive("fp_as_moderateDoor", function()

	local door = net.ReadEntity()
	local doorOwner = door:getDoorData()["owner"]
	local m = vgui.Create("DMenu", p)

	if doorOwner == nil then doorOwner = 0 end
	
	if doorOwner > 0 then
		m:AddOption(door:getDoorOwner():Nick().."'s Door"):SetIcon("icon16/door.png")
	else
		m:AddOption("Unowned Door"):SetIcon("icon16/door.png")
	end

	m:AddSpacer()
		
	m:AddOption("Unlock", function()
		net.Start("fp_as_doorHandler")
			net.WriteEntity(door)
			net.WriteString("unlock")
		net.SendToServer()
	end):SetIcon("icon16/lock_open.png")
	
	if doorOwner > 0 then
		m:AddOption("Remove Owner", function()
			local doorOwner = door:getDoorData().owner
			
			net.Start("fp_as_doorHandler")
				net.WriteEntity(door)
				net.WriteString("removeOwner")
				net.WriteDouble(doorOwner)
			net.SendToServer()
			
		end):SetIcon("icon16/key_delete.png")
	end
	
	m:AddOption("Lock", function()
		net.Start("fp_as_doorHandler")
			net.WriteEntity(door)
			net.WriteString("lock")
		net.SendToServer()
	end):SetIcon("icon16/lock.png")
	
	m:AddOption("Print Door Info", function()
		PrintTable(door:getDoorData())
	end):SetIcon("icon16/application_xp_terminal.png")
	
	m:Open()
	m:SetPos(ScrW()/2, ScrH()/2)

end)
