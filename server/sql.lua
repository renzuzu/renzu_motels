
local db = setmetatable({},{
	__call = function(self)

		self.insert = function(...)
			local str = 'INSERT INTO %s (%s, %s, %s, %s, %s, %s) VALUES(?, ?, ?, ?, ?, ?)'
			return MySQL.insert.await(str:format('renzu_motels','motel','hour_rate','revenue','employees','rooms','owned'),{...})
		end

		self.update = function(column, where, string, data)
			local str = 'UPDATE %s SET %s WHERE %s = ?'
			return MySQL.update(str:format('renzu_motels',column,where),{data,string})
		end

		self.updateall = function(pattern, where, string, ...)
			local str = 'UPDATE %s SET % WHERE %s = ?'
			local str = 'UPDATE renzu_motels SET '..pattern..' WHERE '..where..' = ?'
			local data = {...}
			table.insert(data,string)
			return MySQL.update(str,data)
		end

		self.query = function(column, where, string)
			local str = 'SELECT %s FROM %s WHERE %s = ?'
			return MySQL.query.await(str:format(column,'renzu_motels',where),{string})
		end

		self.fetchAll = function()
			local str = 'SELECT * FROM renzu_motels'
			local query = MySQL.query.await(str)
			local data = {}
			for k,v in pairs(query) do
				for column, value in pairs(v) do
					if v.motel then
						if column ~= 'id' and value then
							if not data[column] then data[column] = {} end
							local success, result = pcall(json.decode, value)
							result = result == nil and value or result
							if not data[v.motel] then data[v.motel] = {} end
							if column == 'owned' and result == 0 then result = nil end
							if column == 'hour_rate' and result == 0 then result = nil end
							data[v.motel][column] = result
						end
					end
				end
			end
			return data
		end

		return self
	end
})

Citizen.CreateThreadNow(function()
	local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM renzu_motels')
	if not success then
		MySQL.query.await([[CREATE TABLE `renzu_motels` (
			`id` int NOT NULL AUTO_INCREMENT KEY,
			`motel` varchar(64) DEFAULT NULL,
			`hour_rate` int DEFAULT 0,
			`revenue` int DEFAULT 0,
			`employees` longtext DEFAULT NULL,
			`rooms` longtext DEFAULT NULL,
			`owned` varchar(64) DEFAULT NULL
		)]])
		print("^2SQL INSTALL SUCCESSFULLY ^0")
	end
	Wait(500)
	for k,v in pairs(config.motels) do
		local query = MySQL.query.await('SELECT rooms FROM renzu_motels WHERE `motel` = ?',{v.motel})
		if not query[1] then
			local doors = {}
			for doorindex,_ in pairs(v.doors) do
				if not doors.rooms then doors.rooms = {} end
				if not doors.rooms[doorindex] then doors.rooms[doorindex] = {} end
				if not doors.rooms[doorindex].players then doors.rooms[doorindex].players = {} end
				doors.rooms[doorindex].lock = true
			end
			db.insert(v.motel,0,0,'[]',json.encode(doors.rooms),0)
		elseif query[1] and #v.doors > #json.decode(query[1].rooms) then
			local addnew = (#v.doors - #json.decode(query[1].rooms))
			local rooms = json.decode(query[1].rooms) or {}
			for i = 1, addnew do
				table.insert(rooms,{players = {}, lock = true})
			end
			db.updateall('rooms = ?', '`motel`', v.motel, json.encode(rooms))
		end
	end
end)

return db()