ESX = {};

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local gamertag = {
    ["user"] = "Joueurs",
    ["help"] = "Helpeur",
    ["mod"] = "Modo",
    ["admin"] = "Admin",
    ["superadmin"] = "Fondateur",
    ["owner"] = "Fondateur",
    ["_dev"] = "Developpeur",
}

local Listing = {}
local player = {};
local jobs = nil
local lisenceontheflux = nil
local Bot = {}
local get = false
local onStaffMode = false


function GetJobsLists()
    ESX.TriggerServerCallback('zAdmin:GetJobList', function(Jobs)
        for _,v in pairs(Jobs) do
            if not Config.JobsList[v.label] then
                Config.JobsList[v.label] = {}
            end
            GetJobGrades(v.name, v.label)
        end 
    end)
end 

function GetJobGrades(JobName, JobLabel)
    ESX.TriggerServerCallback('zAdmin:GetGradeList', function(Grades)
        Config.JobsList[JobLabel].Grades = {}
        for _,v in pairs (Grades) do
            table.insert(Config.JobsList[JobLabel].Grades, {Name = v.label, job = v.job_name, grade = v.grade})
            Config.JobsList[JobLabel].Index = 1
        end
    end, JobName)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(850)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(850)
		return nil
	end
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        player = ESX.GetPlayerData()
        Citizen.Wait(850)
    end
end)

local RColor, GColor, BColor, Opacity = 60, 66, 207, 155
local RectRcolor, RectGcolor, RectBcolor, RectOpacity = 0, 0, 0, 160
local RotateX, RotateY, RotateZ = 0.0, 0.0, 0.0
CamFov = 45.0

local TempsValue = ""
local raisontosend = "Aucune Raison !"
local GroupItem = {}
GroupItem.Value = 1

local mainMenu = RageUI.CreateMenu("~w~Administration", "Menu Administratif", 0);
local inventoryMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Inventaire du joueur", 0)
inventoryMenu:DisplayGlare(true)

local TARGET_INVENTORY = {}

mainMenu:DisplayPageCounter(false)
mainMenu:DisplayGlare(true)
local selectedMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "placeholder")
selectedMenu:DisplayGlare(true)

local playerActionMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "placeholder")
playerActionMenu:DisplayGlare(true)

local playerActionJob = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Job")
playerActionJob:DisplayGlare(true)

local playerActionRembourse = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Job")
playerActionRembourse:DisplayGlare(true)

local adminmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Admin")
adminmenu:DisplayGlare(true)

local utilsmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Utils")
utilsmenu:DisplayGlare(true)

local moneymenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Options")
moneymenu:DisplayGlare(true)

local playerSanction = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Sanctions")
playerSanction:DisplayGlare(true)

-- playerchangegrp
local playerchangegrp = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Groupe")
playerchangegrp:DisplayGlare(true)


local JailPlayerList = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu List Jail")
JailPlayerList:DisplayGlare(true)

local DevExpert = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Devs")
DevExpert:DisplayGlare(true)

local tpmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Teleportation")
tpmenu:DisplayGlare(true)

local eventmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Evènements")
eventmenu:DisplayGlare(true)

local vehiculemenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Vehicule")
vehiculemenu:DisplayGlare(true)

local menugive = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Administratif")
menugive:DisplayGlare(true)

local customCols = RageUI.CreateSubMenu(vehiculemenu, "~w~Menu Couleurs", "Couleurs")
customCols:DisplayGlare(true)

local customNeon = RageUI.CreateSubMenu(vehiculemenu, "~w~Menu Neon", "Neon")
customNeon:DisplayGlare(true)

local reportmenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Liste Report")
reportmenu:DisplayGlare(true)

local pedmenubb = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Gestion des Peds")
pedmenubb:DisplayGlare(true)

local SanctionMenu = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Sanctions")
reportmenu:DisplayGlare(true)

local SanctionAutheur = RageUI.CreateSubMenu(mainMenu, "~w~Administration", "Menu Sanctions")
pedmenubb:DisplayGlare(true)


local OuiOuNon = RageUI.CreateSubMenu(mainMenu, "~w~Décision", "Oui ou Non?")
local DevToolMenu = RageUI.CreateSubMenu(mainMenu, "Dev Tool", "Coordonées")
local CoordsMenu = RageUI.CreateSubMenu(DevToolMenu, "Dev Tool", "Coordonées")
local DrawMarkerMenu = RageUI.CreateSubMenu(DevToolMenu, "Dev Tool", "Draw Marker")
local DrawRectMenu = RageUI.CreateSubMenu(DevToolMenu, "Dev Tool", "Draw Rect")
local PropsMenu = RageUI.CreateSubMenu(DevToolMenu, "Dev Tool", "Props")
local PropsListMenu = RageUI.CreateSubMenu(PropsMenu, "Dev Tool", "Props")
DrawRectMenu.EnableMouse = true

---@class Zortix
Zortix = {} or {};

---@class SelfPlayer Administrator current settings
Zortix.SelfPlayer = {
    ped = 0,
    isStaffEnabled = false,
    isClipping = false,
    isGamerTagEnabled = false,
    isReportEnabled = true,
    isInvisible = false,
    isCarParticleEnabled = false,
    isSteve = false,
    isDelgunEnabled = false,
};

Zortix.SelectedPlayer = {};

Zortix.Menus = {} or {};

Zortix.Helper = {} or {}

---@class Players
Zortix.Players = {} or {} --- Players lists
---
Zortix.PlayersStaff = {} or {} --- Players Staff

Zortix.AllReport = {} or {} --- Players Staff


---@class GamerTags
Zortix.GamerTags = {} or {};

playerActionMenu.onClosed = function()
    Zortix.SelectedPlayer = {};
    lisenceontheflux = nil;
end

local NoClip = {
    Camera = nil,
    Speed = 1.0
}

local oldpos = nil
local specatetarget = nil
local specateactive = false

function spectate(target)
    if not oldpos then
        TriggerServerEvent("Zortix:teleport", target)
        oldpos = GetEntityCoords(GetPlayerPed(PlayerId()))
		SetEntityVisible(GetPlayerPed(PlayerId()), false)
        SetEntityCollision(GetPlayerPed(PlayerId()), false, false)
        specatetarget = target
        specateactive = true
    else
        SetEntityCoords(GetPlayerPed(PlayerId()), oldpos.x, oldpos.y, oldpos.z)
        SetEntityVisible(GetPlayerPed(PlayerId()), true)
        SetEntityCollision(GetPlayerPed(PlayerId()), true, true)
        specatetarget = nil
        gang = ""
        oldpos = nil
        specateactive = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if specateactive then
            for _, player in ipairs(GetActivePlayers()) do
                if GetPlayerServerId(player) == tonumber(specatetarget) then
                    local ped = GetPlayerPed(player)
                    local coords = GetEntityCoords(ped)
                    SetEntityNoCollisionEntity(GetPlayerPed(PlayerId()), ped, true)
                    SetEntityCoords(GetPlayerPed(PlayerId()), coords.x, coords.y, coords.z)
                end
            end             
        end            
    end
end)

local selectedIndex = 0;

local FastTravel = {
    { Name = "~g~Poste de Police~s~", Value = vector3(415.90014648438,-979.98913574219,29.440589904785) },
    { Name = "~g~Fourrière~s~", Value = vector3(408.11047363281,-1625.3238525391,29.291927337646) },
    { Name = "~g~Concessionaire~s~", Value = vector3(-38.297695159912,-1107.1236572266,26.437789916992) },
    { Name = "~g~Mécano~s~", Value = vector3(-212.19323730469,-1326.0252685547,30.890377044678) },
    { Name = "~g~Hopital~s~", Value = vector3(299.17370605469,-584.73223876953,43.260829925537) },
    { Name = "~g~Parking Central~s~", Value = vector3(215.29154968262,-809.84185791016,30.740789413452) },
}

local FastTravel2 = {
    { Name = "~g~Toit Centre ville~s~", Value = vector3(123.94564056396,-880.44451904297,134.77000427246) },
    { Name = "~g~Toit Est. ville~s~", Value = vector3(-159.36653137207,-992.88562011719,254.13056945801) },
    { Name = "~g~Toit de Studio 1~s~", Value = vector3(-143.79469299316,-593.11883544922,211.77502441406) },
    { Name = "~g~Toit Ouest. ville~s~", Value = vector3(-895.02905273438,-446.72402954102,171.81401062012) },
    { Name = "~g~Toit Sud. ville~s~", Value = vector3(-847.86987304688,-2142.7275390625,101.39619445801) },
}

local GroupIndex = 1;
local GroupIndexx = 1;
local GroupIndexxx = 1;
local GroupIndexxxx = 1;
local GroupIndexxxxx = 1;
local GroupIndexxxxxWeapon = 1;
local GroupIndexxxxxPed = 1;
local IndexJobs = 1;
local IndexJobsGrade = 1;
local IndexGangs = 1;
local IndexGangsGrade = 1;
local PermissionIndex = 1;
local VehicleIndex = 1;
local VehicleIndex2 = 1;
local ColorIndex = 1;
local FastTravelIndex = 1;
local FastTravelIndex2 = 1;
local CarParticleIndex = 1;
local idtosanctionbaby = 1;
local idtochangejob = 1;
local idtoreport = 1;
local kvdureport = 1;
local colorMetalList = 1;
local colorList = 1;
local colorNeon = 1;



function Zortix.Helper:RetrievePlayersDataByID(source)
    local player = {};
    for i, v in pairs(Zortix.Players) do
        if (v.source == source) then
            player = v;
        end
    end
    return player;
end




function Zortix.Helper:onToggleNoClip(toggle)
    if (toggle) then
        ESX.ShowNotification("NoClip ~g~activé")
        ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour arrêter le NoClip\nSlidez ~INPUT_VEH_SLOWMO_UD~ (SLOW DOWN) OU ~INPUT_VEH_SLOWMO_UP_ONLY~ pour la vitesse du NoClip.")

        if (ESX.GetPlayerData()['group'] ~= "user") then
            if (NoClip.Camera == nil) then
                NoClip.Camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            end
            SetCamActive(NoClip.Camera, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(NoClip.Camera, GetEntityCoords(Zortix.SelfPlayer.ped))
            SetCamRot(NoClip.Camera, GetEntityRotation(Zortix.SelfPlayer.ped))
            SetEntityCollision(NoClip.Camera, false, false)
            SetEntityVisible(NoClip.Camera, false)
            SetEntityVisible(Zortix.SelfPlayer.ped, false, false)
        end
    else
        if (ESX.GetPlayerData()['group'] ~= "user") then
            ESX.ShowNotification("NoClip ~g~désactivé")
            SetCamActive(NoClip.Camera, false)
            RenderScriptCams(false, false, 0, true, true)
            SetEntityCollision(Zortix.SelfPlayer.ped, true, true)
            SetEntityCoords(Zortix.SelfPlayer.ped, GetCamCoord(NoClip.Camera))
            SetEntityHeading(Zortix.SelfPlayer.ped, GetGameplayCamRelativeHeading(NoClip.Camera))
            if not (Zortix.SelfPlayer.isInvisible) then
                SetEntityVisible(Zortix.SelfPlayer.ped, true, false)
            end
        end
    end
end

RegisterNetEvent("Zortix:envoyer")
AddEventHandler("Zortix:envoyer", function(msg)
    ESX.ShowNotification('- ~g~Message du Staff~s~\n- '..msg)
    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

function Zortix.Helper:OnRequestGamerTags()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if (Zortix.GamerTags[ped] == nil) or (Zortix.GamerTags[ped].ped == nil) or not (IsMpGamerTagActive(Zortix.GamerTags[ped].tags)) then
            local formatted;
            local group = 0;
            local permission = 0;
            local fetching = Zortix.Helper:RetrievePlayersDataByID(GetPlayerServerId(player));
            if fetching.group ~= nil then
                if fetching.group ~= "user" then
                    formatted = string.format('[' .. gamertag[fetching.group] .. '] %s | %s [%s]', GetPlayerName(player), GetPlayerServerId(player),fetching.jobs)
                else
                    formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), fetching.jobs)
                end
            else
                formatted = string.format('[%d] %s [%s]', GetPlayerServerId(player), GetPlayerName(player), "Jobs Inconnue")
            end
            if (fetching) then
                group = fetching.group
                permission = fetching.permission
            end

            Zortix.GamerTags[ped] = {
                player = player,
                ped = ped,
                group = group,
                permission = permission,
                tags = CreateFakeMpGamerTag(ped, formatted)
            };
        end

    end
