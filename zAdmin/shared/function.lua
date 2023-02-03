ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function startAttitude(lib, anim)
    Citizen.CreateThread(function()
		RequestAnimSet(anim)
		while not HasAnimSetLoaded(anim) do Citizen.Wait(MS) end
		SetPedMotionBlur(PlayerPedId(), false)
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnimAction(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
    end)
end

function CheckQuantity(number)
    number = tonumber(number)
    if type(number) == 'number' then
        number = ESX.Math.Round(number)
        if number > 0 then
            return true, number
        end
    end
    return false, number
end

function setClothes(value, plyPed, Index)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
                startAnimAction('clothingtie', 'try_tie_negative_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)
				if Index == 1 then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
                startAnimAction('re@construction', 'out_of_breath')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)
				if Index == 1 then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 52, ['pants_2'] = 0})
					else
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 49, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
                startAnimAction('random@domestic', 'pickup_low')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)
				if Index == 1 then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 45, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 46, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
                startAnimAction('anim@heists@ornate_bank@grab_cash', 'intro')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)
				if Index == 1 then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
                startAnimAction('clothingtie', 'try_tie_negative_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)
				AddArmourToPed(PlayerPedId(), 0)
    			SetPedArmour(PlayerPedId(), 0)
				if Index == 1 then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function setAccessory(accessory, Index)
	ESX.TriggerServerCallback('zAdmin:GetAccessoires', function(hasAccessory, accessorySkin)
		local _accessory = (accessory):lower()
		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0
				if _accessory == 'ears' then
					startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
					Citizen.Wait(250)
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'glasses' then
					mAccessory = 0
					startAnimAction('clothingspecs', 'try_glasses_positive_a')
					Citizen.Wait(1000)
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'helmet' then
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(1000)
					ClearPedTasks(PlayerPedId())
				elseif _accessory == 'mask' then
					mAccessory = 0
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(850)
					ClearPedTasks(PlayerPedId())
				end
				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end
				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		end
	end, accessory)
end

function randomStaff(model)
    clothesSkin = {}
    if model == GetHashKey("mp_m_freemode_01") then
		 clothesSkin = {
           ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 2,
            ['torso_1'] = 66, ['torso_2'] = 2,
            ['arms'] = 31,
            ['pants_1'] = 36, ['pants_2'] = 2,
            ['shoes_1'] = 95, ['shoes_2'] = 4,
        }
    else
        clothesSkin = {
            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 66, ['torso_2'] = 2,
            ['arms'] = 31, ['arms_2'] = 0,
            ['pants_1'] = 39, ['pants_2'] = 2,
            ['shoes_1'] = 77, ['shoes_2'] = 6,
        }
	end
    for k,v in pairs(clothesSkin) do
        TriggerEvent("skinchanger:change", k, v)
    end
end

function TPInMarker()
	if DoesBlipExist(GetFirstBlipInfoId(8)) then
		Citizen.CreateThread(function()
			local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
			local foundGround, zCoords, zPos = false, -500.0, 0.0
			while not foundGround do
				zCoords = zCoords + 10.0
				RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
				Citizen.Wait(0)
				foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)
				if not foundGround and zCoords >= 2000.0 then
					foundGround = true
				end
			end
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, zPos)
            ESX.ShowNotification("Evènement Illégal - Information(s)\nTéléportation effectué avec succès !")
		end)
	else
        ESX.ShowNotification("Evènement Illégal - Information(s)\nAucun marqueur")
	end
end

local noclip = false
local speednoclip = 1.0

local noclip = false
local noclip_speed = 0.5

