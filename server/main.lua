--DeleteResourceKvp('renzu_motels')
GlobalState.Motels = nil
local db = import 'server/sql'
local rental_period = {
	['hour'] = 3600,
	['day'] = 86400,
	['month'] = 2592000
}
CreateInventoryHooks = function(motel,Type)
	if GetResourceState('ox_inventory') ~= 'started' then return end
	local inventory = '^'..Type..'_'..motel..'_%w+'
	local hookId = exports.ox_inventory:registerHook('swapItems', function(payload)
		return false
	end, {
		print = false,
		itemFilter = config.stashblacklist[Type].blacklist,
		inventoryFilter = {
			inventory,
		}
	})
end

Citizen.CreateThreadNow(function()
	Wait(2000)
	GlobalState.Motels = db.fetchAll()
	local motels = GlobalState.Motels
	for k,v in pairs(config.motels) do
		for doorindex,_ in pairs(v.doors) do
			local doorindex = tonumber(doorindex)
			motels[v.motel].rooms[doorindex].lock = true
			if motels[v.motel].rooms[doorindex].players and GetResourceState('ox_inventory') == 'started' then
				for id,_ in pairs(motels[v.motel].rooms[doorindex].players) do
					local stashid = v.uniquestash and id or 'room'
					exports.ox_inventory:RegisterStash('stash_'..v.motel..'_'..stashid..'_'..doorindex, 'Storage', 70, 70000, false)
					exports.ox_inventory:RegisterStash('fridge_'..v.motel..'_'..stashid..'_'..doorindex, 'Fridge', 70, 70000, false)
				end
				CreateInventoryHooks(v.motel,'stash')
				CreateInventoryHooks(v.motel,'fridge')
			end
		end
	end
	GlobalState.Motels = motels
	local save = {}
	while true do
		if config.autokickIfExpire then
			local motels = GlobalState.Motels
			for motel,data in pairs(motels) do
				if not save[motel] then save[motel] = 0 end
				for doorindex,v in pairs(data.rooms or {}) do
					local doorindex = tonumber(doorindex)
					for player,char in pairs(v.players or {}) do
						if (char.duration - os.time()) < 0 then
							motels[motel].rooms[doorindex].players[player] = nil
							db.updateall('rooms = ?', '`motel`', motel, json.encode(motels[motel].rooms))
						end
					end
					if save[motel] <= 0 then
						save[motel] = 60
						db.updateall('rooms = ?', '`motel`', motel, json.encode(motels[motel].rooms))
					end
				end
				save[motel] -= 1
			end
			GlobalState.Motels = motels
		end
		GlobalState.MotelTimer = os.time()
		Wait(60000)
	end
end)

lib.callback.register('renzu_motels:rentaroom', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	local identifier = xPlayer.identifier
	if not motels[data.motel].rooms[data.index].players[identifier] and data.duration > 0 then
		local money = xPlayer.getAccount(data.payment).money
		local amount = (data.duration * data.rate)
		if money <= amount then return end
		xPlayer.removeAccountMoney(data.payment,amount)
		if not motels[data.motel].rooms[data.index].players[identifier] then motels[data.motel].rooms[data.index].players[identifier] = {} end
		motels[data.motel].rooms[data.index].players[identifier].name = xPlayer.name
		motels[data.motel].rooms[data.index].players[identifier].duration = (os.time() + ( data.duration * rental_period[data.rental_period]))
		motels[data.motel].revenue += amount
		GlobalState.Motels = motels
		db.updateall('rooms = ?, revenue = ?', '`motel`', data.motel, json.encode(motels[data.motel].rooms),motels[data.motel].revenue)
		if GetResourceState('ox_inventory') == 'started' then
			local stashid = data.uniquestash and identifier or 'room'
			exports.ox_inventory:RegisterStash('stash_'..data.motel..'_'..stashid..'_'..data.index, 'Storage', 70, 70000, false)
			exports.ox_inventory:RegisterStash('fridge_'..data.motel..'_'..stashid..'_'..data.index, 'Fridge', 70, 70000, false)
		end
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:payrent', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	local duration = data.amount / data.rate
	if duration < 1.0 then return false end
	local money = xPlayer.getAccount(data.payment).money
	if money < data.amount then
		return false
	end
	if motels[data.motel].rooms[data.index].players[xPlayer.identifier] then
		xPlayer.removeAccountMoney(data.payment,data.amount)
		motels[data.motel].revenue += data.amount
		motels[data.motel].rooms[data.index].players[xPlayer.identifier].duration += ( duration * rental_period[data.rental_period])
		GlobalState.Motels = motels
		db.updateall('rooms = ?, revenue = ?', '`motel`', data.motel, json.encode(motels[data.motel].rooms),motels[data.motel].revenue)
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:getMotels', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	return motels, os.time()
end)

