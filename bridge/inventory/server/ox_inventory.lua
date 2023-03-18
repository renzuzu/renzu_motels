if GetResourceState('ox_inventory') ~= 'started' then return end

AddItem = function(src, item, count, metadata)
	return exports.ox_inventory:AddItem(src, item, count, metadata)
end

RemoveItem = function(src, item, count, metadata)
	return exports.ox_inventory:RemoveItem(src, item, count, metadata)
end