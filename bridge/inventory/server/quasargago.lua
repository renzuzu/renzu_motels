if GetResourceState('qs-inventory') ~= 'started' then return end

AddItem = function(src, item, count, metadata)
	if metadata then metadata.showAllDescriptions = true end
	return TriggerEvent('inventory:server:addItem', src, item, count, false, metadata)
end

RemoveItem = function(src, item, count, metadata)
	return TriggerEvent('inventory:server:removeItem', src, item, count, false, metadata)
end