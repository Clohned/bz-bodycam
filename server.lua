ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('hasbodycam:item', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
	-- TriggerClientEvent('Cam:ToggleCam', source)
end)
function getIdentity(source)

	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = source})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height']
			
		}
	else
		return nil
	end
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1000)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
         if xPlayer.job.name == 'police' then
            local name = getIdentity(xPlayer.identifier)
			TriggerClientEvent('ybn_bodycam:show', xPlayers[i], name.firstname .. ' ' .. name.lastname, xPlayer.job.grade_label)
		 else 
			TriggerClientEvent('ybn_bodycam:close', xPlayers[i])
		end
	end
end
end)