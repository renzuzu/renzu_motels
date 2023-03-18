if GetResourceState('qb-inventory') ~= 'started' then return end

AddItem = function(src, item, count, metadata)
	return exports['qb-inventory']:AddItem(src, item, count, slot, metadata)
end

RemoveItem = function(src, item, count, metadata)
	return exports['qb-inventory']:RemoveItem(src, item, count, slot, metadata)
end