end


function RefreshPlayerGroup()
    Citizen.CreateThread(function()
        ESX.TriggerServerCallback('Zortix:getUsergroup', function(group)
            playergroup = group
        end)   
    end)
end

function RefreshWarnList()
    Citizen.CreateThread(function()
        ESX.TriggerServerCallback('GetSanction', function(cb)
            playerwarns = group
        end)   
    end)
end

function Zortix.Helper:RequestPtfx(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function Zortix.Helper:CreateVehicle(model, vector3)
    self:RequestModel(model)
    local vehicle = CreateVehicle(model, vector3, 100.0, true, false)
    local id = NetworkGetNetworkIdFromEntity(vehicle)

    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(vehicle, false, false)
    SetModelAsNoLongerNeeded(model)

    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    while not HasCollisionLoadedAroundEntity(vehicle) do
        Citizen.Wait(500)
    end
    return vehicle, GetEntityCoords(vehicle);
end

function Zortix.Helper:OnGetPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('Zortix:retrievePlayers', function(players)
        clientPlayers = players
    end)

    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function Zortix.Helper:OnGetStaffPlayers()
    local clientPlayers = false;
    ESX.TriggerServerCallback('Zortix:retrieveStaffPlayers', function(players)
        clientPlayers = players
    end)
    while not clientPlayers do
        Citizen.Wait(0)
    end
    return clientPlayers
end

function Zortix.Helper:GetReport()
    ESX.TriggerServerCallback('Zortix:retrieveReport', function(allreport)
        ReportBB = allreport
    end)
    while not ReportBB do
        Citizen.Wait(500)
    end
    return ReportBB
end

function Zortix.Helper:GetListJail()

    ESX.TriggerServerCallback('zAdmin:GetJailPlayer', function(cb)
        GetJailPlayer = cb
    end)
    while not GetJailPlayer do
        Citizen.Wait(500)
    end
    return GetJailPlayer
end

function admin_vehicle_flip()

    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
    if carTargetDep ~= nil then
            platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
    
    SetEntityCoords(carTargetDep, playerCoords)
    
    ESX.ShowNotification('~g~Informations\nLe ~g~véhicule~s~ a été retourné')

end

RegisterNetEvent("Zortix:RefreshReport")
AddEventHandler("Zortix:RefreshReport", function()
    Zortix.GetReport = Zortix.Helper:GetReport()
end)

RegisterNetEvent("Zortix:RefreshListJail")
AddEventHandler("Zortix:RefreshListJail", function()
    Zortix.GetJailList = Zortix.Helper:GetListJail()
end)

function Zortix.Helper:onStaffMode(status)
    if (status) then
        onStaffMode = true
        CreateThread(function()
            while onStaffMode do
                Visual.Subtitle("Nom : ~g~"..GetPlayerName(PlayerId()).."~s~ | Grade: ~g~"..playergroup.."~s~ | Report actuels : ~g~" .. #Zortix.GetReport , 999999999999999)
                Citizen.Wait(1000)
            end
        end)
        Zortix.PlayersStaff = Zortix.Helper:OnGetStaffPlayers()
        Zortix.GetReport = Zortix.Helper:GetReport()
        Zortix.GetJailList = Zortix.Helper:GetListJail()
    else
        onStaffMode = false
        Visual.Subtitle("Report actifs : ~g~" .. #Zortix.GetReport , 1)
        if (Zortix.SelfPlayer.isClipping) then
            Zortix.Helper:onToggleNoClip(false)
        end
        if (Zortix.SelfPlayer.isInvisible) then
            Zortix.SelfPlayer.isInvisible = false;
            SetEntityVisible(Zortix.SelfPlayer.ped, true, false)
        end
    end
    
end

function getEventsActif()
    Config.EventActif = {}
    ESX.TriggerServerCallback('Zortix:GetEventStarted', function(events)
        for k,v in pairs(events) do
            table.insert(Config.EventActif,{name = v.name, down = v.down, type = v.type, time = v.time})
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if (Zortix.SelfPlayer.isStaffEnabled) then
            Zortix.Players = Zortix.Helper:OnGetPlayers()
            Zortix.PlayersStaff = Zortix.Helper:OnGetStaffPlayers()
            Zortix.GetReport = Zortix.Helper:GetReport()
            Zortix.GetJailList = Zortix.Helper:GetListJail()
        end
    end
end)

local ped = {
    { Name = "Pogo 1", Value = 'u_m_m_streetart_01' },
    { Name = "Pogo 2", Value = 'u_m_y_pogo_01' },
    { Name = "Mime", Value = 's_m_y_mime' },
    { Name = "Jesus", Value = 'u_m_m_jesus_01' },
    { Name = "Zombie", Value = 'u_m_y_zombie_01' },
    { Name = "The Rock", Value = 'u_m_y_babyd' },
}
local pedIndex = 1
local ValuePed = 'u_m_m_streetart_01'
local NamePed = 'Pogo 1'

RegisterNetEvent("Zortix:noclipkey")
AddEventHandler("Zortix:noclipkey", function()
    RefreshPlayerGroup()
    if (Zortix.SelfPlayer.isStaffEnabled) then
        if (Zortix.SelfPlayer.isClipping) then
            Zortix.Helper:onToggleNoClip(false)
            Zortix.SelfPlayer.isClipping = false
        else
            Zortix.Helper:onToggleNoClip(true)
            Zortix.SelfPlayer.isClipping = true 
        end
    else
        ESX.ShowNotification("Action impossible (NoClip)")
        ESX.ShowNotification('~g~Informations\nVous n\'avez pas activé votre ~g~mode staff')
    end
   
end)

RegisterNetEvent("Zortix:menu1")
AddEventHandler("Zortix:menu1", function()
    RefreshPlayerGroup()
    Zortix.Players = Zortix.Helper:OnGetPlayers();
    Zortix.PlayersStaff = Zortix.Helper:OnGetStaffPlayers()
    Zortix.GetReport = Zortix.Helper:GetReport()
    Zortix.GetJailList = Zortix.Helper:GetListJail()
    RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
   
end)

RegisterNetEvent("Zortix:menu2")
AddEventHandler("Zortix:menu2", function()
    RefreshPlayerGroup()
    Zortix.GetReport = Zortix.Helper:GetReport()
    RageUI.Visible(reportmenu, not RageUI.Visible(reportmenu))
   
end)

Citizen.CreateThread(function()
    for i = 1, 100 do
        table.insert(Config.MaxJoueurs, i)
    end
    for i=1,15 do
        table.insert(Config.TimeEvent, i)
    end
end)

RegisterNetEvent("Zortix:DeleteEvent")
AddEventHandler("Zortix:DeleteEvent", function()
    ESX.TriggerServerCallback('Zortix:GetEventStarted', function(events)
        for k,v in pairs(events) do
            TriggerServerEvent("Zortix:RemoveEvents", k)
            Config.EventActif = {}
        end
    end)
end)

PropsListMenu.Closed = function()  
    ReturnOldPosition()
end 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (IsControlJustPressed(0, Config.Touche.Noclip)) then --F3
            TriggerServerEvent("Zortix:noclipkey")
        end

        if (IsControlJustPressed(0, Config.Touche.Menu)) then
            TriggerServerEvent("Zortix:ouvrirmenu1")
        end

        if (IsControlJustPressed(0, Config.Touche.MenuReport)) then
            TriggerServerEvent("Zortix:ouvrirmenu2")
        end

        RageUI.IsVisible(mainMenu, function()
            RageUI.Separator("Joueur(s) en jeu : ~g~".. #Zortix.Players.."")
            RageUI.Separator("Staff(s) en jeu : ~g~".. #Zortix.PlayersStaff.."")
            RageUI.Separator("Report(s) actifs : ~g~" ..#Zortix.GetReport)
            --[[RageUI.Separator('Ped : ~g~'.. NamePed)

           RageUI.Info("Informations", {"Joueur(s) en jeu: ~g~".. #Zortix.Players.."~s~", "Staff(s) en jeu : ~g~".. #Zortix.PlayersStaff.."~s~", "Report(s) actifs : ~g~" ..#Zortix.GetReport}, {})
    
                RageUI.List('~g~→~s~ Choisissez votre Ped', ped, pedIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        pedIndex = Index;
                        ValuePed = Item.Value
                        NamePed = Item.Name
                    end,
                })]]
            

            RageUI.Checkbox("~g~→ ~s~Prendre son service", "Le mode staff ne peut être utilisé que pour modérer le serveur, tout abus sera sévèrement puni, l'intégralité de vos actions sera enregistrée.", Zortix.SelfPlayer.isStaffEnabled, { }, {
                onChecked = function()
                    Zortix.Helper:onStaffMode(true)
                    TriggerServerEvent('Zortix:onStaffJoin')
                    --[[local j1 = PlayerId(-1)
                    local p1 = GetHashKey(ValuePed)
                    RequestModel(p1)
                    while not HasModelLoaded(p1) do
                        Wait(100)
                    end 
                        SetPlayerModel(j1, p1)
                        SetModelAsNoLongerNeeded(p1)]]
                end,
                onUnChecked = function()
                    Zortix.Helper:onStaffMode(false)
                    ESX.ShowNotification('Avez vous bien penser a désactiver les GamerTags', 5000)
                    TriggerServerEvent('Zortix:onStaffLeave')
                    --[[ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        local isMale = skin.sex == 0
                        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                                TriggerEvent('esx:restoreLoadout')
                            end)
                        end)
                    end) ]]
                end,
                onSelected = function(Index)
                    Zortix.SelfPlayer.isStaffEnabled = Index
                end
            })
            

            if (Zortix.SelfPlayer.isStaffEnabled) then

            RageUI.Separator("~g~↓ ~s~Gestion ~g~↓")

                RageUI.Button('Liste de(s) Report(s)', nil, { RightLabel = "[~g~"..#Zortix.GetReport.."~s~]" }, true, {
                    onSelected = function()
                    end
                }, reportmenu)

                RageUI.Button('Liste de(s) Staff(s)', nil, { RightLabel = "[~g~"..#Zortix.PlayersStaff.."~s~]" }, true, {
                    onSelected = function()
                    end
                }, JailPlayerList)

                RageUI.Button('Liste de(s) Joueur(s)', nil, { RightLabel = "[~g~"..#Zortix.Players.."~s~]"}, true, {
                    onSelected = function()
                        selectedMenu:SetSubtitle(string.format('Joueur(s) en lignes [%s]', #Zortix.Players))
                        selectedIndex = 1;
                    end
                }, selectedMenu)

                RageUI.Button('Option(s) sur Véhicule(s)', nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                    end
                }, vehiculemenu)

                RageUI.Button('Option(s) Personnel(s)', nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                    end
                }, tpmenu)

                RageUI.Button('Créer un évènement(s)', nil, { RightLabel = "~g~→→" }, playergroup == 'admin', {
                    onSelected = function()
                        getEventsActif()
                    end
                }, eventmenu)        

                if playergroup ~= nil and ( playergroup == '_dev' or playergroup == 'owner' or playergroup == 'admin') then
                    RageUI.Button('→ Option Administratif', 'Ce Menu vous permez de faire des actions Administratif. Attention, si vous utilisez cette option sans l\'autorisation du Fondateur, vous serez lourdement sanctionné.', { RightLabel = "~g~→→" }, true, {
                        onSelected = function()
                        end
                    }, menugive)
                end

                if playergroup ~= nil and ( playergroup == '_dev' or playergroup == 'superadmin' or playergroup == 'admin' ) then 
                    RageUI.Button('→ Option Developpeur', nil, { RightLabel = "~g~→→" }, true, {
                        onSelected = function()
                        end
                    }, DevToolMenu)     
                else 
                    RageUI.Button('→ Option Developpeur', nil, { RightLabel = "~g~→→" }, false, {
                        onSelected = function()
                       
                        end
                    })
                end 
            end
        end)

        local block = true

        --[[if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(OuiOuNon, function()
                RageUI.Separator('↓ ~g~Êtes-vous sûr~s~ ↓')
                RageUI.Button("~g~Oui", nil, {RightLabel = "→"}, block, {}, DevToolMenu)
                RageUI.Button("~r~Non", nil, {RightLabel = "→"}, block, {
                    onSelected = function()
                        Wait(1000)
                        block = false
                        ESX.ShowNotification("Vous avez séléctionnez: ~r~Non~s~\nRedirection...")
                        Wait(1000)
                        RageUI.GoBack()
                    end 
                })
            end)
        end]]

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(DevToolMenu, function()
                RageUI.Button("Coordonées", nil, {RightLabel = "→"}, true, {}, CoordsMenu)
                RageUI.Button("Draw Marker", nil, {RightLabel = "→"}, true, {}, DrawMarkerMenu)
                RageUI.Button("Draw Rect", nil, {RightLabel = "→"}, true, {}, DrawRectMenu)
                RageUI.Button("Props", nil, {RightLabel = "→"}, true, {}, PropsMenu)
                RageUI.Button("TP Marker", nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        TeleportBlips()
                    end
                })
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(CoordsMenu, function()
                RageUI.List("Coordonnées", Config.CoordsList, Config.CoordsList.Index , nil, {}, true, {
                    onListChange = function(Index)
                        Config.CoordsList.Index = Index
                    end,
                    onSelected = function(Index)
                        if Index == 1 then
                            SendNUIMessage({
                                tool = ""..GetEntityCoords(PlayerPedId())
                            })
                        elseif Index == 2 then
                            SendNUIMessage({
                                tool = ""..GetEntityCoords(PlayerPedId()).x..", "..GetEntityCoords(PlayerPedId()).y..", "..GetEntityCoords(PlayerPedId()).z
                            })
                        elseif Index == 3 then
                            SendNUIMessage({
                                tool = "{x = "..GetEntityCoords(PlayerPedId()).x..", y = "..GetEntityCoords(PlayerPedId()).y..", z = "..GetEntityCoords(PlayerPedId()).z.."}"
                            })
                        end
                    end
                })
                RageUI.Button("Heading", false , {RightLabel = "→"}, true , {
                    onSelected = function()
                        SendNUIMessage({
                            tool = GetEntityHeading(PlayerPedId())
                        })
                    end
                })
            end)
        end
        
        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(DrawMarkerMenu, function()
                local Pcoord = GetEntityCoords(PlayerPedId())
                DrawMarker(Config.TypeMarker.Index, Pcoord.x, Pcoord.y+1.0, Pcoord.z - 1.0 + Config.HeightMarker.Index /10.0, 0.0, 0.0, 0.0, RotateX, RotateY, RotateZ, 1.0, 1.0, 1.0, RColor, GColor, BColor, Opacity)
                RageUI.List("Type de Marker", Config.TypeMarker, Config.TypeMarker.Index , nil, {}, true, {
                    onListChange = function(Index)
                        Config.TypeMarker.Index = Index
                    end
                })
                RageUI.List("Hauteur du Marker", Config.HeightMarker, Config.HeightMarker.Index , nil, {}, true, {
                    onListChange = function(Index)
                        Config.HeightMarker.Index = Index
                    end
                })
                RageUI.List("Rotation du Marker [X]", Config.RotateMarker, Config.RotateMarker.IndexX , nil, {}, true, {
                    onListChange = function(Index)
                        Config.RotateMarker.IndexX = Index
                        if Index > 1 then
                            RotateX = Config.RotateMarker.IndexX * 45.0
                        end
                    end
                })
                RageUI.List("Rotation du Marker [Y]", Config.RotateMarker, Config.RotateMarker.IndexY , nil, {}, true, {
                    onListChange = function(Index)
                        Config.RotateMarker.IndexY = Index
                        if Index > 1 then
                            RotateY = Config.RotateMarker.IndexY * 45.0
                        end
                    end
                })
                RageUI.List("Rotation du Marker [Z]", Config.RotateMarker, Config.RotateMarker.IndexZ , nil, {}, true, {
                    onListChange = function(Index)
                        Config.RotateMarker.IndexZ = Index
                        if Index > 1 then
                            RotateZ = Config.RotateMarker.IndexZ * 45.0
                        end
                    end
                })
                RageUI.List("Couleur du Marker", Config.ListColor, Config.ListColor.IndexMarker , nil, {}, true, {
                    onListChange = function(Index)
                        Config.ListColor.IndexMarker = Index
                    end, 
                    onSelected = function(Index)
                        if Index == 1 then
                            local RedColor = KeyboardInput("Color", "Rouge / 255", "", 3)
                            if RedColor ~= nil then
                                RedColor = tonumber(RedColor)
                                if type(RedColor) == 'number' then
                                    RColor = RedColor
                                end
                            end
                        elseif Index == 2 then
                            local GreenColor = KeyboardInput("Color", "Vert / 255", "", 3)
                            if GreenColor ~= nil then
                                GreenColor = tonumber(GreenColor)
                                if type(GreenColor) == 'number' then
                                    GColor = GreenColor
                                end
                            end
                        elseif Index == 3 then
                            local BlueColor = KeyboardInput("Color", "Bleu / 255", "", 3)
                            if BlueColor ~= nil then
                                BlueColor = tonumber(BlueColor)
                                if type(BlueColor) == 'number' then
                                    BColor = BlueColor
                                end
                            end
                        elseif Index == 4 then
                            local Alpha = KeyboardInput("Color", "Opacité / 255", "", 3)
                            if Alpha ~= nil then
                                Alpha = tonumber(Alpha)
                                if type(Alpha) == 'number' then
                                    Opacity = Alpha
                                end
                            end
                        end
                    end
                })
                RageUI.Separator("Couleur du Marker: R: ~r~"..RColor.." ~s~G: ~g~"..GColor.." ~s~B: ~b~"..BColor)
                RageUI.Button('Copier Marker', false, { RightLabel = "→", Color = {HightLightColor = {235, 18, 15, 150}, BackgroundColor = {38, 85, 150, 160 }}}, true, {
                    onSelected = function()
                        SendNUIMessage({
                            tool = "DrawMarker("..Config.TypeMarker.Index..", "..Pcoord.x..", "..(Pcoord.y + 1.0 *0.01)..", "..(Pcoord.z - 1.0 + Config.HeightMarker.Index /10.0)..", 0.0, 0.0, 0.0, "..RotateX..", "..RotateY..", "..RotateZ..", 1.0, 1.0, 1.0, "..RColor..", "..GColor..", "..BColor..", "..Opacity..")"
                        })
                    end
                })
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(DrawRectMenu, function()
                DrawRect(Config.DrawRectPostion.X, Config.DrawRectPostion.Y, Config.DrawRectWidth, Config.DrawRectHeight, RectRcolor, RectGcolor, RectBcolor, RectOpacity)
                RageUI.Button("Changer position", false, {RightLabel = "→"}, true, {})
                RageUI.Grid(Config.DrawRectPostion.X, Config.DrawRectPostion.Y, 'Haut', 'Bas', 'Gauche', 'Droite', {
                    onPositionChange = function(IndexX, IndexY, X, Y)
                        Config.DrawRectPostion.X = IndexX
                        Config.DrawRectPostion.Y = IndexY
                        DrawRectPostionX = IndexX
                        DrawRectPostionY = IndexY 
                    end
                }, 1)
                RageUI.Button("Changer largeur", false, {RightLabel = "→"}, true, {})
                RageUI.GridHorizontal(Config.DrawRectWidth, 'Moins large', 'Plus large', {
                    onPositionChange = function(IndexX, IndexY, X, Y)
                        Config.DrawRectWidth = IndexX
                    end
                }, 2)
                RageUI.Button("Changer hauteur", false, {RightLabel = "→"}, true, {})
                RageUI.GridVertical(Config.DrawRectHeight, 'Plus grand', 'Moins grand', {
                    onPositionChange = function(IndexX, IndexY, X, Y)
                        Config.DrawRectHeight = IndexY
                    end
                }, 3)
                RageUI.Separator("Couleur du Draw Rect: R: ~r~"..RectRcolor.." ~s~G: ~g~"..RectGcolor.." ~s~B: ~b~"..RectBcolor)
                RageUI.List("Couleur du DrawRect", Config.ListColor, Config.ListColor.IndexRect , nil, {}, true, {
                    onListChange = function(Index)
                        Config.ListColor.IndexRect = Index
                    end, 
                    onSelected = function(Index)
                        if Index == 1 then
                            local RedColor = KeyboardInput("Color", "Rouge / 255", "", 3)
                            if RedColor ~= nil then
                                RedColor = tonumber(RedColor)
                                if type(RedColor) == 'number' then
                                    RectRcolor = RedColor
                                end
                            end
                        elseif Index == 2 then
                            local GreenColor = KeyboardInput("Color", "Vert / 255", "", 3)
                            if GreenColor ~= nil then
                                GreenColor = tonumber(GreenColor)
                                if type(GreenColor) == 'number' then
                                    RectGcolor = GreenColor
                                end
                            end
                        elseif Index == 3 then
                            local BlueColor = KeyboardInput("Color", "Bleu / 255", "", 3)
                            if BlueColor ~= nil then
                                BlueColor = tonumber(BlueColor)
                                if type(BlueColor) == 'number' then
                                    RectBcolor = BlueColor
                                end
                            end
                        elseif Index == 4 then
                            local Alpha = KeyboardInput("Color", "Opacité / 255", "", 3)
                            if Alpha ~= nil then
                                Alpha = tonumber(Alpha)
                                if type(Alpha) == 'number' then
                                    RectOpacity = Alpha
                                end
                            end
                        end
                    end
                })
                RageUI.Button('Copier Draw Rect', false, { RightLabel = "→", Color = {HightLightColor = {235, 18, 15, 150}, BackgroundColor = {38, 85, 150, 160 }}}, true, {
                    onSelected = function()
                        SendNUIMessage({
                            tool = "DrawRect("..Config.DrawRectPostion.X..", "..Config.DrawRectPostion.Y..", "..Config.DrawRectWidth..", "..Config.DrawRectHeight..", "..RectRcolor..", "..RectGcolor..", "..RectBcolor..","..RectOpacity..")"
                        })
                    end
                })
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(PropsMenu, function()
                RageUI.Button("Get closest props", "Retourne le ~y~hash~s~ du props se trouvant le plus proche de vous" , {RightLabel = "→"}, true , {
                    onSelected = function() 
                        SendNUIMessage({
                            tool = ""..GetEntityModel(ESX.Game.GetClosestObject())
                        })
                    end
                })
                RageUI.Button("Liste des props", false , {RightLabel = "→"}, true , {
                    onSelected = function()
                        TeleportIPLProps()
                    end
                }, PropsListMenu)
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(PropsListMenu, function()
                if IsControlJustReleased(0,  96) then
                    if CamFov > 0 then
                        CamFov = CamFov - 5.0
                        SetCamFov(camera, CamFov)
                    end
                elseif IsControlJustReleased(0,  97) then
                    if CamFov < 130.0 then
                        CamFov = CamFov + 5.0
                        SetCamFov(camera, CamFov)
                    end
                end
                Visual.Subtitle("Appuyez sur [~b~+~s~] / [~b~-~s~] pour Zoom / Dézoom", 1000)
                for k,v in pairs(ListOfProps) do
                    RageUI.Button(v.name, false , {RightLabel = "→"}, true , {
                        onSelected = function()
                            SendNUIMessage({
                                tool = ""..v.name
                            })
                        end
                    })
                    PropsListMenu.onIndexChange = function(Index)
                        RequestModel(ListOfProps[Index].name)
                        while not HasModelLoaded(ListOfProps[Index].name) do
                            Wait(500)				
                        end
                        Wait(150)
                        DeleteEntity(SpawnProps)
                        SpawnProps = CreateObjectNoOffset(ListOfProps[Index].name, -1266.972, -3013.221, -48.49021, 1, 0, 1)
                        PlaceObjectOnGroundProperly(SpawnProps)
                        FreezeEntityPosition(SpawnProps, true)
                        SetModelAsNoLongerNeeded(SpawnProps)
                    end
                end
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(inventoryMenu, function()
                for i, v in pairs(TARGET_INVENTORY) do
                    RageUI.Button(v.label, nil, { RightLabel = v.count }, true, {
                        onSelected = function()
        
                        end
                    })
                end
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then 
            RageUI.IsVisible(JailPlayerList, function()
                    if (#Zortix.PlayersStaff > 0) then

                        for i, v in pairs(Zortix.PlayersStaff) do
                            local gamertage = {
                                ["user"] = "Joueurs",
                                ["help"] = "Helpeur",
                                ["mod"] = "Modo",
                                ["admin"] = "Admin",
                                ["superadmin"] = "Superadmin",
                                ["owner"] = "Fondateur",
                                ["_dev"] = "Developer !!",
                            }                 
                            
                            RageUI.Button(string.format('[%s] %s [%s]', v.source, v.name, gamertage[v.group]), 'Job : ~g~'..v.jobs..'~s~ | Groupe : ~g~'..v.group..'', {}, true, {
                                onSelected = function()
                                    ESX.ShowNotification("~g~"..v.name.."~s~ a pris son service ~g~"..v.dateOn.."~s~.")
                                end
                            })
                        end
                    else
                        RageUI.Separator("Aucun joueur en ligne.")
                    end
            end) 
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then 
            RageUI.IsVisible(eventmenu, function() 
                if #Config.EventActif== 0 then
                    RageUI.Separator("")
                    RageUI.Separator("~g~Aucun évenénement est en cours :(")
                    RageUI.Separator("")
                end
                for a,b in pairs(Config.EventActif) do
                    RageUI.Separator('↓ ~g~Un évenénement est en cours~s~ ! ↓')
                    RageUI.Separator("Type d'événement : ~g~"..b.type)
                    RageUI.Separator("Évenénement lancer par : ~g~"..b.name)
                    for i,v in pairs(activeBars) do
                        local remainingTime = math.floor(v.endTime - GetGameTimer())
                        RageUI.Separator("Temps restant(s) : ~g~"..SecondsToClock(remainingTime / 1000))
                    end
                end
                RageUI.List('→ Définir le type de l\'événement', {"Caisse", "Brinks", "Drogue"}, Config.EventTypeIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        Config.EventTypeIndex = Index;
                    end
                })

                if Config.EventTypeIndex == 1 then
                    RageUI.List('→ Définir le temps en minute(s) :', Config.TimeEvent, Config.IndexTimeEvent, nil, {}, #Config.EventActif == 0, {
                        onListChange = function(Index, Item)
                            Config.IndexTimeEvent = Index;
                        end
                    }) 
                    RageUI.Button("→ Commencer l'évenénement", nil, { RightLabel = "→→" }, #Config.EventActif == 0, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:StartEventsStaff", "Caisse mystère", Config.IndexTimeEvent)
                            TriggerServerEvent("Zortix:StartsEvents", "CAISSE", Config.IndexTimeEvent)
                            getEventsActif()
                            print("ok1")
                        end
                    })
                elseif Config.EventTypeIndex == 2 then 
                    RageUI.List('→ Définir le temps en minute(s) :', Config.TimeEvent, Config.IndexTimeEvent, nil, {}, #Config.EventActif == 0, {
                        onListChange = function(Index, Item)
                            Config.IndexTimeEvent = Index;
                        end
                    }) 
                    RageUI.Button("→ Commencer l'évenénement", nil, { RightLabel = "→→" }, #Config.EventActif == 0, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:StartEventsStaff", "Brinks", Config.IndexTimeEvent)
                            TriggerServerEvent("Zortix:StartsEvents", "BRINKS", Config.IndexTimeEvent)
                            getEventsActif()
                            print("ok2")
                        end
                    })
                elseif Config.EventTypeIndex == 3 then 
                    RageUI.List('→ Définir le temps en minute(s) :', Config.TimeEvent, Config.IndexTimeEvent, nil, {}, #Config.EventActif == 0, {
                        onListChange = function(Index, Item)
                            Config.IndexTimeEvent = Index;
                        end
                    }) 
                    RageUI.Button("→ Commencer l'évenénement", nil, { RightLabel = "→→" }, #Config.EventActif == 0, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:StartEventsStaff", "Drogue", Config.IndexTimeEvent)
                            TriggerServerEvent("Zortix:StartsEvents", "DRUGS", Config.IndexTimeEvent)
                            getEventsActif()
                            print("ok3")
                        end
                    })
                end
            end)
        end 

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(tpmenu, function()

                RageUI.Separator("~g~↓ ~s~Personnel ~g~↓")
                RageUI.Checkbox("→ NoClip", "Vous permet de vous déplacer librement sur toute la carte sous forme de caméra libre.", Zortix.SelfPlayer.isClipping, { }, {
                    onChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Active noclip")
                    Zortix.Helper:onToggleNoClip(true)
                    end,
                    onUnChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Désactive noclip")
                    Zortix.Helper:onToggleNoClip(false)
                    end,
                    onSelected = function(Index)
                    Zortix.SelfPlayer.isClipping = Index
                    end
                }, selectedMenu)

                RageUI.Checkbox("→ Affichage des GamerTags", "L'affichage des tags des joueurs vous permet de voir les informations des joueurs, y compris de vous reconnaître entre les membres du personnel grâce à votre couleur.", Zortix.SelfPlayer.isGamerTagEnabled, { }, {
                    onChecked = function()
                    if (ESX.GetPlayerData()['group'] ~= "user") then
                        ESX.ShowNotification("GamerTags ~g~activé")
                    TriggerServerEvent("Zortix:SendLogs", "Active GamerTags")
                    Zortix.Helper:OnRequestGamerTags()
                    end
                    end,
                    onUnChecked = function()
                    for i, v in pairs(Zortix.GamerTags) do
                        ESX.ShowNotification("GamerTags ~g~désactivé")
                    TriggerServerEvent("Zortix:SendLogs", "Désactive GamerTags")
                    RemoveMpGamerTag(v.tags)
                    end
                    Zortix.GamerTags = {};
                    end,
                    onSelected = function(Index)
                    Zortix.SelfPlayer.isGamerTagEnabled = Index
                    end
                }, selectedMenu)

                RageUI.Checkbox("→ Affichage des Blips", nil, Zortix.SelfPlayer.IsBlipsActive, { }, {
                    onChecked = function()
                        TriggerServerEvent("Zortix:SendLogs", "Active Blips")
                        
                        ESX.ShowNotification("Blips ~g~activé")
                        blips = true
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("Zortix:SendLogs", "Désactive Blips")
                        ESX.ShowNotification("Blips ~g~désactivé")
                        blips = false
                    end,
                    onSelected = function(Index)
                        Zortix.SelfPlayer.IsBlipsActive = Index
                    end
                })
                local blips = false


                RageUI.Checkbox("→ Mode Invisible", nil, Zortix.SelfPlayer.isInvisible, { }, {
                    onChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Active invisible")
                    SetEntityVisible(Zortix.SelfPlayer.ped, false, false)
                    
                    ESX.ShowNotification("Invisibilité ~g~activé")
                    end,
                    onUnChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Désactive invisible")
                    ESX.ShowNotification("Invisibilité ~g~desactivé")
                    SetEntityVisible(Zortix.SelfPlayer.ped, true, false)
                    end,
                    onSelected = function(Index)
                        Zortix.SelfPlayer.isInvisible = Index
                    end
                })
                if playergroup ~= nil and ( playergroup == '_dev' or playergroup == 'owner' or playergroup == 'superadmin') then
                    RageUI.Checkbox("→~s~ Mode l'Invincible ~g~(gradé)~s~","Devenir invincible.", Zortix.SelfPlayer.isInvincible, { }, {
                        onChecked = function()
                            local ped = GetPlayerPed(-1)
                            SetEntityInvincible(ped, true)
                            TriggerServerEvent("Zortix:SendLogs", "Invincible Activé")
                            ESX.ShowNotification("Invincibilité ~g~activé")
                        end,
                        onUnChecked = function()
                            local ped = GetPlayerPed(-1)
                            SetEntityInvincible(ped, false)
                            TriggerServerEvent("Zortix:SendLogs", "Invincible Désactivé")
                            ESX.ShowNotification("Invincibilité ~g~désactivé")
                        end,
                        onSelected = function(Index)
                            Zortix.SelfPlayer.isInvincible = Index
                        end
                    })
                end


                RageUI.Button("→ Se Revive", '/revive', {RightLabel = '~g~→→'}, true, {
                    onSelected = function()
                        
                    ExecuteCommand("revive")
                    Wait(1000)
                    ESX.ShowNotification('Vous avez été revive par ~g~vous', 5000)
                end
                
                })
                RageUI.Button("→ Se Heal", '/heal', {RightLabel = '~g~→→'}, true, {
                    onSelected = function()
                    ExecuteCommand("heal")
                    Wait(2000)
                    ESX.ShowNotification('Vous avez été heal par ~g~vous', 5000)
                end
                
                })
               
                
                RageUI.Separator("~g~↓ ~s~Téléportation(s) ~g~↓")

                RageUI.Button('→ Spectate Aléatoire', "Regarder un joueur aléatoirement", { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        local number = #Zortix.Players
                        local target = Zortix.Players[math.random(0~number)].source
                        if target == GetPlayerServerId(PlayerId()) then
                            ESX.ShowNotification("Votre ID a été sélectionné mais vous ne pouvez pas vous spec vous même ! Réessayer !")
                        else
                            spectate(target)
                        end
                    end
                }) 
           

            RageUI.Button('→ Téléportation vers le marker', 'Permet de se ~g~téléporter~s~ sur un ~g~point~s~', { RightLabel = "~g~→→" }, true, {
                onSelected = function()
                    plyPed = PlayerPedId()
                    local waypointHandle = GetFirstBlipInfoId(8)

                    if DoesBlipExist(waypointHandle) then
                        Citizen.CreateThread(function()
                            local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
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
        
                            SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
                            ESX.ShowNotification("Vous avez été TP")
                            TriggerServerEvent("Zortix:SendLogs", "Se TP sur le waypoint")
                        end)
                    else
                        ESX.ShowNotification("Pas de marqueur sur la carte")
                    end
                end
            })

            RageUI.List('→ Téléportation Rapide', FastTravel, FastTravelIndex, nil, {}, true, {
                onListChange = function(Index, Item)
                    FastTravelIndex = Index;
                end,
                onSelected = function(Index, Item)
                    SetEntityCoords(PlayerPedId(), Item.Value)
                    TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                end
            })
            RageUI.List('→ Téléportation Toits', FastTravel2, FastTravelIndex2, nil, {}, true, {
                onListChange = function(Index, Item)
                FastTravelIndex2 = Index;
                end,
                onSelected = function(Index, Item)
                SetEntityCoords(PlayerPedId(), Item.Value)
                TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                end
            })
            
            RageUI.Checkbox("→ Delgun", 'Active le ~g~pistolet~s~ qui ~g~delete', Zortix.SelfPlayer.isDelgunEnabled, { }, {
                onChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Active Delgun")
                    
                    ESX.ShowNotification("Delgun ~g~activé")
                end,
                onUnChecked = function()
                    TriggerServerEvent("Zortix:SendLogs", "Désactive Delgun")
                    ESX.ShowNotification("Delgun ~g~désactivé")
                end,
                onSelected = function(Index)
                    Zortix.SelfPlayer.isDelgunEnabled = Index
                end
            })
        end)
    end

        

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(menugive, function()
                RageUI.Separator("Votre ID Unique : ~g~" .. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .."")
                RageUI.Separator("~g~↓ ~s~Actions Rapides ~g~↓")

                   -- travaille fdp

                   RageUI.Checkbox("→~s~ Mode l'Invincible ~g~(gradé)~s~","Devenir invincible.", Zortix.SelfPlayer.isInvincible, { }, {
                    onChecked = function()
                        local ped = GetPlayerPed(-1)
                        SetEntityInvincible(ped, true)
                        TriggerServerEvent("Zortix:SendLogs", "Invincible Activé")
                        ESX.ShowNotification("Invincibilité ~g~activé")
                    end,
                    onUnChecked = function()
                        local ped = GetPlayerPed(-1)
                        SetEntityInvincible(ped, false)
                        TriggerServerEvent("Zortix:SendLogs", "Invincible Désactivé")
                        ESX.ShowNotification("Invincibilité ~g~désactivé")
                    end,
                    onSelected = function(Index)
                        Zortix.SelfPlayer.isInvincible = Index
                    end
                })

                RageUI.Separator("~g~↓ ~s~Give argent / item ~g~↓")

                RageUI.Button("S'octroyer de ~g~l'argent en liquide", 'Si vous utilisez cette option sans l\'autorisation du Fondateur, vous serez lourdement sanctionné.', { RightLabel = "⚠  ~g~→→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('Zortix_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('Zortix:GiveMoney', "money", amount)   
                                ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                            
                            end
                        end
                    end,
                })

                RageUI.Button("S'octroyer de ~g~l'argent en banque", 'Si vous utilisez cette option sans l\'autorisation du Fondateur, vous serez lourdement sanctionné.', { RightLabel = "⚠  ~g~→→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('Zortix_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('Zortix:GiveMoney', "bank <@989512047932882974>", amount)  
                                ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                             
                            end
                        end
                    end,
                })

                RageUI.Button("S'octroyer de ~g~l'argent en sale", 'Si vous utilisez cette option sans l\'autorisation du Fondateur, vous serez lourdement sanctionné.', { RightLabel = "⚠  ~g~→→" }, true, {
                    onSelected = function()
                        local amount = KeyboardInput('Zortix_BOX_AMOUNT', "Veuillez entrer la somme", '', 8)

                        if amount ~= nil then
                            amount = tonumber(amount)
                
                            if type(amount) == 'number' then
                                TriggerServerEvent('Zortix:GiveMoney', "black_money", amount)  
                                ESX.ShowNotification("Give de ~g~" .. amount .. "$~s~")                             
                            end
                        end
                    end,
                })

                
                RageUI.Separator("~g~↓ ~s~Apparence du personnage ~g~↓")

                RageUI.Button("→ Changer d'apparance", nil, {RightLabel = "~g~→→"}, true, {
                    onSelected = function()
                        
                        RageUI.CloseAll()
                        Wait(100)
                    ExecuteCommand("skin")
                    ESX.ShowNotification("Vous êtes en train de vous changer")  
                end
                
                })

                RageUI.Button('→ Mettre un ped', nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                    end
                }, pedmenubb)

                RageUI.Button("→ Reprendre son personnage", nil, {RightLabel = "~g~→→"}, true, {
                    onSelected = function()
                        
                        Wait(1000)
                    ESX.ShowNotification("Cette option n'est pas encore disponnible.")  
                end
                
                })
            end)
        end

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(vehiculemenu, function()
                RageUI.Separator("~g~↓ ~s~Spawn de véhicule(s) ~g~↓")

                
                RageUI.Button("→ Spawn avec le nom", nil, { RightLabel = "~g~→→" }, true, {
                    
                    onSelected = function()
                            local modelName = KeyboardInput('Zortix_BOX_VEHICLE_NAME', "Veuillez entrer le ~g~nom~s~ du véhicule", '', 50)
                            TriggerEvent('Zortix:spawnVehicle', modelName)
                            TriggerServerEvent("Zortix:SendLogs", "Spawn custom vehicle")
                    end,
                })
                RageUI.List('→ Spawn Rapide', {
                    { Name = "BMX", Value = 'bmx' },
                    { Name = "Sanchez", Value = 'sanchez' },
                    { Name = "Futo", Value = "futo" },
                }, VehicleIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        VehicleIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        if Item.Value == nil then
                            local modelName = KeyboardInput('Zortix_BOX_VEHICLE_NAME', "Veuillez entrer le ~g~nom~s~ du véhicule", '', 50)
                            TriggerEvent('Zortix:spawnVehicle', modelName)
                            TriggerServerEvent("Zortix:SendLogs", "Spawn custom vehicle")
                        else
                            TriggerEvent('Zortix:spawnVehicle', Item.Value)
                            TriggerServerEvent("Zortix:SendLogs", "Spawn vehicle")
                        end
                    end,
                })

                RageUI.Separator("~g~↓ ~s~Gestion véhicule ~g~↓")

                RageUI.Button('→ Réparer le véhicule', nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                        local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleFixed(plyVeh)
                        SetVehicleDirtLevel(plyVeh, 0.0)
                        ESX.ShowNotification('~g~Informations\nLe ~g~véhicule~s~ a été réparé')
                        TriggerServerEvent("Zortix:SendLogs", "Repair Vehicle")
                    end
                })

                RageUI.Button("→ Retourner le véhicule", nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                        admin_vehicle_flip()
                    end
                })

                RageUI.Button('→ Changer la plaque', nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            local plaqueVehicule = KeyboardInput('Zortix_PLAQUE_NAME',"Veuillez entrer le ~g~nom~s~ de la plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                            ESX.ShowNotification('~g~Informations\nLe nom de la plaque est désormais : ~g~' ..plaqueVehicule)
                        else
                            ESX.ShowNotification('~g~Informations\n~g~Erreur :~s~ Vous n\'êtes pas dans un véhicule ~g~')
                        end
                    end
                })

                RageUI.List('→ Supprimer des véhicules (Zone)', {
                    { Name = "~g~1~s~", Value = 1 },
                    { Name = "~g~5~s~", Value = 5 },
                    { Name = "~g~10~s~", Value = 10 },
                    { Name = "~g~15~s~", Value = 15 },
                    { Name = "~g~20~s~", Value = 20 },
                    { Name = "~g~25~s~", Value = 25 },
                }, GroupIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        GroupIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        TriggerServerEvent("Zortix:SendLogs", "Delete vehicle zone")
                        ESX.ShowNotification('~g~Informations\nLa ~g~suppression~s~ a été effectué')
                        local playerPed = PlayerPedId()
                        local radius = Item.Value
                        if radius and tonumber(radius) then
                            radius = tonumber(radius) + 0.01
                            local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed, false), radius)

                            for i = 1, #vehicles, 1 do
                                local attempt = 0

                                while not NetworkHasControlOfEntity(vehicles[i]) and attempt < 100 and DoesEntityExist(vehicles[i]) do
                                    Citizen.Wait(500)
                                    NetworkRequestControlOfEntity(vehicles[i])
                                    attempt = attempt + 1
                                end

                                if DoesEntityExist(vehicles[i]) and NetworkHasControlOfEntity(vehicles[i]) then
                                    ESX.Game.DeleteVehicle(vehicles[i])
                                    DeleteEntity(vehicles[i])
                                end
                            end
                        else
                            local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

                            if IsPedInAnyVehicle(playerPed, true) then
                                vehicle = GetVehiclePedIsIn(playerPed, false)
                            end

                            while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
                                Citizen.Wait(500)
                                NetworkRequestControlOfEntity(vehicle)
                                attempt = attempt + 1
                            end

                            if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
                                ESX.Game.DeleteVehicle(vehicle)
                                DeleteEntity(vehicle)
                            end
                        end
                    end,
                })
                --
                RageUI.Separator("~g~↓ ~s~Apparence du véhicule ~g~↓")

                RageUI.Button("→ Couleurs", nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                end}, customCols) 
        
                RageUI.Button("→ Neon", nil, { RightLabel = "~g~→→" }, true, {
                    onSelected = function()
                end}, customNeon)  

            end)
        end

        RageUI.IsVisible(customCols, function()
            RageUI.Separator("~g~↓~s~ Chrome ~g~↓")
                RageUI.Button("Chromé", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 120, 120)
                end})
                RageUI.Button("Gold", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 99, 99)
                end})
                RageUI.Button("Silver", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 4, 4)
                end})
                RageUI.Button("Bronze", nil, {}, true, {
                    onSelected = function()
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, 90, 90)
                end})
                RageUI.Separator("~g~↓~s~ Classiques ~g~↓")
                Listing.ColorMetalList = {
                    { Name = "Black Steel", Value1 = 2, Value2 = 2 },
                    { Name = "Dark Steel", Value1 = 3, Value2 = 3 }, 
                    { Name = "Red", Value1 = 27, Value2 = 27 },
                    { Name = "Grace Red", Value1 = 31, Value2 = 31 },
                    { Name = "Sunset Red", Value1 = 33, Value2 = 33 },
                    { Name = "Wine Red", Value1 = 143, Value2 = 143 },
                    { Name = "Hot Pink", Value1 = 135, Value2 = 135 },
                    { Name = "Pfsiter Pink", Value1 = 137, Value2 = 137 },
                    { Name = "Salmon Pink", Value1 = 136, Value2 = 136 },
                    { Name = "Sunrise Orange", Value1 = 36, Value2 = 36 },
                    { Name = "Race Yellow", Value1 = 89, Value2 = 89 },
                    { Name = "Racing Green", Value1 = 50, Value2 = 50 },
                    { Name = "Lime Green", Value1 = 92, Value2 = 92 },
                    { Name = "Midnight Blue", Value1 = 141, Value2 = 141 },
                    { Name = "Galaxy Blue", Value1 = 61, Value2 = 61 },
                    { Name = "Dark Blue", Value1 = 62, Value2 = 62 },
                    { Name = "Diamond Blue", Value1 = 67, Value2 = 67 },
                    { Name = "Surf Blue", Value1 = 68, Value2 = 68 },
                    { Name = "Racing Blue", Value1 = 73, Value2 = 73 },
                    { Name = "Ultra Blue", Value1 = 70, Value2 = 70 },
                    { Name = "Light Blue", Value1 = 74, Value2 = 74 },
                    { Name = "Chocolate Brown", Value1 = 96, Value2 = 96 },
                    { Name = "Bison Brown", Value1 = 101, Value2 = 101 },
                    { Name = "Woodbeech Brown", Value1 = 102, Value2 = 102 },
                    { Name = "Bleached Brown", Value1 = 106, Value2 = 106 },
                    { Name = "Midnight Purple", Value1 = 142, Value2 = 142 },
                    { Name = "Bright Purple", Value1 = 145, Value2 = 145 },
                    { Name = "Cream", Value1 = 107, Value2 = 107 },
                    { Name = "Frost White", Value1 = 112, Value2 = 112 }
                }
                RageUI.List("Classiques", Listing.ColorMetalList, colorMetalList, nil, {}, true, {
                    onListChange = function(list, mls) 
                        colorMetalList = list end,
                    onSelected = function(list, mls)
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, mls.Value1, mls.Value2)
                end})  
                RageUI.Separator("~g~↓~s~ Mates ~g~↓")
                Listing.ColorList = {
                    { Name = "Black", Value1 = 12, Value2 = 12 },
                    { Name = "Gray", Value1 = 13, Value2 = 13 },
                    { Name = "Ice White", Value1 = 131, Value2 = 131 },
                    { Name = "Blue", Value1 = 83, Value2 = 83 },
                    { Name = "Schafter Purple", Value1 = 148, Value2 = 148 },
                    { Name = "Red", Value1 = 39, Value2 = 39 },
                    { Name = "Orange", Value1 = 41, Value2 = 41 },
                    { Name = "Yellow", Value1 = 42, Value2 = 42 },
                    { Name = "Green", Value1 = 128, Value2 = 128 }
                }
                RageUI.List("Mates", Listing.ColorList, colorList, nil, {}, true, {
                    onListChange = function(list, mls) 
                        colorList = list end,
                    onSelected = function(list, mls)
                        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                        SetVehicleColours(vehicle, mls.Value1, mls.Value2)
                end})                              
        end)

    RageUI.IsVisible(customNeon, function()   
            Listing.ColorNeon = {
                { Name = "White", Value1 = 222, Value2 = 222, Value3 = 255 },	
                { Name = "Blue", Value1 = 2, Value2 = 21 , Value3 = 255 },
                { Name = "Electric Blue", Value1 = 3, Value2 = 83, Value3 = 255 },
                { Name = "Mint Green", Value1 = 0, Value2 = 255, Value3 = 140 },
                { Name = "Lime Green", Value1 = 94, Value2 = 255, Value3 = 1 },
                { Name = "Yellow", Value1 = 255, Value2 = 255, Value3 = 0 },
                { Name = "Orange", Value1 = 255, Value2 = 62, Value3 = 0 },
                { Name = "Red", Value1 = 255, Value2 = 1, Value3 = 1 },
                { Name = "Pony Pink", Value1 = 255, Value2 = 50, Value3 = 100 },
                { Name = "Hot Pink", Value1 = 255, Value2 = 5, Value3 = 190 },
                { Name = "Purple", Value1 = 35, Value2 = 1, Value3 = 255 },
                { Name = "Blacklight", Value1 = 15, Value2 = 3, Value3 = 255 }
            }                           
            RageUI.List("Neon", Listing.ColorNeon, colorNeon, nil, {}, true, {
                onListChange = function(list, cols) 
                    colorNeon = list end,
                onSelected = function(list, cols)
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    SetVehicleNeonLightEnabled(vehicle, 0, true)
                    SetVehicleNeonLightEnabled(vehicle, 1, true)
                    SetVehicleNeonLightEnabled(vehicle, 2, true)
                    SetVehicleNeonLightEnabled(vehicle, 3, true)
                    SetVehicleNeonLightsColour(vehicle, cols.Value1, cols.Value2, cols.Value3)
            end})  
        RageUI.Button("Supprimez les neons", nil, {}, true, {
            onSelected = function()
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetVehicleNeonLightEnabled(vehicle, 0, false)
                SetVehicleNeonLightEnabled(vehicle, 1, false)
                SetVehicleNeonLightEnabled(vehicle, 2, false)
                SetVehicleNeonLightEnabled(vehicle, 3, false)
        end})     
    end)

        if (Zortix.SelfPlayer.isStaffEnabled) then
            RageUI.IsVisible(selectedMenu, function()
                RageUI.Separator("~g~↓ ~s~Informations ~g~↓")
                table.sort(Zortix.Players, function(a,b) return a.source < b.source end)
                if (selectedIndex == 1) then
                    if (#Zortix.Players > 0) then

                        for i, v in pairs(Zortix.Players) do
                            local gamertage = {
                                ["user"] = "Joueurs",
                                ["help"] = "Helpeur",
                                ["mod"] = "Modo",
                                ["admin"] = "Admin",
                                ["superadmin"] = "Fondateur",
                                ["owner"] = "Fondateur",
                                ["_dev"] = "Fondateur !!",
                            }                 
                            
                            RageUI.Button(string.format('[%s] %s [%s]', v.source, v.name, gamertage[v.group]), 'Job : ~g~'..v.jobs..'~s~ | Gourp : ~g~'..v.group..'', {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', i, v.name))
                                    Zortix.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueur en ligne.")
                    end
                end
                if (selectedIndex == 2) then
                    if (#Zortix.PlayersStaff > 0) then
                        for i, v in pairs(Zortix.PlayersStaff) do
                            local colors = {
                                ["_dev"] = '~g~',
                                ["superadmin"] = '~g~',
                                ["admin"] = '~g~',
                                ["modo"] = '~g~',
                            }
                            RageUI.Button(string.format('%s[%s] %s', colors[v.group], v.source, v.name), nil, {}, true, {
                                onSelected = function()
                                    playerActionMenu:SetSubtitle(string.format('[%s] %s', v.source, v.name))
                                    Zortix.SelectedPlayer = v;
                                end
                            }, playerActionMenu)
                        end
                    else
                        RageUI.Separator("Aucun joueur en ligne.")
                    end
                end

                if (selectedIndex == 3) then
                    for i, v in pairs(Zortix.Players) do
                        if v.source == idtosanctionbaby then
                            
                            RageUI.Separator("~g~↓~s~ INFORMATION ~g~↓")
                            RageUI.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
        
                            RageUI.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end
                end

                if (selectedIndex == 4) then
                    for i, v in pairs(Zortix.Players) do
                        if v.source == idtosanctionbaby then
                            RageUI.Separator("~g~↓~s~ INFORMATION ~g~↓")
                            RageUI.Button('ID : ' .. idtosanctionbaby, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Nom : ' .. v.name, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                            RageUI.Button('Jobs : ' .. v.jobs, nil, {}, true, {
                                onSelected = function()
                                end
                            })
                        end
                    end

                end
                if (selectedIndex == 6) then
                    for i, v in pairs(Zortix.Players) do
                        if v.source == idtoreport then
                            RageUI.Separator('Nom : ~g~' .. v.name)
                            RageUI.Separator('ID : ~g~' .. idtoreport)
                            RageUI.Separator('Jobs : ~g~' .. v.jobs)
                            RageUI.Separator("Date du report : ~b~" ..v.dateRpt)
                        end
                    end
                    RageUI.Separator("~g~↓~s~ Téléportations ~g~↓")
                    RageUI.Button('Se Teleporter sur lui', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:teleport", idtoreport)
                        end
                    })
                    RageUI.Button('Le Teleporter sur moi', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:teleportTo", idtoreport)
                        end
                    })
                    RageUI.List('→ Téléportation Rapide', FastTravel, FastTravelIndex, nil, {}, true, {
                        onListChange = function(Index, Item)
                            FastTravelIndex = Index;
                        end,
                        onSelected = function(Index, Item)
                            SetEntityCoords(PlayerPedId(), Item.Value)
                            TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                        end
                    })
                    RageUI.List('→ Téléportation Toits', FastTravel2, FastTravelIndex2, nil, {}, true, {
                        onListChange = function(Index, Item)
                        FastTravelIndex2 = Index;
                        end,
                        onSelected = function(Index, Item)
                        SetEntityCoords(PlayerPedId(), Item.Value)
                        TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                        end
                    })
                    RageUI.Separator("~g~↓~s~ Utils ~g~↓")
                    RageUI.Button('Le Revive', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:Revive", idtoreport)
                        end
                    })
                    RageUI.Separator("~g~↓~s~ Valider ~g~↓")
                    RageUI.Button('~g~Report Effectué', nil, {}, true, {
                        onSelected = function()
                            TriggerServerEvent("Zortix:ReportRegle", kvdureport)
                            TriggerEvent("Zortix:RefreshReport")
                        end
                    }, reportmenu)
                end
            end)

            RageUI.IsVisible(playerActionMenu, function()
                yo = ""
                if specateactive then
                    yo = "✔"
                end
                
                RageUI.Separator("~g~↓ ~s~Rapide ~g~↓")

                RageUI.Button("→ Spectate", nil, { RightLabel = '~g~→→' }, true, { 
                    onSelected = function()
                        spectate(Zortix.SelectedPlayer.source)
                    end 
                })

                RageUI.Button('→ Revive', nil, { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        TriggerServerEvent("Zortix:Revive", Zortix.SelectedPlayer.source)
                    end
                })

                RageUI.Button('→ Envoyer un message privé', 'Sert d\'avertisement', { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        local msg = KeyboardInput('Zortix_BOX_BAN_RAISON', "Message Privée", '', 50)
                        
                        if msg ~= nil then
                            msg = tostring(msg)
                    
                            if type(msg) == 'string' then
                                TriggerServerEvent("Zortix:Message", Zortix.SelectedPlayer.source, msg)
                            end
                        end
                        ESX.ShowNotification("Vous venez d'envoyer le message à ~g~" .. GetPlayerName(GetPlayerFromServerId(Zortix.SelectedPlayer.source)))
                    end
                })

                RageUI.Checkbox("Freeze le joueur", false, Config.CheckboxFreezePlayer, {}, {
                    onChecked = function()
                        TriggerServerEvent("freezePly", Zortix.SelectedPlayer.source, true)
                    end,
                    onUnChecked = function()
                        TriggerServerEvent("freezePly", Zortix.SelectedPlayer.source, false)
                    end,
                    onSelected = function(Index)
                        Config.CheckboxFreezePlayer = Index
                    end
                })

                RageUI.Separator("~g~↓ ~s~Téléportation(s) ~g~↓")

                RageUI.Button('→ Vous téléporter sur lui', nil, { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        TriggerServerEvent('Zortix:teleport', Zortix.SelectedPlayer.source)
                    end
                })
                RageUI.Button('→ Téléporter vers vous', nil, { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        TriggerServerEvent('Zortix:teleportTo', Zortix.SelectedPlayer.source)
                    end
                })

                RageUI.List('→ Téléportation Rapide', FastTravel, FastTravelIndex, nil, {}, true, {
                    onListChange = function(Index, Item)
                        FastTravelIndex = Index;
                    end,
                    onSelected = function(Index, Item)
                        SetEntityCoords(PlayerPedId(), Item.Value)
                        TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                    end
                })
                RageUI.List('→ Téléportation Toits', FastTravel2, FastTravelIndex2, nil, {}, true, {
                    onListChange = function(Index, Item)
                    FastTravelIndex2 = Index;
                    end,
                    onSelected = function(Index, Item)
                    SetEntityCoords(PlayerPedId(), Item.Value)
                    TriggerServerEvent("Zortix:SendLogs", "Utilise le fast travel")
                    end
                }) 

                RageUI.Separator("~g~↓ ~s~Action(s) Supplémentaires ~g~↓")
                RageUI.Button('→ Changer le métier/orga', nil, { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                            idtochangejob = Zortix.SelectedPlayer.source
                            for k, v in pairs(Zortix.Players) do 
                                plyID = v.source
                            end
                        GetJobsLists()
                    end
                }, playerActionJob)

                RageUI.Button('→ Rembourser', nil, { RightLabel = '~g~→→' }, true, {
                    onSelected = function()
                        for k, v in pairs(Zortix.Players) do 
                            plyRemb = v.source
                        end
                        ESX.TriggerServerCallback('zAdmin:GetItemList', function(Items)
                            Config.ItemsList = Items
                        end)
                    end
                }, playerActionRembourse)

                RageUI.Separator("~g~↓ ~s~Gestions Sanction(s) ~g~↓")

                RageUI.Button('→ Sanctionner', nil, {}, true, {
                    onSelected = function()
                        for i, v in pairs(Zortix.Players) do
                            plySanc = v.source
                        end
                    end
                }, playerSanction)

                RageUI.Separator("~g~↓ ~s~Gestions Grade(s) ~g~↓")
                RageUI.Button('→ Changer le grade', nil, {}, true, {
                    onSelected = function()
                        RefreshPlayerGroup()
                        idtochangegrp = Zortix.SelectedPlayer.source
                        for i, v in pairs(Zortix.Players) do
                            plyGrade = v.source
                        end
                    end
                }, playerchangegrp)

            end)

            RageUI.IsVisible(playerchangegrp, function()
                RageUI.List("Émettre un changement de groupe", {"_dev","owner", "superadmin", "admin", "modo", "helpeur", "user"}, Config.grade, nil, {}, true, {
                    onListChange = function(Index) 
                        Config.grade = Index
                    end,
                    onSelected = function(Index)
                        if Index == 1 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~_dev~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "_dev")
                            RefreshPlayerGroup()

                        elseif Index == 2 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~owner~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "owner")
                            RefreshPlayerGroup()

                        elseif Index == 3 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~superadmin~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "superadmin")                        
                            RefreshPlayerGroup()

                        elseif Index == 4 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~admin~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "admin")
                            RefreshPlayerGroup()

                        elseif Index == 5 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~modo~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "modo")
                            RefreshPlayerGroup()

                        elseif Index == 6 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~helpeur~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "helpeur")
                            RefreshPlayerGroup()

                        elseif Index == 7 then 
                            ESX.ShowNotification("Vous avez attribué le grade ~g~user~s~ à l'ID: ~g~"..plyGrade)
                            TriggerServerEvent("zAdmin:StaffSetGrade", plyGrade, "user")
                            RefreshPlayerGroup()

                        end

                    end

                })
            end)

            RageUI.IsVisible(playerSanction, function()
                RageUI.List("Émettre une sanction(s)", {"Warn", "Retirer Warn", "Bannir", "Kick", "Jail", "UnJail"}, Config.sanctions, nil, {}, true, {
                    onListChange = function(Index) 
                        Config.sanctions = Index
                    end,
                    onSelected = function(Index)
                        for i, v in pairs(Zortix.Players) do
                            if Index == 1 then
                                bansetting = false
                                JailList = false
                                JailTime = false
                                --year, month, day, hour, minute, second = GetLocalTime()
                                --date = day.."/"..month.."/"..years
                                local result = KeyboardInput('Raison', "Raison", '', 50)
                                if result ~= nil then 
                                    TriggerServerEvent('SetSanction', v.source, result)
                                    ESX.ShowNotification("~b~Vous venez de mettre un avertissement à "..v.name)
                                else 
                                    ESX.ShowNotification("Administration\nChamp invalide")
                                end
                            elseif Index == 2 then 
                                local id = KeyboardInput('id', "Id de la sanction", '', 50)
                                TriggerServerEvent('DeleteSanction', id)
                                ESX.ShowNotification("~b~Vous venez de supprimer l'avertissement N°"..id)
                            elseif Index == 3 then 
                                JailTime = false
                                JailList = false
                                bansetting = true
                            elseif Index == 4 then
                                JailTime = false
                                bansetting = false
                                JailList = false
                                raison = KeyboardInput('Raison', "Raison", '', 50)
                                if raison ~= nil then
                                    TriggerServerEvent("zAdmin:Kick", v.source, raison)
                                    ESX.ShowNotification('Administration\nLa personne a été Kick !')
                                else
                                    ESX.ShowNotification("Administration\nChamp invalide")
                                end
                            elseif Index == 5 then
                                bansetting = false
                                JailList = false
                                JailTime = true
                            elseif Index == 6 then
                                bansetting = false
                                JailTime = false
                                JailList = false
                                TriggerServerEvent("zAdmin:UnJail", v.source, true)
                                TriggerEvent("Zortix:RefreshListJail")
                                ESX.ShowNotification("Administration\nLa personne a été enlever du Jail !")
                            end 
                        end
                    end
                })  

                if bansetting then
                    RageUI.Separator("~g~↓ ~s~Action Bannissement ~g~↓")
                    RageUI.List("Bannissement", {"Permanent", "Personnalisé (en Jours)"}, Config.ban, nil, {}, true, {
                        onListChange = function(Index) 
                            Config.ban = Index
                        end,
                        onSelected = function(Index)
                            for i, v in pairs(Zortix.Players) do
                                if Index == 1 then
                                    raison = KeyboardInput('Raison', "Raison", '', 255)
                                    if raison ~= nil then
                                        ESX.ShowNotification("Administration\nLa personne a été Ban  :\nRaison(s) : ~g~"..raison.."~s~\nTemps : ~g~Permanent")
                                        TriggerServerEvent("zAdmin:Ban", v.source, raison, "permanent")
                                    end
                                elseif Index == 2 then
                                    raison = KeyboardInput('Raison', "Raison", '', 255)
                                    if raison ~= nil then
                                        time = tonumber(KeyboardInput('Temps (en jours)', "Temps (en jours)", '', 255))
                                        if time ~= nil and time > 0 then
                                            if time ~= nil and time > 0 and raison ~= nil then
                                                ESX.ShowNotification("AdministrationLa personne a été Ban  :\nRaison(s) : ~g~"..raison.."~s~\nTemps : ~g~"..time.." - Jour(s)")
                                                TriggerServerEvent("zAdmin:Ban", v.source, raison, time)
                                            else
                                                ESX.ShowNotification("Administration\nChamp invalide")
                                            end
                                        else
                                            ESX.ShowNotification("Administration\nChamp invalide")
                                        end 
                                    else
                                        ESX.ShowNotification("Administration\nChamp invalide")
                                    end
                                end
                            end
                        end
                    }) 
                elseif JailTime then 
                    RageUI.Separator("~g~↓ ~s~Action Jail ~g~↓")

                    if temps == nil then
                        RageUI.Button(" →→→ Temps :", nil, { RightLabel = "→" }, true, {
                            onSelected = function()
                                temps = tonumber(KeyboardInput("", 255))
                            end
                        })
                    else
                        RageUI.Button(" →→→ Temps :", nil, { RightLabel = "~g~"..temps*60 .."~s~ - Secondes"}, true, {
                            onSelected = function()
                                temps = tonumber(KeyboardInput("", 255))
                                Jail = true
                            end
                        })
                    end
                    RageUI.Button(" →→→ Mettre en Jail", nil,{RightLabel = "→→"}, true, {
                        onSelected = function()
                            for i, v in pairs(Zortix.Players) do
                                if temps ~= nil and temps > 0 then
                                    TriggerServerEvent("zAdmin:Jail", v.source, temps)
                                    ESX.ShowNotification("Administration\nLa personne a été mit en jail !")
                                    Jail = false
                                else
                                    ESX.ShowNotification("Administration\nChamp invalide")
                                end
                            end
                        end
                    })
                end
            end)

            RageUI.IsVisible(playerActionJob, function()
                    RageUI.Separator("~g~↓ ~s~Actions sur Métier ~g~↓")
                    for k,v in pairs(Config.JobsList) do
                        if Config.JobsList[k].Index ~= nil then
                            RageUI.List(k, Config.JobsList[k].Grades, Config.JobsList[k].Index, nil, {}, true, {
                                onListChange = function(Index) 
                                    Config.JobsList[k].Index = Index
                                end,
                                onSelected = function()
                                    ESX.ShowNotification("Information(s) - Changement d'métier :\nID : ~g~"..Zortix.SelectedPlayer.source.."\n~s~Métier : ~g~"..k.."\n~s~Grade : ~g~"..Config.JobsList[k].Index-1, "CHAR_ST", 1)
                                    for _,Update in pairs(Config.JobsList[k].Grades) do
                                        TriggerServerEvent("zAdmin:StaffSetJob", plyID, Update.job, Config.JobsList[k].Index-1)
                                    end
                                end
                            })  
                        end
                    end

                    RageUI.Separator("~g~↓ ~s~Actions sur Orga ~g~↓")
                    for k,v in pairs(Config.JobsList) do
                        if Config.JobsList[k].Index ~= nil then
                            RageUI.List(k, Config.JobsList[k].Grades, Config.JobsList[k].Index, nil, {}, true, {
                                onListChange = function(Index) 
                                    Config.JobsList[k].Index = Index
                                end,
                                onSelected = function()
                                    ESX.ShowNotification("Information(s) - Changement d'métier :\nID : ~g~"..Zortix.SelectedPlayer.source.."\n~s~Métier : ~g~"..k.."\n~s~Grade : ~g~"..Config.JobsList[k].Index-1, "CHAR_ST", 1)
                                    for _,Update in pairs(Config.JobsList[k].Grades) do
                                        TriggerServerEvent("zAdmin:StaffSetJob2", plyID, Update.job, Config.JobsList[k].Index-1)
                                    end
                                end
                            })  
                        end
                    end

            end)

            RageUI.IsVisible(playerActionRembourse, function()
                RageUI.List("Type de remboursement", {"Objet(s)", "Argent(s)"}, Config.remboursement, nil, {}, true, {
                    onListChange = function(Index) 
                        Config.remboursement = Index
                    end,
                    onSelected = function(Index)
                        if Index == 1 then
                            print("ojk")
                            objets = true
                            argent = false
                        elseif Index == 2 then
                            print("ojk")
                            objets = false
                            argent = true
                        end
                    end
                })  
            
                if objets then
                    local AllAl = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "M", "N", "L", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
                    RageUI.List("Filtrage par lettre", AllAl, Config.AllAl, nil, {}, true, {
                        onListChange = function(Index)
                            Config.AllAl = Index
                        end
                    })

                    for k,v in pairs(Config.ItemsList) do
                        if string.find(v.label, AllAl[Config.AllAl]) then
                            RageUI.Button("→ "..v.label, nil, { RightLabel = '~g~→→' }, true, {
                                onSelected = function()
                                    Count = KeyboardInput('', "Item", '', 50)
                                    if tonumber(Count) ~= nil then
                                        TriggerServerEvent("zAdmin:StaffGiveItem", Zortix.SelectedPlayer.source, v.name, v.label, tonumber(Count))
                                        TriggerServerEvent("Zortix:SendLogs", tostring(GetPlayerName(PlayerId())).." à donner : **"..tonumber(Count).."** de **"..v.label.."** à l'ID : "..Zortix.SelectedPlayer.source)
                                        ESX.ShowNotification("Information(s) - Vous avez donner ~g~"..tonumber(Count).."~s~ "..v.label.. " à la personne")
                                    else
                                        ESX.ShowNotification("Information(s)\nQauntité invalide")
                                    end
                                end
                            })
                        end
                    end
                elseif argent then 
                    for _, v in pairs(Config.MoneyList) do
                        RageUI.Button(v.label, nil, {RightLabel = "→→"}, true, {
                            onSelected = function()
                                Amount = KeyboardInput('', "Argent", '', 10)
                                if tonumber(Amount) ~= nil then
                                    TriggerServerEvent("zAdmin:StaffGiveMoney", Zortix.SelectedPlayer.source, v.value, tonumber(Amount))
                                    TriggerServerEvent("Zortix:SendLogs", tostring(GetPlayerName(PlayerId())).." à donner : **"..Amount.."$** de **d'"..v.label.."** à l'ID : "..Zortix.SelectedPlayer.source)
                                    ESX.ShowNotification("Information(s)\nVous avez donner ~g~"..Amount.."$~s~ d'"..v.label.. " à la personne")
                                else
                                    ESX.ShowNotification("Information(s)\nQauntité invalide")
                                end
                            end
                        })
                    end
                else 
                    RageUI.Separator("~g~")
                    RageUI.Separator("~g~Rien n'a été séléctionné")
                    RageUI.Separator("~g~")
                end
            end)

            RageUI.IsVisible(reportmenu, function()
                
                RageUI.Separator("~g~↓ ~s~Report(s) en cours ~g~↓")
                
                for i, v in pairs(Zortix.GetReport) do
                    RageUI.Button("[" .. v.id .. "] " .. v.name , "ID : s" .. v.id .. "\n" .. "Name : " .. v.name .. "\nRaison : " .. v.reason, {}, true, {
                        onSelected = function()
                            selectedMenu:SetSubtitle(string.format('Report'))
                            kvdureport = i
                            idtoreport = v.id
                            selectedIndex = 6;
                        end
                    }, selectedMenu)
                end
            end)
        end
        for i, onTick in pairs(Zortix.Menus) do
            onTick();
        end
    end
    Citizen.Wait(500)
    GetJobsLists()
