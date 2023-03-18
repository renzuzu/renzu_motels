if not QBCORE then return end

GetPlayerFromId = function(src)
	local xPlayer = QBCORE.Functions.GetPlayer(src)
	if not xPlayer then return end
	
	if xPlayer.identifier == nil then
		xPlayer.identifier = xPlayer.PlayerData.citizenid
	end

	xPlayer.getMoney = function(value)
		return xPlayer.PlayerData.money['cash']
	end

	xPlayer.removeMoney = function(value)
		xPlayer.Functions.RemoveMoney('cash',tonumber(value))
		return true
	end
	xPlayer.name = xPlayer.PlayerData.charinfo.firstname

	xPlayer.addMoney = function(value)
		return xPlayer.Functions.AddMoney('cash',tonumber(value))
	end
	return xPlayer
end