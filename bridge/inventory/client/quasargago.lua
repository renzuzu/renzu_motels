if GetResourceState('qs-inventory') ~= 'started' then return end

OpenStash = function(data,identifier)
	TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'stash_'..data.motel..'_'..identifier..'_'..data.index, {})
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
	TriggerEvent("inventory:client:SetCurrentStash", 'stash_'..data.motel..'_'..identifier..'_'..data.index)
end