end)

RegisterNetEvent("freezePlys")
AddEventHandler("freezePlys", function(state)
    local plyPed = PlayerPedId()
    IsPlayerFreeze = state
    FreezeEntityPosition(plyPed, state)

    while IsPlayerFreeze do
        GiveWeaponToPed(plyPed, "weapon_unarmed", 0, false, true)
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 69, true) -- Attack
        DisableControlAction(0, 70, true) -- Attack
        DisableControlAction(0, 92, true) -- Attack
        DisableControlAction(0, 114, true) -- Attack
        DisableControlAction(0, 121, true) -- Attack
        DisableControlAction(0, 140, true) -- Attack
        DisableControlAction(0, 141, true) -- Attack
        DisableControlAction(0, 142, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack
        DisableControlAction(0, 263, true) -- Attack
        DisableControlAction(0, 264, true) -- Attack
        DisableControlAction(0, 331, true) -- Attack
        DisableControlAction(0, 157, true) -- Weapon 1
        DisableControlAction(0, 158, true) -- Weapon 2
        DisableControlAction(0, 160, true) -- Weapon 3
        Wait(1)
    end
end)

local function getEntity(player)
    -- function To Get Entity Player Is Aiming At
    local _, entity = GetEntityPlayerIsFreeAimingAt(player)
    return entity
