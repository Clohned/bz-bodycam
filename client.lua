ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

local bodycam = false
local PlayerData = {}

RegisterNetEvent("ybn_bodycam:show")
AddEventHandler("ybn_bodycam:show", function(daner, job)
    local year , month, day , hour , minute , second  = GetLocalTime()

    if bodycam == true then
        if string.len(tostring(minute)) < 2 then
            minute = '0' .. minute
        end
        if string.len(tostring(second)) < 2 then
            second = '0' .. second
        end
        if string.len(tostring(day)) then
            day = day - 1
        end
        SendNUIMessage({
            date = month .. '/'.. day .. '/' .. year .. ' ' .. hour .. ':' .. minute .. ':' .. second,
            daneosoby = daner,
            ranga = job,
            open = true,
        })
    end
end)

RegisterCommand("bodycam", function()
	local _source = source
    ESX.TriggerServerCallback('hasbodycam:item', function(qtty)
        if qtty > 0 then
            if not bodycam then
                bodycam = true
                TriggerEvent('ybn_bodycam:show')
            else
                bodycam = false
                TriggerEvent('ybn_bodycam:close')
            end
    if not (GetFollowPedCamViewMode() == 4) then
        exports['mythic_notify']:SendAlert('inform', 'Not in first person', 2500)
        bodycam = false
        TriggerEvent('ybn_bodycam:close')
    end
        else
            exports['mythic_notify']:SendAlert('inform', 'No bodycam on your person', 2500)
        end
    end, 'bodycam')
end, false)

RegisterNetEvent("ybn_bodycam:close")
AddEventHandler("ybn_bodycam:close", function()
    SendNUIMessage({
        open = false
    })
end)
