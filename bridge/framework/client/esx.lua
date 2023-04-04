if not ESX then return end
PlayerData = ESX.GetPlayerData()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(playerData) 
	PlayerData = playerData 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

GetInventoryItems = function(name)
    local PlayerData = ESX.GetPlayerData()
    local data = {}
    for _, item in pairs(PlayerData.inventory) do
        if name == item.name then
            table.insert(data,item)
        end
    end
    return data
end