end

local function aimCheck(player)
    -- function to check config value onAim. If it's off, then
    return IsPedShooting(player)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (Zortix.SelfPlayer.isStaffEnabled) then
            if (Zortix.SelfPlayer.isDelgunEnabled) then
                if IsPlayerFreeAiming(PlayerId()) then
                    local entity = getEntity(PlayerId())
                    if GetEntityType(entity) == 2 or 3 then
                        if aimCheck(GetPlayerPed(-1)) then
                            SetEntityAsMissionEntity(entity, true, true)
                            DeleteEntity(entity)
                        end
                    end
                end
            end

            --if (Zortix.SelfPlayer.isStaffEnabled) then
                if (Zortix.SelfPlayer.ShowCoords) then
                    plyPed = PlayerPedId()
                    local plyCoords = GetEntityCoords(plyPed, false)
                    Text('~g~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. '\n~g~g~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. '\n~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. '\n~g~H~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
                end
            --end

            function Text(text)
                SetTextColour(186, 186, 186, 255)
                SetTextFont(0)
                SetTextScale(0.500, 0.500)
                SetTextWrap(0.0, 1.0)
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 205)
                BeginTextCommandDisplayText('STRING')
                AddTextComponentSubstringPlayerName(text)
                EndTextCommandDisplayText(0.175, 0.81)
            end

            if (Zortix.SelfPlayer.isClipping) then
                --HideHudAndRadarThisFrame()

                local camCoords = GetCamCoord(NoClip.Camera)
                local right, forward, _, _ = GetCamMatrix(NoClip.Camera)
                if IsControlPressed(0, 32) then
                    local newCamPos = camCoords + forward * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 8) then
                    local newCamPos = camCoords + forward * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 34) then
                    local newCamPos = camCoords + right * -NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 9) then
                    local newCamPos = camCoords + right * NoClip.Speed
                    SetCamCoord(NoClip.Camera, newCamPos.x, newCamPos.y, newCamPos.z)
                end
                if IsControlPressed(0, 334) then
                    if (NoClip.Speed - 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed - 0.1
                    end
                end
                if IsControlPressed(0, 335) then
                    if (NoClip.Speed + 0.1 >= 0.1) then
                        NoClip.Speed = NoClip.Speed + 0.1
                    end
                end

                SetEntityCoords(Zortix.SelfPlayer.ped, camCoords.x, camCoords.y, camCoords.z)

                local xMagnitude = GetDisabledControlNormal(0, 1)
                local yMagnitude = GetDisabledControlNormal(0, 2)
                local camRot = GetCamRot(NoClip.Camera)
                local x = camRot.x - yMagnitude * 10
                local y = camRot.y
                local z = camRot.z - xMagnitude * 10
                if x < -75.0 then
                    x = -75.0
                end
                if x > 100.0 then
                    x = 100.0
                end
                SetCamRot(NoClip.Camera, x, y, z)
            end

            if (Zortix.SelfPlayer.isGamerTagEnabled) then
                for i, v in pairs(Zortix.GamerTags) do
                    local target = GetEntityCoords(v.ped, false);

                    if #(target - GetEntityCoords(PlayerPedId())) < 120 then
                        SetMpGamerTagVisibility(v.tags, 0, true)
                        SetMpGamerTagVisibility(v.tags, 2, true)

                        SetMpGamerTagVisibility(v.tags, 4, NetworkIsPlayerTalking(v.player))
                        SetMpGamerTagAlpha(v.tags, 2, 255)
                        SetMpGamerTagAlpha(v.tags, 4, 255)

                        local colors = {
                            ["_dev"] = 50,
                            ["superadmin"] = 25,
                            ["owner"] = 25,
                            ["admin"] = 8,
                            ["mod"] = 40,
                            ["help"] = 21,
                        }
                        SetMpGamerTagColour(v.tags, 0, colors[v.group] or 0)
                    else
                        RemoveMpGamerTag(v.tags)
                        Zortix.GamerTags[i] = nil;
                    end
                end


            end

        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Zortix.SelfPlayer.ped = GetPlayerPed(-1);
        if (Zortix.SelfPlayer.isStaffEnabled) then
            if (Zortix.SelfPlayer.isGamerTagEnabled) then
                Zortix.Helper:OnRequestGamerTags();
            end
        end
        Citizen.Wait(1000)
    end
end)


