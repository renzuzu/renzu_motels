if GetResourceState('ox_inventory') ~= 'started' then return end

OpenStash = function(data,identifier)
    TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'stash_'..data.motel..'_'..identifier..'_'..data.index, name = 'Storage', slots = 70, weight = 70000, coords = GetEntityCoords(cache.ped)})
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 0.5, 'StashOpen', 1.0)
end