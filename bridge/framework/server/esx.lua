if not ESX then return end

GetPlayerFromId = function(src)
	if type(src) == 'string' then
		return ESX.GetPlayerFromIdentifier(src)
	end
	return ESX.GetPlayerFromId(src)
end