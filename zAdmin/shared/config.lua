Config = {}


Config = {
    webhook = { -- Vos logs
        Staffmodeon = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",   
        Staffmodeoff = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",   
        teleport = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",
        teleportTo = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",
        revive = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",
        kick = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",
        SendLogs = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",        
        report = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk",
        givemoney = "https://discord.com/api/webhooks/1033832764769837156/eI7gaqInQrbJP6Wb4ayKJJ1rZ8UqF-tBfGI_VyjrCBjrFxJXCWiSJf0PYj-euu6Z78Jk"
    },
    EventActif = {}, --Ne pas toucher
    EventTypeIndex = 1, --Ne pas toucher
    JobsList = {}, --Ne pas toucher
    TimeEvent = {}, --Ne pas toucher
    MaxJoueurs = {}, --Ne pas toucher
    IndexTimeEvent = 1, --Ne pas toucher
    ItemsList = {}, --Ne pas toucher
    ListIndex = 1, --Ne pas toucher
    remboursement = 1, --Ne pas toucher
    AllAl = 1, --Ne pas toucher

    sanctions = 1, --Ne pas toucher
    ban = 1, --Ne pas toucher
    Private = 1, --Ne pas toucher
    GetJailPlayer = {}, --Ne pas toucher
    MoneyList = {
        {label = "Argent liquide", value = "base"}, --Ne pas toucher
        {label = "Argent en banque", value = "money"}, --Ne pas toucher
        {label = "Argent sale", value = "black_money"}, --Ne pas toucher
    },
    TypeMarker = {Index = 1}, --Ne pas toucher
    HeightMarker = {Index = 1}, --Ne pas toucher
    RotateMarker = {IndexX = 1, IndexY = 1, IndexZ = 1}, --Ne pas toucher
    ListColor = {IndexMarker = 1, IndexRect = 1, "Rouge", "Vert", "Bleu", "Opacité"}, --Ne pas toucher
    CoordsList = {Index = 1, "vector3", "x, y, z", "{x, y, z}"}, --Ne pas toucher
    DrawRectPostion = {X = 0.5, Y = 0.5}, --Ne pas toucher
    DrawRectWidth = 0.5, --Ne pas toucher
    DrawRectHeight = 0.5, --Ne pas toucher
    Events = {
        ["DRUGS"] = { --Ne pas toucher
            type = "drugs", --Ne pas toucher
            message = "Une cargaison de drogue a été trouvée ! Viens la récupérer avant la LSPD !", -- Modifié par votre messsage
            possibleZone = {
                vector3(488.5908, -3362.791, 6.069853), -- Modifié par les différentes position
                vector3(-2119.944, -494.6833, 3.23038),
                vector3(-1241.547, -1842.904, 2.140611),
            },
            prop = {
                "bkr_prop_coke_box_01a", --Ne pas toucher
                "bkr_prop_coke_doll_bigbox", --Ne pas toucher
                "bkr_prop_weed_bigbag_01a", --Ne pas toucher
                "bkr_prop_weed_bigbag_02a", --Ne pas toucher
                "bkr_prop_weed_bigbag_03a", --Ne pas toucher
                "bkr_prop_weed_bigbag_open_01a", --Ne pas toucher
                "bkr_prop_weed_bucket_01a", --Ne pas toucher
                "bkr_prop_weed_bucket_01b", --Ne pas toucher
                "bkr_prop_weed_bucket_01c", --Ne pas toucher
            },
            item = { -- Relié a vos items de drogues illégals
                "weed_pochon",
                "coke_pochon",
                "opium_pochon", 
                "meth_pochon", 
                "lsd_pochon",
                "resine_pochon",
            },
        },
        ["BRINKS"] = { --Ne pas toucher
            type = "brinks", --Ne pas toucher
            message = "Un fourgon blindé vient de se faire pété ! Viens récupérer l'argent avant la LSPD !", --Modifié le message
            possibleZone = { -- Modifié par vos poses ou pas toucher
                vector3(18.79272, -1073.074, 38.15213),
                vector3(55.42496, -1672.947, 29.29726),
                vector3(776.0305, -2064.744, 29.3819),
                vector3(862.7224, -913.9108, 25.94606),
            },
            prop = { -- Reegarder coté serveur pour le montant d'argent
                "bkr_prop_moneypack_01a",
                "bkr_prop_moneypack_02a",
                "bkr_prop_moneypack_03a",
            },
        },
        ["CAISSE"] = {
            type = "caisse", --Ne pas toucher
            message = "~g~EVENEMENT EN COURS\n~w~Nous venons de retrouver une cargaison de caisse mystère !", --    Modifié par votre message
            possibleZone = { -- Modifié les poses ou pas toucher
                vector3(646.7936, 585.9033, 128.9108),
                vector3(328.4607, 346.0337, 105.288),
                vector3(-327.9891, -2700.65, 7.549608)
            },
            prop = { --Ne pas toucher
                "prop_apple_box_01",
            },
            item = { -- rélié a votre system de boutique
                "caisse",
            },
        },
    },
    Touche = { -- Vos touches
        Noclip = 170, --F3
        Menu = 57, --F10
        MenuReport = 344, --F11
    },
    grade = 1, --Ne pas toucher
    CheckboxFreezePlayer = false, --Ne pas toucher
    GetSanction = {}, --Ne pas toucher
}

