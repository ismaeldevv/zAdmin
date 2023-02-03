TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local staff = {}
local allreport = {}
local reportcount = {}
RegisterCommand('report', function(source, args, user)
    local xPlayerSource = ESX.GetPlayerFromId(source)
    local isadded = false
    for k,v in pairs(reportcount) do
        if v.id == source then
            isadded = true
        end
    end
    if not isadded then
        table.insert(reportcount, { 
            id = source,
            gametimer = 0
        })
    end
    for k,v in pairs(reportcount) do
        if v.id == source then
            if v.gametimer + 120000 > GetGameTimer() and v.gametimer ~= 0 then
                TriggerClientEvent('esx:showAdvancedNotification', source, 'SUPPORT', '~r~'..GetPlayerName(source)..'', 'Vous devez patienter ~r~2 minute~s~ avant de faire de nouveau un ~r~report !', 'CHAR_BLOCKED', 0)
                return
            else
                v.gametimer = GetGameTimer()
            end
        end
    end
    TriggerClientEvent('esx:showNotification', source, 'Votre report à été envoyé\nUn membre de notre équipe va vous prendre en charge !', '~r~' ..GetPlayerName(source).. '', 'Votre Report a bien été envoyé ', 0)
    PerformHttpRequest(Config.webhook.report, function(err, text, headers) end, 'POST', json.encode({username = "REPORT", content = "``REPORT``\n```ID : " .. source .. "\nNom : " .. GetPlayerName(source) .. "\nMessage : " .. table.concat(args, " ") .. "```"}), { ['Content-Type'] = 'application/json' })
    table.insert(allreport, {
        id = source,
        name = GetPlayerName(source),
        reason = table.concat(args, " ")
    })
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Nouveau Report', '[~b~'..source..'~s~] ~r~'..GetPlayerName(source)..'', 'Raison du report : ~n~'.. table.concat(args, " "), 'CHAR_ARTHUR', 0)
            TriggerClientEvent("Zortix:RefreshReport", xPlayer.source)
        end
    end
end)

