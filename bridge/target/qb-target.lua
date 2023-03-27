if GetResourceState('ox_target') == 'started' 
or GetResourceState('ox_target') ~= 'started' and GetResourceState('qb-target') ~= 'started' or not config.target then return end

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
			item = 'lockpick',
			name = data.index .. '_' .. data.type..'_lockpick',
			action = function() 
				return LockPick(data)
			end,
			icon = 'fas fa-unlink',
			label = 'Lock Pick'
		})
		if not data.Mlo then
			table.insert(options,{
				name = data.index .. '_' .. data.type..'_lockpick',
				action = function() 
					return EnterShell(data)
				end,
				icon = 'fas fa-person-booth',
				label = 'Enter'
			})
		end
	end
	table.insert(options,{
		name = data.index .. '_' .. data.type,
		action = function() 
			return RoomFunction(data)
		end,
		icon = config.icons[data.type],
		label = data.label
	})
	local target = {
		coords = data.coord,
		size = vec3(2, 2, 2),
		rotation = 45,
		debug = drawZones,
		options = options
	}
	local targetid = data.index .. '_' .. data.type
	exports['qb-target']:AddBoxZone(targetid,data.coord,0.40,0.40,{
		name = targetid,
		debugPoly = false,
		minZ = data.coord.z-0.2,
		maxZ = data.coord.z+0.2
	},target)
	table.insert(zones,targetid)
end

removeTargetZone = function(id)
	return exports['qb-target']:RemoveZone(id)
end

ShellTargets = function(data,offsets,loc,house)
	Wait(2000)
	for k,v in pairs(offsets) do
		local options = {}
		table.insert(options,{
			name = data.motel .. '_' .. k..'_'..data.index,
			action = function() 
				data.type = k
				return RoomFunction(data)
			end,
			icon = config.icons[k],
			label = config.Text[k]
		})
		if k == 'exit' then
			table.insert(options,{
				name = data.motel .. '_' .. k..'_'..data.index..'_door',
				action = function() 
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
					action = function() 
						data.type = k
						return RoomFunction(data,identifier)
					end,
					icon = config.icons[k],
					label = config.Text[k]..' - ['..name..']'
				})
			end
		end

		local targetid = data.motel .. '_' .. k..'_'..data.index
		exports['qb-target']:AddBoxZone(targetid, loc+v, 0.75, 0.75, {
			name = targetid,
			debugPoly = false,
			minZ = (loc+v).z-0.45,
			maxZ = (loc+v).z+0.45,
		}, {
			options = options,
			distance = 5.5
		})
		table.insert(shelzones,targetid)
	end
end