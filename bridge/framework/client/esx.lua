if not ESX then return end
PlayerData = ESX.GetPlayerData()
local kvpname = GetCurrentServerEndpoint()..'_inshells'

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(playerData) 
	PlayerData = playerData 
    local login = GetResourceKvpString(kvpname)
	if not login then return end
    local data = json.decode(login)
    LocalPlayer.state:set('inshell',true,true)
    LocalPlayer.state:set('lastloc',data.lastloc,false)
    DoScreenFadeOut(0)
	EnterShell(data,true)
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