ESX.RegisterServerCallback('Zortix:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)


local MySQL_Ready = false
MySQL.ready(function ()
    MySQL_Ready = true
end)

function getTime()
    return os.time(os.date("!*t"))
end

function dateFromTimestamp (timestamp)
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

function ArrayLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function inArray(target, table)
    for a,b in ipairs(table) do
        if target == b then
            return true
        end
    end
    return false
end

function getIdentifier(id)
    return GetPlayerIdentifiers(id)[1]
end

function getLicense (id)
    return GetPlayerIdentifiers(id)[2]
end

function getIpAddress(id)
    return GetPlayerEndpoint(id)
end

function isBan (license)
    local isban_mysql = MySQL.Sync.fetchAll("SELECT * FROM banlist WHERE license = @license", {["@license"] = license})
    if not MySQL_Ready then
        return {true, "La base de données n'est pas encore connectée."}
    end
    if ArrayLength(isban_mysql) == 0 then
        return {false}
    end
    for ban in pairs(isban_mysql) do
        local mysql_reason = isban_mysql[ban]["reason"]
        local mysql_admin_name = isban_mysql[ban]["admin_name"]
        local mysql_time = isban_mysql[ban]["time"]
        if mysql_time == "permanent" then
			if mysql_reason == "Vous avez été banni définitivement par l'Anti-Cheat de zbase" then
				return {true, mysql_reason}
			end
            return {true, string.format("Ban pour: "..mysql_reason.. " | Par :" .. mysql_admin_name)}
        else
            mysql_time = tonumber(mysql_time)
            if getTime() < mysql_time then
                local date_time = dateFromTimestamp(mysql_time)
                return {true, string.format("Banni pour :"..mysql_reason.. "| Expiration : "..date_time.." - Jour(s) | Par : " .. mysql_admin_name)}
            end
        end
    end
    return {false}
end


RegisterServerEvent("Zortix:SendLogs")
AddEventHandler("Zortix:SendLogs", function(action)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest(Config.webhook.SendLogs, function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nNom : " .. GetPlayerName(source) .. "\nAction : ".. action .." !```" }), { ['Content-Type'] = 'application/json' })
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:onStaffJoin")
AddEventHandler("Zortix:onStaffJoin", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'STAFF MODE', '', '~r~'..GetPlayerName(source)..'~s~ à ~g~activer~s~ son StaffMode ', 'CHAR_BUGSTARS', 0)
        end
    end
    if xPlayer.getGroup() ~= "user" then
        print(GetPlayerName(source) ..' ^2Activer^0 StaffMode^0')
        PerformHttpRequest(Config.webhook.Staffmodeon , function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``STAFF MODE ON``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Active Staff Mode !```" }), { ['Content-Type'] = 'application/json' })
        table.insert(staff, source)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:onStaffLeave")
AddEventHandler("Zortix:onStaffLeave", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'STAFF MODE', '', '~r~'..GetPlayerName(source).. '~s~ à ~r~désactiver~s~ son StaffMode ', 'CHAR_BUGSTARS', 0)
        end
    end
    if xPlayer.getGroup() ~= "user" then
        print(GetPlayerName(source) ..' ^1Désactiver^0 StaffMode^0')
        PerformHttpRequest(Config.webhook.Staffmodeoff , function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``STAFF MODE OFF``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Désactive Staff Mode !```" }), { ['Content-Type'] = 'application/json' })
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:GiveMoney")
AddEventHandler("Zortix:GiveMoney", function(type, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "_dev" then
        PerformHttpRequest(Config.webhook.givemoney , function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "```\nName : " .. GetPlayerName(source) .. "\nAction : Give Money ! " .. "\n\nAmount : " .. money .. "\nType : " .. type .. "``` <@&989512047932882974> Faites gaffe les reufs, y'a eu un give d'argent là, c'est la sauce 🌭" }), { ['Content-Type'] = 'application/json' })
        if type == "money" then
            xPlayer.addAccountMoney('money', money)
        end
        if type == "bank" then
            xPlayer.addAccountMoney('bank', money)
        end
        if type == "black_money" then
            xPlayer.addAccountMoney('black_money', money)
        end
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:teleport")
AddEventHandler("Zortix:teleport", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest(Config.webhook.teleport , function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``TELEPORT``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Téléporter aux joueurs ! " .. "\n\n" .. "Nom de la personne : " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("Zortix:teleport", source, GetEntityCoords(GetPlayerPed(id)))
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:teleportTo")
AddEventHandler("Zortix:teleportTo", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest(Config.webhook.teleportTo , function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``TELEPORT SUR SOI MEME``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Téléportez les joueurs à l'administrateur ! " .. "\n\n" .. "Nom de la personne : " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("Zortix:teleport", id, GetEntityCoords(GetPlayerPed(source)))
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:Revive")
AddEventHandler("Zortix:Revive", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest(Config.webhook.revive, function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``REVIVE``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Revive ! " .. "\n\n" .. "Nom de la personne revive : " .. GetPlayerName(id) .. "```" }), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("esx_ambulancejob:revive", id)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:teleportcoords")
AddEventHandler("Zortix:teleportcoords", function(id, coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        TriggerClientEvent("Zortix:teleport", id, coords)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:kick")
AddEventHandler("Zortix:kick", function(id, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        PerformHttpRequest(Config.webhook.kick, function(err, text, headers) end, 'POST', json.encode({username = "AdminMenu", content = "``KICK``\n```\nNom : " .. GetPlayerName(source) .. "\nAction : Kick Players ! " .. "\n\n" .. "Nom de la personne  : " .. GetPlayerName(id) .. "\n" .. "Reason : " .. reason .. "```" }), { ['Content-Type'] = 'application/json' })
        DropPlayer(id, reason)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:Ban")
AddEventHandler("Zortix:Ban", function(id, temps, raison)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        TriggerEvent("SqlBan:ZortixBan", id, temps, raison, source)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

RegisterServerEvent("Zortix:ReportRegle")
AddEventHandler("Zortix:ReportRegle", function(idt)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        for i, v in pairs(allreport) do
            if i == idt then
                TriggerClientEvent('esx:showNotification', source, 'Votre report à été envoyé\nUn membre de notre équipe va vous prendre en charge !', '~r~' ..GetPlayerName(source).. '', 'Votre Report a bien été envoyé ', 0)
            end
        end
        TriggerClientEvent('esx:showAdvancedNotification', source, 'Administration', '~r~Informations', 'Le ~r~Report~s~ a bien été cloturé ', 'CHAR_SUNLITE', 2)
        allreport[idt] = nil
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

ESX.RegisterServerCallback('Zortix:retrievePlayers', function(playerId, cb)
    local players = {}
    local xPlayers = ESX.GetPlayers()
    local date = os.date("le %d/%m/%Y à %X")
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {
            id = "0",
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName(),
            dateRpt = date,
            idsrc = xPlayer.identifier,
        })
    end

    cb(players)
end)

ESX.RegisterServerCallback('Zortix:retrieveStaffPlayers', function(playerId, cb)
    local playersadmin = {}
    local xPlayers = ESX.GetPlayers()
    local date = os.date("le %d/%m/%Y à %X")

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
        table.insert(playersadmin, {
            id = "0",
            group = xPlayer.getGroup(),
            source = xPlayer.source,
            jobs = xPlayer.getJob().name,
            name = xPlayer.getName(),
            dateOn = date
        })
    end
end

    cb(playersadmin)
end)

RegisterServerEvent("Zortix:noclipkey")
AddEventHandler("Zortix:noclipkey", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "_dev" then
        TriggerClientEvent("Zortix:noclipkey", source)    
    end
end)


RegisterServerEvent("Zortix:ouvrirmenu1")
AddEventHandler("Zortix:ouvrirmenu1", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "_dev" then
        TriggerClientEvent("Zortix:menu1", source)        
    end
end)

RegisterServerEvent("Zortix:ouvrirmenu2")
AddEventHandler("Zortix:ouvrirmenu2", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "help" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "_dev" then
        TriggerClientEvent("Zortix:menu2", source)    
    end
end)


ESX.RegisterServerCallback('Zortix:retrieveReport', function(playerId, cb)
    cb(allreport)
end)

RegisterNetEvent("Zortix:Message")
AddEventHandler("Zortix:Message", function(id, type)
	TriggerClientEvent("Zortix:envoyer", id, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        TriggerClientEvent("Zortix:envoyer", id, type)
    else
        TriggerEvent("BanSql:ICheatServer", source, "CHEAT")
    end
end)

local ActifsEvents = {}
RegisterNetEvent('Zortix:StartEventsStaff')
AddEventHandler('Zortix:StartEventsStaff', function(type, time)
	table.insert(ActifsEvents, {name = GetPlayerName(source), down = true, type = type, time = time*60*1000})
end)

ESX.RegisterServerCallback('Zortix:GetEventStarted', function(source, cb)
	if ActifsEvents ~= nil then
		cb(ActifsEvents)
	end
end)

-- Events

local eventStarted = true
RegisterNetEvent("Zortix:StartsEvents")
AddEventHandler("Zortix:StartsEvents", function(type, time, number)
	local randomEvent = Config.Events[type]
	local i = math.random(1, #randomEvent.possibleZone)
	local zone = randomEvent.possibleZone[i]
	TriggerClientEvent("Zortix:SendsEvents", -1, randomEvent, zone, time)
	Citizen.Wait(time*60*1000)
	TriggerClientEvent("Zortix:DeleteEvent", -1)
	if eventStarted then
		TriggerClientEvent("zAdmin:StopsEvents", -1)
	end
end)

RegisterNetEvent("zAdmin:GetMoneyInsEvents")
AddEventHandler("zAdmin:GetMoneyInsEvents", function(nombre)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(nombre)
end)

RegisterNetEvent("zAdmin:TakeRecInsEvents")
AddEventHandler("zAdmin:TakeRecInsEvents", function()
	TriggerClientEvent("zAdmin:StopsEvents", -1)
	eventStarted = false
end)

RegisterNetEvent("zAdmin:GetItemInsEvents")
AddEventHandler("zAdmin:GetItemInsEvents", function(item, nombre)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, nombre)
end)

RegisterServerEvent("zAdmin:StaffSetJob")
AddEventHandler("zAdmin:StaffSetJob", function(Target, JobName, JobGrade)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(Target)
	xTarget.setJob(JobName, JobGrade)
end)

RegisterServerEvent("zAdmin:StaffSetGrade")
AddEventHandler("zAdmin:StaffSetGrade", function(Target, GroupeName)
	local xTarget = ESX.GetPlayerFromId(Target)
    xTarget.setGroup(GroupeName)
end)

RegisterNetEvent("freezePly")
AddEventHandler("freezePly", function(src, state)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        TriggerClientEvent("freezePlys", src, state)
    end
end)

RegisterServerEvent("zAdmin:StaffSetJob2")
AddEventHandler("zAdmin:StaffSetJob2", function(Target, JobName, JobGrade)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(Target)
	xTarget.setJob2(JobName, JobGrade)
end)

ESX.RegisterServerCallback('zAdmin:GetItemList', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM `items` ORDER BY `items`.`label` ASC', {
	}, function(Items)
        cb(Items)
	end)
end)

ESX.RegisterServerCallback('zAdmin:GetJailPlayer', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM kc_jails WHERE license = @license', {
		['@license'] = xPlayer.identifier
	}, function(result) 
		cb(result)  
	end)  
end)

RegisterServerEvent("zAdmin:Jail")
AddEventHandler("zAdmin:Jail", function(target_id, time, s)
	local Source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local user_name = GetPlayerName(target_id)
    local user_license = getLicense(target_id)
    local admin_name = GetPlayerName(Source)
    local admin_identifier = getIdentifier(Source)
	if admin_name == nil then admin_name = GetPlayerName(s) end
	if admin_identifier == nil then admin_identifier = getIdentifier(s) end
    local time = time * 60
    local timestamp = getTime() + time
     MySQL.Async.execute("INSERT INTO kc_jails (license, name, admin_name, admin_identifier, time, time_s) VALUES (@license, @name, @admin_name, @admin_identifier, @timestamp, @time)", {["@license"] = user_license, ["@name"] = user_name, ["@admin_name"] = admin_name, ["@admin_identifier"] = admin_identifier, ["@timestamp"] = timestamp, ["@time"] = time}, function(rows)
        if rows == 1 then
			TriggerClientEvent("zAdmin:JailPly", target_id, time)
            RegisterNetEvent("Zortix:RefreshListJail", xPlayer.source)
		end
    end)
end)

RegisterServerEvent("zAdmin:Ban")
AddEventHandler("zAdmin:Ban", function (target_id, reason, time)
	local Source = source
    local user_name =  GetPlayerName(target_id)
    local user_identifier = getIdentifier(target_id)
    local user_license = getLicense(target_id)
    local user_ip = getIpAddress(target_id)
    local date = getTime()
    local admin_name = GetPlayerName(Source)
    local admin_identifier = getIdentifier(Source)
	if admin_name == nil then admin_name = GetPlayerName(target_id) end
	if admin_identifier == nil then admin_identifier = getIdentifier(target_id) end
    local reason_
    if time == "permanent" then
        reason_ = string.format("Banni pour : "..reason.. "| Expiration: JAMAIS ahahaaha :) | Par : " .. admin_name)
    else
        time = getTime() + time*86400
        reason_ = string.format("Banni pour : "..reason.. "| Expiration : "..dateFromTimestamp(time).." | Par : " .. admin_name)
    end
    MySQL.Async.execute("INSERT INTO banlist (identifier, license, reason, targetplayername, playerip, sourceplayername, timeat, expiration) VALUES (@identifier, @license, @reason, @targetplayername, @playerip, @sourceplayername, @timeat, @expiration)", {
        ["@identifier"] = user_identifier, 
        ["@license"] = user_license, 
        ["@reason"] = reason, 
        ["@targetplayername"] = user_name, 
        ["@playerip"] = user_ip, 
        ["@sourceplayername"] = admin_name, 
        ["@timeat"] = time, 
        ["@expiration"] = date
    }, function(rows)
        if rows == 1 then
			DropPlayer(target_id, reason_)
        end
    end)


end)

RegisterServerEvent("zAdmin:UnJail")
AddEventHandler("zAdmin:UnJail", function (target_id)
    local Source = source
    local user_license = getLicense(target_id)
		MySQL.Async.execute("DELETE FROM kc_jails WHERE license = @license", {["@license"] = user_license}, function (rows)
			if rows == 1 then
				TriggerClientEvent("zAdmin:UnJailPly", target_id)
				CancelEvent()
				return
			end
		end)
		local jail_time_sql = MySQL.Sync.fetchAll("SELECT time FROM kc_jails WHERE license = @license", {["@license"] = user_license})
		if jail_time_sql[1] == nil then
			CancelEvent()
			return
		end 
		local jail_time = jail_time_sql[1]["time"]
		jail_time = tonumber(jail_time)
		if getTime() >= jail_time then
		local unjail_sql = MySQL.Sync.execute("DELETE FROM kc_jails WHERE license = @license", {["@license"] = user_license})
		TriggerClientEvent("zAdmin:UnJailPly", target_id)
	end
end)

RegisterServerEvent("zAdmin:Kick")
AddEventHandler("zAdmin:Kick", function (target_id, reason)
	DropPlayer(target_id, reason)
end)

--[[RegisterServerEvent("zAdmin:WarnPly")
AddEventHandler("zAdmin:WarnPly", function (user_id, reason, date, table_id)
    local user_name = GetPlayerName(user_id)
    local user_identifier = GetPlayerIdentifiers(user_id)[1]
	local user_license = GetPlayerIdentifiers(user_id)[2]
    local admin_name = GetPlayerName(source)
    local admin_identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.execute("INSERT INTO kc_warns (name, identifier, license, admin_name, admin_identifier, reason, timestamp) VALUES (@user_name, @user_identifier, @user_license, @admin_name, @admin_identifier, @reason, @timestamp)", {["@user_name"] = user_name, ["@user_identifier"] = user_identifier, ["@user_license"] = user_license, ["@admin_name"] = admin_name, ["@admin_identifier"] = admin_identifier, ["@reason"] = reason, ["@timestamp"] = date}, function(rows)
        if rows == 1 then
            MySQL.Async.fetchAll("SELECT id FROM kc_warns WHERE admin_identifier=@admin_identifier AND identifier=@identifier AND timestamp=@timestamp AND reason=@reason", {["@admin_identifier"] = admin_identifier, ["@identifier"] = user_identifier, ["@timestamp"] = date, ["@reason"] = reason}, function (result)
                MySQL.Async.fetchAll("SELECT id FROM kc_warns WHERE identifier=@identifier", {["@identifier"] = user_identifier}, function(result)
                    warn_count = ArrayLength(result)
                    if warn_count >= 10 then
                        TriggerEvent("zAdmin:Ban", user_id, "Acumulation de warns. Warns: " .. warn_count, "permanent")
                        return
                    end
                    if warn_count == 6 then
                        TriggerEvent("zAdmin:Ban", user_id, "Acumulation de warns. Warns: " .. warn_count ,1468800)
                        return
                    end
                    if warn_count == 3 then
                        TriggerEvent("zAdmin:Ban", user_id, "Acumulation de warns. Warns: " .. warn_count, 259200)
                        return
                    end
                end)
            end)
        end
    end)
end)]]

RegisterServerEvent("zAdmin:SendWarnNotif")
AddEventHandler("zAdmin:SendWarnNotif", function(player, warn)
	TriggerClientEvent("zAdmin:WarnMessage", player, warn)
end)

RegisterNetEvent('DeleteSanction')
AddEventHandler('DeleteSanction', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        MySQL.Async.execute('DELETE FROM sanction WHERE id = @id', {
            ['@id'] = id 
        })
    end
end)

RegisterNetEvent('SetSanction')
AddEventHandler('SetSanction', function(id, sanction)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        MySQL.Async.execute('INSERT INTO sanction (have, give, raison, date) VALUES (@have, @give, @raison, @date)', {
            ['@have']   = GetPlayerIdentifier(id), 
            ['@give']   = GetPlayerName(source),
            ['@raison']   = sanction,
            ['@date']   = os.date("*t").day.."/"..os.date("*t").month,
        })
    end
end)

RegisterServerEvent("zAdmin:StaffGiveItem")
AddEventHandler("zAdmin:StaffGiveItem", function(Target, ItemName, ItemLabel, ItemCount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(Target)
	xTarget.addInventoryItem(ItemName, ItemCount)
end)

RegisterServerEvent('cmg3_animations2:stop')
AddEventHandler('cmg3_animations2:stop', function(targetSrc)
	TriggerClientEvent('cmg3_animations2:cl_stop', targetSrc)
end)

RegisterServerEvent('cmg3_animations2:sync')
AddEventHandler('cmg3_animations2:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations2:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cmg3_animations2:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

-- GetJob
ESX.RegisterServerCallback('zAdmin:GetJobList', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM `jobs` ORDER BY `jobs`.`label` ASC', {
	}, function(Jobs)
        cb(Jobs)
	end)
end)

ESX.RegisterServerCallback('zAdmin:GetGradeList', function(source, cb, JobName)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM `job_grades` WHERE job_name = @job_name', {
		['@job_name'] = JobName
	}, function(Grades)
        cb(Grades)
	end)
end)