--GENERAL
Config.Lang              = 'fr'    --Set lang (fr-en)
Config.Permission        = "admin" --L'autorisation doit utiliser les commandes FiveM-BanSql (mod-admin-superadmin)
Config.ForceSteam        = true    --Définir sur false si vous n'utilisez pas l'authentification Steam
Config.MultiServerSync   = false   --Cela vérifiera si une interdiction est ajoutée dans le sql toutes les 30 secondes, utilisez-la uniquement si vous avez plus d'un serveur (true-false)


--WEBHOOK
Config.EnableDiscordLink = false --Transformez cela en vrai si vous voulez lier le journal à un discord (true-false)
Config.webhookban        = "https://discordapp.com/api/webhooks/473571126690316298/oJZBU9YLz9ksOCG_orlf-wpMZ2pkFedfpEsC34DN_iHO0CBBp6X06W3mMJ2RvMMK7vIO"
Config.webhookunban      = "https://discordapp.com/api/webhooks/473571126690316298/oJZBU9YLz9ksOCG_orlf-wpMZ2pkFedfpEsC34DN_iHO0CBBp6X06W3mMJ2RvMMK7vIO"


--LANGUAGE
Config.TextFr = {
	start         = "La BanList et l'historique a ete charger avec succes",
	starterror    = "ERREUR : La BanList ou l'historique n'a pas ete charger nouvelle tentative.",
	banlistloaded = "La BanList a ete charger avec succes.",
	historyloaded = "La BanListHistory a ete charger avec succes.",
	loaderror     = "ERREUR : La BanList n a pas été charger.",
	cmdban        = "/sqlban (ID) (Durée en jours) (Raison)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Durée en jours) (Raison)",
	cmdhistory    = "/sqlbanhistory (Steam name) ou /sqlbanhistory 1,2,2,4......",
	noreason      = "Raison Inconnue",
	during        = " pendant : ",
	noresult      = "Il n'y a pas autant de résultats !",
	isban         = " a été ban",
	isunban       = " a été déban",
	invalidsteam  =  "Vous devriez ouvrir steam",
	invalidid     = "ID du joueur incorrect",
	invalidname   = "Le nom n'est pas valide",
	invalidtime   = "Duree du ban incorrecte",
	alreadyban    = " étais déja bannie pour : ",
	yourban       = "Vous avez ete ban pour : ",
	yourpermban   = "Vous avez ete ban permanent pour : ",
	youban        = "Vous avez banni : ",
	forr          = " jours. Pour : ",
	permban       = " de facon permanente pour : ",
	timeleft      = ". Il reste : ",
	toomanyresult = "Trop de résultats, veillez être plus précis.",
	day           = " Jours ",
	hour          = " Heures ",
	minute        = " Minutes ",
	by            = "par",
	ban           = "Bannir un joueurs qui est en ligne",
	banoff        = "Bannir un joueurs qui est hors ligne",
	bansearch     = "Trouver l'id permanent d'un joueur qui est hors ligne",
	dayhelp       = "Nombre de jours",
	reason        = "Raison du ban",
	permid        = "Trouver l'id permanent avec la commande (sqlsearch)",
	history       = "Affiche tout les bans d'un joueur",
	reload        = "Recharge la BanList et la BanListHistory",
	unban         = "Retirez un ban de la liste",
	steamname     = "(Nom Steam)",
}


Config.TextEn = {
	start         = "BanList and BanListHistory loaded successfully.",
	starterror    = "ERROR: BanList and BanListHistory failed to load, please retry.",
	banlistloaded = "BanList loaded successfully.",
	historyloaded = "BanListHistory loaded successfully.",
	loaderror     = "ERROR: The BanList failed to load.",
	cmdban        = "/sqlban (ID) (Duration in days) (Ban reason)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Duration in days) (Steam name)",
	cmdhistory    = "/sqlbanhistory (Steam name) or /sqlbanhistory 1,2,2,4......",
	forcontinu    = " days. To continue, execute /sqlreason [reason]",
	noreason      = "No reason provided.",
	during        = " during: ",
	noresult      = "No results found.",
	isban         = " was banned",
	isunban       = " was unbanned",
	invalidsteam  = "Steam is required to join this server.",
	invalidid     = "Player ID not found",
	invalidname   = "The specified name is not valid",
	invalidtime   = "Invalid ban duration",
	alreadyban    = " was already banned for : ",
	yourban       = "You have been banned for: ",
	yourpermban   = "You have been permanently banned for: ",
	youban        = "You are banned from this server for: ",
	forr          = " days. For: ",
	permban       = " permanently for: ",
	timeleft      = ". Time remaining: ",
	toomanyresult = "Too many results, be more specific to shorten the results.",
	day           = " days ",
	hour          = " hours ",
	minute        = " minutes ",
	by            = "by",
	ban           = "Ban a player",
	banoff        = "Ban an offline player",
	dayhelp       = "Duration (days) of ban",
	reason        = "Reason for ban",
	history       = "Shows all previous bans for a certain player",
	reload        = "Refreshes the ban list and history.",
	unban         = "Unban a player.",
	steamname     = "Steam name"
}