RegisterNetEvent('Zortix:teleport')
AddEventHandler('Zortix:teleport', function(coords)
    if (Zortix.SelfPlayer.isClipping) then
        SetCamCoord(NoClip.Camera, coords.x, coords.y, coords.z)
        SetEntityCoords(Zortix.SelfPlayer.ped, coords.x, coords.y, coords.z)
    else
        ESX.Game.Teleport(PlayerPedId(), coords)
    end
end)

RegisterNetEvent('Zortix:spawnVehicle')
AddEventHandler('Zortix:spawnVehicle', function(model)
    if (Zortix.SelfPlayer.isStaffEnabled) then
        model = (type(model) == 'number' and model or GetHashKey(model))

        if IsModelInCdimage(model) then
            local playerPed = PlayerPedId()
            local plyCoords = GetEntityCoords(playerPed)

            ESX.Game.SpawnVehicle(model, plyCoords, 90.0, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            end)
        else
            ESX.ShowNotification('Modèle de véhicule invalide.', 5000)
        end
    end
end)

local disPlayerNames = 5
local playerDistances = {}

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.55 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if (Zortix.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do
                local serverId = GetPlayerServerId(id)
                local CCS = {
                    ["_dev"] = "~u~",
                    ["owner"] = "~g~",
                    ["superadmin"] = "~g~",
                    ["admin"] = "~q~",
                    ["modo"] = "~g~",
                    ["help"] = "~g~",
                    ["user"] = "",
                }

                local formatted = nil;
                if group == '_dev' then
                    formatted = string.format('~h~~u~[Fondateur] ~w~%s~w~', GetPlayerName(id))
                end
                if playerDistances[id] then
                    if (playerDistances[id] < disPlayerNames) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                        else
                        end
                    elseif (playerDistances[id] < 25) then
                        x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                        if NetworkIsPlayerTalking(id) then
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)
Citizen.CreateThread(function()
	while true do
		Wait(1)
		if blips then
			for _, player in pairs(GetActivePlayers()) do
				local found = false
				if player ~= PlayerId() then
					local ped = GetPlayerPed(player)
					local blip = GetBlipFromEntity( ped )
					if not DoesBlipExist( blip ) then
						blip = AddBlipForEntity(ped)
						SetBlipCategory(blip, 7)
						SetBlipScale( blip,  0.85 )
						ShowHeadingIndicatorOnBlip(blip, true)
						SetBlipSprite(blip, 1)
						SetBlipColour(blip, 0)
					end
					
					SetBlipNameToPlayerName(blip, player)
					
					local veh = GetVehiclePedIsIn(ped, false)
					local blipSprite = GetBlipSprite(blip)
					
					if IsEntityDead(ped) then
						if blipSprite ~= 303 then
							SetBlipSprite( blip, 303 )
							SetBlipColour(blip, 1)
							ShowHeadingIndicatorOnBlip( blip, false )
						end
					elseif veh ~= nil then
						if IsPedInAnyBoat( ped ) then
							if blipSprite ~= 427 then
								SetBlipSprite( blip, 427 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyHeli( ped ) then
							if blipSprite ~= 43 then
								SetBlipSprite( blip, 43 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPlane( ped ) then
							if blipSprite ~= 423 then
								SetBlipSprite( blip, 423 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyPoliceVehicle( ped ) then
							if blipSprite ~= 137 then
								SetBlipSprite( blip, 137 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnySub( ped ) then
							if blipSprite ~= 308 then
								SetBlipSprite( blip, 308 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						elseif IsPedInAnyVehicle( ped ) then
							if blipSprite ~= 225 then
								SetBlipSprite( blip, 225 )
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, false )
							end
						else
							if blipSprite ~= 1 then
								SetBlipSprite(blip, 1)
								SetBlipColour(blip, 0)
								ShowHeadingIndicatorOnBlip( blip, true )
							end
						end
					else
						if blipSprite ~= 1 then
							SetBlipSprite( blip, 1 )
							SetBlipColour(blip, 0)
							ShowHeadingIndicatorOnBlip( blip, true )
						end
					end
					if veh then
						SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
					else
						SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
					end
				end
			end
		else
			for _, player in pairs(GetActivePlayers()) do
				local blip = GetBlipFromEntity( GetPlayerPed(player) )
				if blip ~= nil then
					RemoveBlip(blip)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        if (Zortix.SelfPlayer.isGamerTagEnabled) then
            for _, id in ipairs(GetActivePlayers()) do

                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(#(vector3(x1, y1, z1) - vector3(x2, y2, z2)))
                playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)

function refreshFouilleStaff(thePlayer)
	ESX.TriggerServerCallback('staff:getOtherPlayerData', function(data)
		fouilleElements = {}

		for i = 1, #data.accounts, 1 do
			if data.accounts[i].name == 'dirtycash' and data.accounts[i].money > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value = 'dirtycash',
					itemType = 'item_account',
					amount = data.accounts[i].money
				})

				break
			end
		end

		table.insert(fouilleElements, {
			label = _U('inventory_label'),
			value = nil
		})

		for i = 1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(fouilleElements, {
					label = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value = data.inventory[i].name,
					itemType = 'item_standard',
					amount = data.inventory[i].count
				})
			end
		end

		table.insert(fouilleElements, {
			label = _U('guns_label'),
			value = nil
		})

		for i = 1, #data.weapons, 1 do
			table.insert(fouilleElements, {
				label = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value = data.weapons[i].name,
				itemType = 'item_weapon',
				amount = data.weapons[i].ammo
			})
		end
	end, GetPlayerServerId(thePlayer))
end

-- ban 

RegisterNetEvent('BanSql:Respond')
AddEventHandler('BanSql:Respond', function()
	TriggerServerEvent("BanSql:CheckMe")
end)

--Event Demo

--TriggerServerEvent("BanSql:ICheat")
--TriggerServerEvent("BanSql:ICheat", "Auto-Cheat Custom Reason")