lib.callback.register('renzu_motels:motelkey', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local metadata = {
		type = data.motel,
		serial = data.index,
		label = 'Motel Key',
		description = 'personal motel key for '..data.motel..' door #'..data.index..' \n Motel Room Owner: '..xPlayer.name,
		owner = xPlayer.identifier
	}
	return AddItem(src, 'keys', 1, metadata)
end)

lib.callback.register('renzu_motels:buymotel', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	local money = xPlayer.getAccount(data.payment).money
	if not motels[data.motel].owned and money >= data.businessprice then
		xPlayer.removeAccountMoney(data.payment,data.businessprice)
		motels[data.motel].owned = xPlayer.identifier
		GlobalState.Motels = motels
		db.updateall('owned = ?', '`motel`', data.motel, motels[data.motel].owned)
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:removeoccupant', function(src,data,index,player)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[data.motel].owned == xPlayer.identifier or motels[data.motel].rooms[index].players[player] then
		motels[data.motel].rooms[index].players[player] = nil
		GlobalState.Motels = motels
		db.updateall('rooms = ?', '`motel`', data.motel, json.encode(motels[data.motel].rooms))
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:addoccupant', function(src,data,index,player)
	local xPlayer = GetPlayerFromId(src)
	local toPlayer = GetPlayerFromId(tonumber(player[1]))
	local motels = GlobalState.Motels
	if motels[data.motel].owned == xPlayer.identifier and toPlayer then
		if motels[data.motel].rooms[index].players[toPlayer.identifier] then return 'exist' end
		if not motels[data.motel].rooms[index].players[toPlayer.identifier] then motels[data.motel].rooms[index].players[toPlayer.identifier] = {} end
		motels[data.motel].rooms[index].players[toPlayer.identifier].name = toPlayer.name
		motels[data.motel].rooms[index].players[toPlayer.identifier].duration = ( os.time() + (tonumber(player[2]) * rental_period[data.rental_period]))
		GlobalState.Motels = motels
		db.updateall('rooms = ?', '`motel`', data.motel, json.encode(motels[data.motel].rooms))
		if GetResourceState('ox_inventory') == 'started' then
			local stashid = data.uniquestash and toPlayer.identifier or 'room'
			exports.ox_inventory:RegisterStash('stash_'..data.motel..'_'..stashid..'_'..index, 'Storage', 70, 70000, false)
			exports.ox_inventory:RegisterStash('fridge_'..data.motel..'_'..stashid..'_'..index, 'Fridge', 70, 70000, false)
		end
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:editrate', function(src,motel,rate)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier then
		motels[motel].hour_rate = tonumber(rate)
		db.updateall('hour_rate = ?', '`motel`', motel, motels[motel].hour_rate)
		GlobalState.Motels = motels
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:addemployee', function(src,motel,id)
	local xPlayer = GetPlayerFromId(src)
	local toPlayer = GetPlayerFromId(tonumber(id))
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier and toPlayer then
		motels[motel].employees[toPlayer.identifier] = toPlayer.name
		GlobalState.Motels = motels
		db.updateall('employees = ?', '`motel`', motel, json.encode(motels[motel].employees))
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:removeemployee', function(src,motel,identifier)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier then
		motels[motel].employees[identifier] = nil
		GlobalState.Motels = motels
		db.updateall('employees = ?', '`motel`', motel, json.encode(motels[motel].employees))
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:transfermotel', function(src,motel,id)
	local xPlayer = GetPlayerFromId(src)
	local toPlayer = GetPlayerFromId(tonumber(id))
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier and toPlayer then
		motels[motel].owned = toPlayer.identifier
		GlobalState.Motels = motels
		db.updateall('owned = ?', '`motel`', motel, motels[motel].owned)
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:sellmotel', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[data.motel].owned == xPlayer.identifier then
		motels[data.motel].owned = nil
		motels[data.motel].employees = {}
		GlobalState.Motels = motels
		xPlayer.addMoney(data.businessprice / 2)
		db.updateall('owned = ?, employees = ?', '`motel`', data.motel, motels[data.motel].owned,'[]')
		return true
	end
	return false
end)