function SetNoclip()
	noclip = true
	while noclip do
		ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter le NoClip\nMaintenez ~INPUT_FRONTEND_LS~ (SHIFT) pour un NoClip plus rapide")
		SetEntityVisible(GetPlayerPed(-1), false, false)	
		Wait(0)
		SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)
		if noclip then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed
			SetEntityVelocity(GetPlayerPed(-1), 0.0001, 0.0001, 0.0001)
			if IsControlPressed(0,32) then
				x = x+speed*dx
				y = y+speed*dy
				z = z+speed*dz
			end
			if IsControlPressed(0,21) then
				local speed = 5.5
				x = x+speed*dx
				y = y+speed*dy
				z = z+speed*dz
			end
			if IsControlPressed(0,269) then
				x = x-speed*dx
				y = y-speed*dy
				z = z-speed*dz
			end
			if IsControlJustPressed(0, 38) then
				noclip = false
				SetEntityVisible(PlayerPedId(), true, 0)
				SetEntityInvincible(PlayerPedId(), false)
			end
			SetEntityCoordsNoOffset(GetPlayerPed(-1),x,y,z,true,true,true)
		end
	end
end

function SetNoclipMapper()
	noclip = true
	while noclip do
		ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter le NoClip\nMaintenez ~INPUT_FRONTEND_LS~ (SHIFT) pour un NoClip plus rapide")
		SetEntityVisible(GetPlayerPed(-1), false, false)	
		Wait(0)
		SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)
		if noclip then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed
			SetEntityVelocity(GetPlayerPed(-1), 0.0001, 0.0001, 0.0001)
		if IsControlPressed(0,32) then
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end
		if IsControlPressed(0,21) then
			local speed = 5.5
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end
		if IsControlPressed(0,269) then
			x = x-speed*dx
			y = y-speed*dy
			z = z-speed*dz
		end
		if IsControlJustPressed(0, 38) then
			noclip = false
			SetEntityVisible(PlayerPedId(), true, 0)
			SetEntityInvincible(PlayerPedId(), false)
		end
		SetEntityCoordsNoOffset(GetPlayerPed(-1),x,y,z,true,true,true)
		end
	end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end
	return x,y,z
end

local spectate = false
function SpectatePlayer(player)
    spectate = not spectate
    local targetPed = GetPlayerPed(player)
    if (spectate) then
        DoScreenFadeOut(500)
        while (IsScreenFadingOut()) do Citizen.Wait(0) end
        NetworkSetInSpectatorMode(false, 0)
        NetworkSetInSpectatorMode(true, targetPed)
        DoScreenFadeIn(500)
    else
        DoScreenFadeOut(500)
        while (IsScreenFadingOut()) do Citizen.Wait(0) end
        NetworkSetInSpectatorMode(false, 0)
        DoScreenFadeIn(500)
    end
end

function ShowWarnMsg(title, msg, sec)
	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()
	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

RegisterNetEvent("zAdmin:WarnMessage")
AddEventHandler("zAdmin:WarnMessage", function(reason)
	SetAudioFlag("LoadMPData", 1)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	ShowWarnMsg("zAdmin | WARN", "Vous venez de vous faire Warn pour : "..reason, 5)
end)

function CinemaMode()
	CinemaMode = true
	while CinemaMode do
		Wait(5)
		DrawRect(0.471, 0.0485, 1.065, 0.13, 0, 0, 0, 255)
		DrawRect(0.503, 0.935, 1.042, 0.13, 0, 0, 0, 255)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()
    end
end

local jailed = false
local jail_time
local actual_jail
local jail_warn = 0

