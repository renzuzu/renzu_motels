if config.target then return end

ZoneMenu = function(data)
	local options = {}
	if data.type == 'door' then
		local haslockpick = false
		for _, item in pairs(GetInventoryItems('lockpick') or {}) do
			if item.name == 'lockpick' then
				haslockpick = true
				break
			end
		end
		if haslockpick then
			table.insert(options,{
				items = {'lockpick'},
				name = data.index .. '_' .. data.type..'_lockpick',
				onSelect = function() 
					return LockPick(data)
				end,
				icon = 'unlink',
				title = 'Lock Pick'
			})
		end
		if not data.Mlo then
			table.insert(options,{
				name = data.index .. '_' .. data.type..'_lockpick',
				onSelect = function() 
					return EnterShell(data)
				end,
				icon = 'person-booth',
				title = 'Enter'
			})
		end
	end
	table.insert(options,{
		name = data.index .. '_' .. data.type,
		onSelect = function() 
			return RoomFunction(data)
		end,
		icon = config.icons[data.type],
		title = data.label
	})
	if data.type == 'stash' then
		local motels = GlobalState.Motels[data.motel]
		local room = motels?.rooms[data.index] or {}
		local keys = GetPlayerKeys(data,room)
		for identifier,name in pairs(keys) do
			table.insert(options,{
				name = data.index .. '_' .. data.type,
				onSelect = function() 
					return RoomFunction(data,identifier)
				end,
				icon = config.icons[data.type],
				title = data.label..' - ['..name..']'
			})
		end
	end
	lib.registerContext({
		id = 'door_menu',
		title = 'Door Menu',
		options = options
	})
	lib.showContext('door_menu')
end

MotelFunction = function(data)
	if not data.Mlo and data.type ~= 'door' then return end
	local options = {}
	local doorindex = data.index + (joaat(data.motel))
	if data.type == 'door' then
		AddDoorToSystem(doorindex, data.door, data.coord)
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
	end
	local point = lib.points.new(data.coord, 2)
	
	function point:onEnter()
		local text = data.type == 'door' and 'Door '..data.index or data.type:upper()
		lib.showTextUI('[E] - '..text)
	end
	
	function point:onExit()
		lib.hideTextUI()
	end
	
	function point:nearby()
		DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 200, 255, 255, 50, false, true, 2, nil, nil, false)
	
		if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
			ZoneMenu(data)
		end
	end
	table.insert(zones,point)
end

removeTargetZone = function(point)
	return point:remove()
end

RoomMenu = function(type,data)
	local options = {}
	table.insert(options,{
		name = data.motel .. '_' .. type..'_'..data.index,
		onSelect = function() 
			data.type = type
			return RoomFunction(data)
		end,
		icon = config.icons[type],
		title = type:upper()
	})
	if type == 'stash' then
		local motels = GlobalState.Motels[data.motel]
		local room = motels?.rooms[data.index] or {}
		local keys = GetPlayerKeys(data,room)
		for identifier,name in pairs(keys) do
			table.insert(options,{
				name = data.index .. '_' .. type,
				onSelect = function() 
					data.type = type
					return RoomFunction(data,identifier)
				end,
				icon = config.icons[type],
				title = config.Text[type]..' - ['..name..']'
			})
		end
	end
	if type == 'exit' then
		table.insert(options,{
			name = data.motel .. '_' ..type..'_'..data.index..'_door',
			onSelect = function() 
				data.type = 'door'
				return Door(data)
			end,
			icon = config.icons[type],
			title = 'Toggle Door'
		})
	end
	lib.registerContext({
		id = 'room_menu',
		title = 'Room Menu',
		options = options
	})
	lib.showContext('room_menu')
end

ShellTargets = function(data,offsets,loc,house)
	Wait(2000)
	for k,v in pairs(offsets) do
		local point = lib.points.new(loc+v, 1.5)
	
		function point:onEnter()
			lib.showTextUI('[E] - Room '..k)
		end
		
		function point:onExit()
			lib.hideTextUI()
		end
		
		function point:nearby()
			DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 200, 255, 255, 50, false, true, 2, nil, nil, false)
		
			if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
				RoomMenu(k,data)
			end
		end
		table.insert(shelzones,point)
	end
end