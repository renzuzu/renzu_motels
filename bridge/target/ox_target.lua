if GetResourceState('ox_target') ~= 'started' or not config.target then return end

MotelFunction = function(data)
	if not data.Mlo and data.type ~= 'door' then return end
	local options = {}
	if data.type == 'door' then
		local doorIndex = data.index + (joaat(data.motel))
		AddDoorToSystem(doorIndex, data.door, data.coord)
		SetDoorState(data)
		local blip = AddBlipForCoord(data.coord.x,data.coord.y,data.coord.z)
		SetBlipSprite(blip,685+data.index)
		SetBlipColour(blip,0)
		SetBlipSecondaryColour(blip,255,255,255)
		SetBlipAsShortRange(blip,true)
		SetBlipScale(blip,0.3)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Door '..data.index)
		EndTextCommandSetBlipName(blip)
		table.insert(blips,blip)
		table.insert(options,{
			items = {'lockpick'},
			name = data.index .. '_' .. data.type..'_lockpick',
			onSelect = function() 
				return LockPick(data)
			end,
			icon = 'fas fa-unlink',
			label = 'Lock Pick'
		})
		if not data.Mlo then
			table.insert(options,{
				name = data.index .. '_' .. data.type..'_lockpick',
				onSelect = function() 
					return EnterShell(data)
				end,
				icon = 'fas fa-person-booth',
				label = 'Enter'
			})
		end
	end
	table.insert(options,{
		name = data.index .. '_' .. data.type,
		onSelect = function() 
			return RoomFunction(data)
		end,
		icon = config.icons[data.type],
		label = data.label
	})
    local targetid = exports.ox_target:addBoxZone({
		coords = data.coord,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = false,
		options = options
	})
	table.insert(zones,targetid)
end

removeTargetZone = function(id)
	return exports['ox_target']:removeZone(id)
end

ShellTargets = function(data,offsets,loc,house)
	Wait(2000)
	for k,v in pairs(offsets) do
		local options = {}
		table.insert(options,{
			name = data.motel .. '_' .. k..'_'..data.index,
			onSelect = function() 
				data.type = k
				return RoomFunction(data)
			end,
			icon = config.icons[k],
			label = config.Text[k]
		})
		if k == 'exit' then
			table.insert(options,{
				name = data.motel .. '_' .. k..'_'..data.index..'_door',
				onSelect = function() 
					data.type = 'door'
					return Door(data)
				end,
				icon = config.icons[k],
				label = 'Toggle Door'
			})
		end

		if k == 'stash' then
			local motels = GlobalState.Motels[data.motel]
			local room = motels?.rooms[data.index] or {}
			local keys = GetPlayerKeys(data,room)
			for identifier,name in pairs(keys) do
				table.insert(options,{
					name = data.motel .. '_' .. k..'_'..data.index..'_'..identifier,
					onSelect = function() 
						data.type = k
						return RoomFunction(data,identifier)
					end,
					icon = config.icons[k],
					label = config.Text[k]..' - ['..name..']'
				})
			end
		end

		local targetid = exports.ox_target:addBoxZone({
			coords = loc+v,
			size = vec3(2, 2, 2),
			rotation = 45,
			debug = false,
			options = options
		})
		table.insert(shelzones,targetid)
	end
end