Citizen.CreateThread(function ()
    while true do
		WaitJail = 2000
        if jailed then
			WaitJail = 0
            local local_ped = GetPlayerPed(-1)
            local local_player = PlayerId()
            local player_coords = GetEntityCoords(local_ped)
            if GetDistanceBetweenCoords(player_coords, actual_jail.x, actual_jail.y, actual_jail.z, true) > 20 then
                ESX.ShowNotification("Evènement Illégal - Information(s)\nN'essayez pas de vous échapper ou votre peine sera augmenté")
                if jail_warn >= 2 then
                    ESX.ShowNotification("Evènement Illégal - Information(s)\nVotre peine a été augmentée ~b~" .. tostring(20) .. " ~s~minutes")
                    local time_add = 10 * 60
                    jail_time = jail_time + time_add
                end
                SetEntityCoords(local_ped, actual_jail.x, actual_jail.y, actual_jail.z)
                FreezeEntityPosition(local_ped, true)
                Citizen.Wait(1000)
                FreezeEntityPosition(local_ped, false)
                jail_warn = jail_warn + 1
            end
            if not GetPlayerInvincible(local_player) then
                SetPlayerInvincible(local_player, true)
            end
            if jail_time ~= nil then
                if jail_time <= 0 then
                    local player_server_id = GetPlayerServerId(PlayerId())
                    TriggerServerEvent("zAdmin:UnJail", player_server_id, false)
                else
                    jail_time = jail_time - 1
                end
            end
            Citizen.Wait(1000)
		else
			WaitJail = 2000
        end
        Citizen.Wait(WaitJail)
    end
end)

RegisterNetEvent("zAdmin:JailPly")
AddEventHandler("zAdmin:JailPly", function (time)
	local Source = source
		if Source ~= "" then
			if tonumber(Source) > 64 then
			local local_ped = GetPlayerPed(-1)
			local time_minutes = math.floor(time / 60)
			local Jail = vector3(1651.03, 2570.78, 45.56)
			actual_jail = Jail
			if jailed == false then
				SetEntityCoords(local_ped, Jail.x, Jail.y, Jail.z)
				FreezeEntityPosition(local_ped, true)
				jail_time = time
				jailed = true
                ESX.ShowNotification("Information(s)\nVous avez été enfermé pour ~b~" .. tostring(time_minutes) .. " " .."~s~minutes")
				Citizen.Wait(1000)
				FreezeEntityPosition(local_ped, false)
				FreezeEntityPosition(local_ped, false)
				while jailed  do
					Wait(0)
					RageUI.Text({ message = "Temps restant(s) : ~b~"..jail_time.."~s~ |  Seconde(s)", time_display = 1 })    
				end
			else
				jail_time = jail_time + time
                ESX.ShowNotification("Information(s)\nVous avez été enfermé pour ~b~" .. tostring(time_minutes) .. " " .."~s~minutes")
				FreezeEntityPosition(local_ped, false)
			end
		end
    end
end)

RegisterNetEvent("zAdmin:UnJailPly")
AddEventHandler("zAdmin:UnJailPly", function ()
    local Source = source
    if Source ~= "" then
        if tonumber(Source) > 64 then
            local local_ped = GetPlayerPed(-1)
            local local_player = PlayerId()
            ESX.ShowNotification("Information(s)\nVous avez purgé votre peine !")
            jailed = false
            jail_time = 0
			jail_time = nil
            SetPlayerInvincible(local_player, false)
            SetEntityCoords(local_ped, 1873.51, 2600.2, 45.67)
            SetPlayerInvincible(local_player, false)
        end
    end
end)

RegisterCommand('Handsup', function()
	local dict = "missminuteman_1ig_2"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	if not handsup then
		TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
		handsup = true
	else
		handsup = false
		ClearPedTasks(GetPlayerPed(-1))
	end
end)

RegisterKeyMapping('Handsup', 'Animation | Lever les mains', 'keyboard', '4')

Player = {
	crouched = false,
	handsup = false,
	pointing = false,
}

function stopPointing()
    local plyPed = PlayerPedId()
	RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')
	if not IsPedInjured(plyPed) then
		ClearPedSecondaryTask(plyPed)
	end
	SetPedConfigFlag(plyPed, 36, 0)
	ClearPedSecondaryTask(plyPed)
end

function startPointing(plyPed)	
	ESX.Streaming.RequestAnimDict('anim@mp_point', function()
		SetPedConfigFlag(plyPed, 36, 1)
		TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, 0, 'anim@mp_point', 24)
		RemoveAnimDict('anim@mp_point')
	end)