lib.callback.register('renzu_motels:withdrawfund', function(src,motel,amount)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier then
		if motels[motel].revenue < amount or amount < 0 then return false end
		motels[motel].revenue -= amount
		GlobalState.Motels = motels
		db.updateall('revenue = ?', '`motel`', motel, motels[motel].revenue)
		xPlayer.addMoney(tonumber(amount))
		return true
	end
	return false
end)

local invoices = {}
lib.callback.register('renzu_motels:sendinvoice', function(src,motel,data)
	local toPlayer = tonumber(data[1])
	if data[1] == -1 or not GetPlayerFromId(toPlayer) then return false end
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if motels[motel].owned == xPlayer.identifier or motels[motel].employees[xPlayer.identifier] then
		local id = math.random(999,9999)
		invoices[id] = data[2]
		TriggerClientEvent('renzu_motels:invoice',toPlayer,{
			motel = motel,
			amount = data[2],
			description = data[3],
			id = id,
			payment = data[4] and 'bank' or 'money',
			sender = src
		})
		local timer = 60
		while invoices[id] ~= 'paid' and timer > 0 do timer -= 1 Wait(1000) end
		local paid = invoices[id] == 'paid'
		invoices[id] = nil
		return paid
	end
	return false
end)

lib.callback.register('renzu_motels:payinvoice', function(src,data)
	local xPlayer = GetPlayerFromId(src)
	local motels = GlobalState.Motels
	if invoices[data.id] then
		local money = xPlayer.getAccount(data.payment).money
		if money >= data.amount then
			motels[data.motel].revenue += tonumber(data.amount)
			xPlayer.removeAccountMoney(data.payment,tonumber(data.amount))
			GlobalState.Motels = motels
			invoices[data.id] = 'paid'
			db.updateall('revenue = ?', '`motel`', data.motel, motels[data.motel].revenue)
		end
		return invoices[data.id] == 'paid'
	end
	return false
end)

local routings = {}
lib.callback.register('renzu_motels:SetRouting', function(src,data,Type)
	local xPlayer = GetPlayerFromId(src)
	if Type == 'enter' then
		routings[src] = GetPlayerRoutingBucket(src)
		SetPlayerRoutingBucket(src,data.index+100)
	else
		SetPlayerRoutingBucket(src,routings[src])
	end
	return true
end)

lib.callback.register('renzu_motels:MessageOwner', function(src,data)
	local motels = GlobalState.Motels
	if not motels[data.motel] or motels[data.motel].owned ~= data.identifier then return end
	local xPlayer = GetPlayerFromId(data.identifier)
	if xPlayer then
		TriggerClientEvent('renzu_motels:MessageOwner',xPlayer.source, data)
		return true
	end
	return false
end)

RegisterServerEvent("renzu_motels:Door")
AddEventHandler('renzu_motels:Door', function(data)
	local source = source
	TriggerClientEvent('renzu_motels:Door', -1, data)
	if not data.Mlo then
		local motels = GlobalState.Motels
		motels[data.motel].rooms[data.index].lock = not motels[data.motel].rooms[data.index].lock
		--db.updateall('rooms = ?', '`motel`', data.motel, json.encode(motels[data.motel].rooms))
		GlobalState.Motels = motels
	end
end)