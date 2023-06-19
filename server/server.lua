--local QBCore = exports[Config.Core]:GetCoreObject()
ESX = exports["es_extended"]:getSharedObject()
local ScreenShotHook = "YOUR WEBHOOK HERE"
local MugShotHook = "YOUR WEBHOOK HERE"

--[[QBCore.Functions.CreateCallback("kael-mugshot:server:GetWebhook", function(source, cb)
    cb(ScreenShotHook)
end)]]

ESX.RegisterServerCallback('kael-mugshot:server:GetWebhook', function(source, cb)
    cb(ScreenShotHook)
end)


RegisterNetEvent("kael-mugshot:server:takemugshot", function(targetid)
    local TargetId = tonumber(targetid)
    local Target = ESX.GetPlayerFromId(TargetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Target then 
        if TargetId ~= source then
            TriggerClientEvent("kael-mugshot:client:takemugshot", TargetId, source)
        else 
	-- make sure to delete this
	TriggerClientEvent("kael-mugshot:client:takemugshot", TargetId, source)
        --    xPlayer.showNotification('You Cant Take Mugshot Your Self!')
        end
    else
        xPlayer.showNotification('Citizen Id Invalid!')
    end
end)

RegisterNetEvent("kael-mugshot:server:MugLog", function(officer, MugShot)
    local Suspect = ESX.GetPlayerFromId(source)
    local Police = ESX.GetPlayerFromId(officer)
    local suspectName = Suspect.PlayerData.name
    local suspectCitizenID = 'OKC-'ESX.GetRandomString(5)
    local suspectDOB = Suspect.PlayerData.dateofbirth
    local policeName = Police.PlayerData.name  
    local embedData = {
        {
            ['title'] = Config.LogTitle,
            ['color'] = 16761035,
            ['footer'] = {
                ['text'] = os.date( "!%a %b %d, %H:%M", os.time() + 6 * 60 * 60 ),
            },
            ['fields'] = {
                {['name'] = "Suspect:", ['value'] = "```" .. suspectName .. "```", ['inline'] = false},
                {['name'] = "Date Of Birth:", ['value'] = "```" .. suspectDOB .. "```", ['inline'] = false},
                {['name'] = "Citizen ID:", ['value'] = "```" .. suspectCitizenID .. "```", ['inline'] = false},
                {['name'] = "Officer:", ['value'] = "```" .. policeName .. "```", ['inline'] = false},
            },
            ['image'] = {
                ['url'] = MugShot,
            },
            ['author'] = {
                ['name'] = Config.LogName,
                ['icon_url'] = Config.LogIcon,
            },
        }
    }
    PerformHttpRequest(MugShotHook, function() end, 'POST', json.encode({ username = Config.LogName, embeds = embedData}), { ['Content-Type'] = 'application/json' })
end)
