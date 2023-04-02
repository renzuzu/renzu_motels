if not QBCORE then return end

GetPlayerFromId = function(src)
	local self = QBCORE.Functions.GetPlayer(src)
	if not self then return end
	
	if self.identifier == nil then
		self.identifier = self.PlayerData.citizenid
	end

	self.getMoney = function(value)
		return self.PlayerData.money['cash']
	end

	self.removeMoney = function(value)
		self.Functions.RemoveMoney('cash',tonumber(value))
		return true
	end
	self.name = self.PlayerData.charinfo.firstname

	self.addMoney = function(value)
		return self.Functions.AddMoney('cash',tonumber(value))
	end

	self.removeAccountMoney = function(type,val)
		if type == 'money' then type = 'cash' end
		self.Functions.RemoveMoney(type,tonumber(val))
		return true
	end

	self.getAccount = function(type)
		if type == 'money' then type = 'cash' end
		return {money = self.PlayerData.money[type]}
	end

	return self
end