end

function Pommes()
	pomme = true
	while pomme do
		Wait(0)
		ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour se relever")
		SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
		if IsControlJustPressed(0,38) then
			ragdoll = false
			pomme = false
		end
	end
end

local ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.035, titleOffsetY = -0.018, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
local Sizes = {	timerBarWidth = 0.165, timerBarHeight = 0.035 , timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 } 
activeBars = {}

function AddTimerBar(title, itemData)
	if not itemData then return end
	RequestStreamedTextureDict("timerbars", true)
	local barIndex = #activeBars + 1
	activeBars[barIndex] = {
		title = title,
		text = itemData.text,
		textColor = itemData.color or { 255, 255, 255, 255 },
		percentage = itemData.percentage,
		endTime = itemData.endTime,
		pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
		pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
	}
	return barIndex
end

function RemoveTimerBar()
	activeBars = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function SecondsToClock(seconds)
	seconds = tonumber(seconds)
	if seconds <= 0 then
		return "00:00"
	else
		local mins = string.format("%02.f", math.floor(seconds / 60))
		local secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

function DrawText2(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
	SetTextFont(intFont)
	SetTextScale(floatScale, floatScale)
	if boolShadow then
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
	end
	SetTextColour(color[1], color[2], color[3], 255)
	if intAlign == 0 then
		SetTextCentre(true)
	else
		SetTextJustification(intAlign or 1)
		if intAlign == 2 then
			SetTextWrap(.0, addWarp or intPosX)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(stirngText)
	DrawText(intPosX, intPosY)
end	


local HideHudComponentThisFrame = HideHudComponentThisFrame
local GetSafeZoneSize = GetSafeZoneSize
local DrawSprite = DrawSprite
local DrawText2 = DrawText2
local DrawRect = DrawRect
local SecondsToClock = SecondsToClock
local GetGameTimer = GetGameTimer
local textColor = { 200, 100, 100 }
local math = math

Citizen.CreateThread(function()
	WaitActiveBars = 350
	while true do
		local safeZone = GetSafeZoneSize()
		local safeZoneX = (1.0 - GetSafeZoneSize()) * 0.5
		local safeZoneY = (1.0 - safeZone) * 0.5
		if #activeBars > 0 then
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
            WaitActiveBars = 0
			for i,v in pairs(activeBars) do
				local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
				DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
				DrawText2(0, v.title, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)
				if v.percentage then
					local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
					local pbarY = drawY + ScreenCoords.pbarOffsetY;
					local width = Sizes.pbarWidth * v.percentage;
					DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])
					DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
				elseif v.text then
					DrawText2(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
				elseif v.endTime then
					local remainingTime = math.floor(v.endTime - GetGameTimer())
					DrawText2(0, SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
				end
			end
        else
            WaitActiveBars = 1500
		end
        Wait(WaitActiveBars)
	end
end)

-- Events

-- functions events


local ObjTable = {}
local sended = false
local sound = GetSoundId()
local ObjNetId = 0
EventStop = false

RegisterNetEvent("Zortix:SendsEvents")
AddEventHandler("Zortix:SendsEvents", function(sEventsInfos, zone, time)
    EventStop = false
	SetAudioFlag("LoadMPData", 1)
	PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	activeBars = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
    if sEventsInfos.type == "drugs" then
        DrugsEvents(sEventsInfos, zone, time)
    elseif sEventsInfos.type == "brinks" then
        BrinksEvents(sEventsInfos, zone, time)
	elseif sEventsInfos.type == "caisse" then
		CaisseEvents(sEventsInfos, zone, time)
    end
end)

function BrinksEvents(sEventsInfos, zone, time)
    sended = false
    Citizen.CreateThread(function()
        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 616)
        SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.6)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Événement | Brinks")
        EndTextCommandSetBlipName(blip)
        ESX.ShowNotification("Evènement Illégal - Information(s)\n"..sEventsInfos.message)
		AddTimerBar("Temps restant(s)", {endTime=GetGameTimer()+time*60*1000})
		local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
		while dst > 150 do
			Wait(100)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
			if EventStop then return end
			if EventStop then break end
		end
		if not EventStop then
			local blinder = GetHashKey("Stockade")
			RequestModel(blinder)
			while not HasModelLoaded(blinder) do Wait(10) end
			local veh = CreateVehicle(blinder, zone, math.random(0.0,180.0), 0, 0)
			SetVehicleUndriveable(veh, 1)
			FreezeEntityPosition(veh, 1)
			SetVehicleAlarm(veh, 1)
			SetVehicleAlarmTimeLeft(veh, 999999.0*9999)
			for i = 1,9 do
				SetVehicleDoorOpen(veh, i, 0, 1)
			end
			table.insert(ObjTable, veh)
			local ArgentRecup = 0
			while ArgentRecup < 10 do
				Wait(1)
				local randomProp = sEventsInfos.prop[math.random(1, #sEventsInfos.prop)]
				RequestModel(GetHashKey(randomProp))
				while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
				local randomZone = vector3(zone.x+math.random(-6.0,6.0), zone.y+math.random(-6.0,6.0), zone.z)
				local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
				table.insert(ObjTable, obj)
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, 1)
				local ObjCoords = GetEntityCoords(obj)
				local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
				while dst > 2.0 do
					Wait(1)
					ObjCoords = GetEntityCoords(obj)
					dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
					DrawMarker(22, ObjCoords+0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
					if EventStop then return end
					if EventStop then break end
				end
				if not EventStop then
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
					ArgentRecup = ArgentRecup + 1
					local nombre = math.random(120, 200)
					ESX.ShowNotification("Vous avez ramasser : ~g~+"..nombre.."$")
					TriggerServerEvent("zAdmin:GetMoneyInsEvents", nombre)
					RemoveEventsObj(obj)
					if EventStop then return end
					if EventStop then break end
				end
				if ArgentRecup >= 10 then
					TriggerServerEvent("zAdmin:TakeRecInsEvents")
					StopSound(sound)
					sended = true
					for k,v in pairs(ObjTable) do
						RemoveEventsObj(v)
					end
					break
				end
				if EventStop then 
					ArgentRecup = 99 break 
				end
			end
			if not sended then
				StopSound(sound)
				TriggerServerEvent("zAdmin:TakeRecInsEvents")
				sended = true
			end
			StopSound(sound)
            ESX.ShowNotification("Evènement Illégal - Information(s)\nCargaison récupérée !")
			PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
		end
		for k,v in pairs(ObjTable) do
			RemoveEventsObj(v)
		end
		ObjTable = {}
		RemoveBlip(blip)
		RemoveTimerBar()
    end)
end

function DrugsEvents(sEventsInfos, zone, time)
    sended = false
    Citizen.CreateThread(function()
        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 615)
        SetBlipColour(blip, 1)
		SetBlipScale(blip, 0.6)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Événement | Drogue")
        EndTextCommandSetBlipName(blip)
        ESX.ShowNotification("Evènement Illégal - Information(s)\n"..sEventsInfos.message)
		AddTimerBar("Temps restant(s)", {endTime=GetGameTimer()+time*60*1000})
		local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
		while dst > 150 do
			Wait(100)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
			if EventStop then return end
			if EventStop then break end
		end
		if not EventStop then
			local DrogueRecup = 0
			while DrogueRecup < 10 do
				Wait(1)
				local randomProp = sEventsInfos.prop[math.random(1, #sEventsInfos.prop)]
				RequestModel(GetHashKey(randomProp))
				while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
				local randomZone = vector3(zone.x+math.random(-15.0,15.0), zone.y+math.random(-15.0,15.0), zone.z)
				local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
				ObjNetId = obj
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, 1)
				local ObjCoords = GetEntityCoords(obj)
				local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
				while dst > 2.0 do
					Wait(1)
					ObjCoords = GetEntityCoords(obj)
					dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
					DrawMarker(22, ObjCoords+0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
					if EventStop then return end
					if EventStop then break end
				end
				if not EventStop then
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
					RemoveEventsObj(ObjNetId)
					DrogueRecup = DrogueRecup + 1
					local nombre = math.random(1, 10)
					local item = sEventsInfos.item[math.random(1,#sEventsInfos.item)]
					TriggerServerEvent("zAdmin:GetItemInsEvents", item, nombre)
					if EventStop then return end
					if EventStop then break end
				end
				if DrogueRecup >= 10 then
					TriggerServerEvent("zAdmin:TakeRecInsEvents")
					sended = true
					break
				end
				if EventStop then 
					DrogueRecup = 99 break 
				end
			end
			if not sended then
				TriggerServerEvent("zAdmin:TakeRecInsEvents")
				sended = true
			end
            ESX.ShowNotification("Evènement Illégal - Information(s)\nCargaison récupérée !")
			PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
		end
		RemoveBlip(blip)
		RemoveTimerBar()
	end)
end

function CaisseEvents(sEventsInfos, zone, time)
    sended = false
    Citizen.CreateThread(function()
        blip = AddBlipForCoord(zone)
        SetBlipSprite(blip, 587)
        SetBlipColour(blip, 2)
		SetBlipScale(blip, 0.6)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Événement | Caisse mystère")
        EndTextCommandSetBlipName(blip)
        ESX.ShowNotification("Evènement - Information(s)\n"..sEventsInfos.message)
		AddTimerBar("Temps restant(s)", {endTime=GetGameTimer()+time*60*1000})
		local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
		while dst > 150 do
			Wait(100)
			dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), zone, true)
			if EventStop then return end
			if EventStop then break end
		end
		if not EventStop then
			local CaisseRecup = 0
			while CaisseRecup < 10 do
				Wait(1)
				local randomProp = sEventsInfos.prop[math.random(1, #sEventsInfos.prop)]
				RequestModel(GetHashKey(randomProp))
				while not HasModelLoaded(GetHashKey(randomProp)) do Wait(10) end
				local randomZone = vector3(zone.x, zone.y, zone.z)
				local obj = CreateObject(GetHashKey(randomProp), randomZone, 0, 0, 0)
				ObjNetId = obj
				PlaceObjectOnGroundProperly(obj)
				FreezeEntityPosition(obj, 1)
				local ObjCoords = GetEntityCoords(obj)
				local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
				while dst > 2.0 do
					Wait(1)
					ObjCoords = GetEntityCoords(obj)
					dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ObjCoords, 0)
					DrawMarker(22, ObjCoords+0.8, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
					if EventStop then return end
					if EventStop then break end
				end
				if not EventStop then
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 1)
					RemoveEventsObj(ObjNetId)
					CaisseRecup = CaisseRecup + 1
					local item = sEventsInfos.item[math.random(1,#sEventsInfos.item)]
					TriggerServerEvent("zAdmin:GetItemInsEvents", item, 1)
					if EventStop then return end
					if EventStop then break end
				end
				if CaisseRecup >= 1 then
					TriggerServerEvent("zAdmin:TakeRecInsEvents")
					sended = true
					break
				end
				if EventStop then 
					CaisseRecup = 99 break 
				end
			end
			if not sended then
				TriggerServerEvent("zAdmin:TakeRecInsEvents")
				sended = true
			end
            ESX.ShowNotification("Evènement - Information(s)\nCargaison récupérée !")
			PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
		end
		RemoveBlip(blip)
		RemoveTimerBar()
	end)
end

-- Events des events xD

RegisterNetEvent("zAdmin:StopsEvents")
AddEventHandler("zAdmin:StopsEvents", function(delete)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Criminal_Damage_High_Value", "Criminal_Damage_High_Value", 1)
    PlaySoundFrontend(-1, "Checkpoint_Cash_Hit", "GTAO_FM_Events_Soundset", 1)
    ESX.ShowNotification("Evènement - Information(s)\nÉvénement Terminé ! Tu n'étais pas encore arrivé ? vient plus rapidement la prochaine fois !")
    EventStop = true
    StopSound(GetSoundId())
	RemoveTimerBar()
    RemoveBlip(blip)
    for k,v in pairs(ObjTable) do
        RemoveEventsObj(v)
    end
end)

function RemoveEventsObj(id)
    local entity = id
    SetEntityAsMissionEntity(entity, true, true)
    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(entity) do
        Wait(100)
        timeout = timeout - 100
    end
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(entity))
    if (DoesEntityExist(entity)) then 
        DeleteEntity(entity)
    end 
end

--[[
	SetAudioFlag("LoadMPData", 1)
    PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
]]

RegisterNetEvent('cmg3_animations2:syncTarget')
AddEventHandler('cmg3_animations2:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if holdingHostageInProgress then 
		holdingHostageInProgress = false 
	else 
		holdingHostageInProgress = true
	end
	if beingHeldHostage then 
		beingHeldHostage = false 
	else 
		beingHeldHostage = true 
	end  
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then 
		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	end
	if controlFlag == nil then controlFlag = 0 end
	if animation2 == "victim_fail" then 
		SetEntityHealth(GetPlayerPed(-1),0)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
		holdingHostageInProgress = false 
	elseif animation2 == "shoved_back" then 
		holdingHostageInProgress = false 
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false	
	end
end)

RegisterNetEvent('cmg3_animations2:syncMe')
AddEventHandler('cmg3_animations2:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	if animation == "perp_fail" then 
		SetPedShootsAtCoord(GetPlayerPed(-1), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(GetPlayerPed(-1))
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('cmg3_animations2:cl_stop')
AddEventHandler('cmg3_animations2:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

function GetPlayers()
    local players = {}
	for _, i in ipairs(GetActivePlayers()) do
        table.insert(players, i)
    end
    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

Citizen.CreateThread(function()
	while true do 
		if holdingHostage then
			if GetEntityHealth(GetPlayerPed(-1)) <= 102 then
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations2:stop",target)
				Wait(100)
				releaseHostage()
			end 
			DisableControlAction(0,24,true) 
			DisableControlAction(0,25,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,58,true)
			DisablePlayerFiring(GetPlayerPed(-1),true)
			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
			DText3D(playerCoords.x,playerCoords.y,playerCoords.z,"Appuyez sur [G] pour relacher, [H] pour tuer")
			if IsDisabledControlJustPressed(0,47) then
				holdingHostage = false
				holdingHostageInProgress = false 
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations2:stop",target)
				Wait(100)
				releaseHostage()
			elseif IsDisabledControlJustPressed(0,74) then
				holdingHostage = false
				holdingHostageInProgress = false 		
				local closestPlayer = GetClosestPlayer(2)
				target = GetPlayerServerId(closestPlayer)
				TriggerServerEvent("cmg3_animations2:stop",target)				
				killHostage()
			end
		end
		if beingHeldHostage then 
			DisableControlAction(0,21,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,75,true)
			DisableControlAction(27,75,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,271,true)
		end
		Wait(0)
	end
end)

function DText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.19, 0.19)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function releaseHostage()
	local player = PlayerPedId()	
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11
	distans2 = -0.24
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		TriggerServerEvent('cmg3_animations2:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end
end 

function killHostage()
	local player = PlayerPedId()	
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11
	distans2 = -0.24 
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		TriggerServerEvent('cmg3_animations2:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end	
end 

function drawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LoadAnimationDictionary(animationD)
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Citizen.Wait(1)
	end
end

RegisterNetEvent('esx_barbie_lyftupp2:upplyft')
AddEventHandler('esx_barbie_lyftupp2:upplyft', function(target)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	local lPed = GetPlayerPed(-1)
	local dict = "amb@code_human_in_car_idles@low@ps@"
	if isCarry == false then
		LoadAnimationDictionary("amb@code_human_in_car_idles@generic@ps@base")
		TaskPlayAnim(lPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)
		isCarry = true
		IsLiftup = true
	else
		DetachEntity(GetPlayerPed(-1), true, false)
		ClearPedTasksImmediately(targetPed)
		ClearPedTasksImmediately(GetPlayerPed(-1))
		ClearPedSecondaryTask(GetPlayerPed(-1))
		IsLiftup = false
		isCarry = false
	end
end)

RegisterNetEvent('esx_barbie_lyftupp2:syncTarget')
AddEventHandler('esx_barbie_lyftupp2:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	piggyBackInProgress = true
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)


RegisterNetEvent('esx_barbie_lyftupp2:syncMe')
AddEventHandler('esx_barbie_lyftupp2:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	Citizen.Wait(length)
end)

RegisterNetEvent('esx_barbie_lyftupp2:cl_stop')
AddEventHandler('esx_barbie_lyftupp2:cl_stop', function()
	piggyBackInProgress = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	piggyBackInProgress = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)


-- Dev Tool

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

Citizen.CreateThread(function()
    for i = 1, 43 do
        table.insert(Config.TypeMarker, i)
    end
    for i = 1, 10 do
        table.insert(Config.HeightMarker, i)
    end
    for i = 1, 8 do
        table.insert(Config.RotateMarker, i)
    end

end)

function TeleportBlips()
    local entity = PlayerPedId()
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    local success = false
    local blipFound = false
    local blipIterator = GetBlipInfoIdIterator()
    local blip = GetFirstBlipInfoId(8)
    while DoesBlipExist(blip) do
        if GetBlipInfoIdType(blip) == 4 then
            cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
            blipFound = true
            break
        end
        blip = GetNextBlipInfoId(blipIterator)
        Wait(0)
    end
    if blipFound then
        local groundFound = false
        local yaw = GetEntityHeading(entity)
        for i = 0, 1000, 1 do
            SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
            SetEntityRotation(entity, 0, 0, 0, 0, 0)
            SetEntityHeading(entity, yaw)
            Wait(0)
            if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                cz = ToFloat(i)
                groundFound = true
                break
            end
        end
        if not groundFound then
            cz = -300.0
        end
        success = true
    else
        ESX.ShowNotification("~r~Aucun point sur la carte")
    end
    if success then
        ESX.ShowNotification("~g~Vous avez été téléporter sur le marker avec succès")
        SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
            end
        end
    end
end

function CreateCamProps()
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(camera, -1267.07, -3025.49, -48.49)
    SetCamFov(camera, 45.0)
    AttachCamToEntity(SpawnProps, PlayerPedId())
	RenderScriptCams(1, 1, 1000, 1, 1)
end

function TeleportIPLProps()
    GetOldEntityCoord = GetEntityCoords(PlayerPedId())
    DoScreenFadeOut(1000)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), -1267.07, -3025.49, -48.49)
    TriggerServerEvent("zDevTool:setPlayerToBucket")
    SetEntityVisible(PlayerPedId(), false)
    Wait(500)
    DoScreenFadeIn(1000)
    CreateCamProps()
end

function ReturnOldPosition()
    DoScreenFadeOut(1000)
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(camera, false)
    DeleteEntity(SpawnProps)
    Wait(1000)
    SetEntityCoords(PlayerPedId(), GetOldEntityCoord)
    TriggerServerEvent("zDevTool:setPlayerToNormalBucket")
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(1000)
end

--- ban 

