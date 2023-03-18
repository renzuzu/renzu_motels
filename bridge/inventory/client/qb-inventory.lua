if GetResourceState('qb-inventory') ~= 'started' then return end

OpenStash = function(data,identifier)
	TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'stash_'..data.motel..'_'..identifier..'_'..data.index, {})
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
	TriggerEvent("inventory:client:SetCurrentStash", 'stash_'..data.motel..'_'..identifier..'_'..data.index)
end

GetInventoryItems = function(name)
	local data = {}
	local PlayerData = QBCORE.Functions.GetPlayerData()
	for _, item in pairs(PlayerData.items) do
		if name == item.name then
			item.metadata = item.info
			table.insert(data,item)
		end
	end
	return data
end