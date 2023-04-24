config = {}
config.wardrobe = 'illenium-appearance' -- choose your skin menu
config.target = false -- false = markers zones type. true = ox_target, qb-target
config.business = true -- allowed players to purchase the motel
config.autokickIfExpire = false -- auto kick occupants if rent is due. if false owner of motel must kick the occupants
config.breakinJobs = { -- jobs can break in to door using gunfire in doors
	['police'] = true,
	['swat'] = true,
}
config.wardrobes = { -- skin menus
	['renzu_clothes'] = function()
		exports.renzu_clothes:OpenClotheInventory()
	end,
	['fivem-appearance'] = function()
		return exports['fivem-appearance']:startPlayerCustomization() -- you could replace this with outfits events
	end,
	['illenium-appearance'] = function()
		return TriggerEvent('illenium-appearance:client:openOutfitMenu')
	end,
	['qb-clothing'] = function()
		return TriggerEvent('qb-clothing:client:openOutfitMenu')
	end,
	['esx_skin'] = function()
		TriggerEvent('esx_skin:openSaveableMenu')
	end,
}

-- Shells Offsets and model name
config.shells = {
	['standard'] = {
		shell = `standardmotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(-0.43,-2.51,1.16),
			stash = vec3(1.368164, -3.134506, 1.16),
			wardrobe = vec3(1.643646, 2.551102, 1.16),
		}
	},
	['modern'] = {
		shell = `modernhotel_shell`, -- kambi shell
		offsets = {
			exit = vec3(5.410095, 4.299301, 0.9),
			stash = vec3(-4.068207, 4.046188, 0.9),
			wardrobe = vec3(2.811829, -3.619385, 0.9),
		}
	},
}

config.messageApi = function(data) -- {title,message,motel}
	local motel = GlobalState.Motels[data.motel]
	local identifier = motel.owned -- owner identifier
	-- add your custom message here. ex. SMS phone 

	-- basic notification (remove this if using your own message system)
	local success = lib.callback.await('renzu_motels:MessageOwner',false,{identifier = identifier, message = data.message, title = data.title, motel = data.motel})
	if success then
		Notify('message has been sent', 'success')
	else
		Notify('message fail  \n  owner is not available yet', 'error')
	end
end

-- @shell string (shell type)
-- @Mlo string ( toggle MLO or shell type)
-- @hour_rate int ( per hour rates)
-- @motel string (Motel Index Name)
-- @rentcoord vec3 (coordinates of Rental Menu)
-- @radius float ( total size radius of motel )
-- @maxoccupants int (total player can rent in each Rooms)
-- @uniquestash bool ( Toggle Non Sharable / Stealable Stash Storage )
-- @doors table ( lists of doors feature coordinates. ex. stash, wardrobe) wardrobe,stash coords are only applicable in Mlo. using shells has offsets for stash and wardrobes.
-- @manual boolean ( accept walk in occupants only )
-- @businessprice int ( value of motel)
-- @door int (door hash or doormodel `model`) for MLO type

config.motels = {
	[1] = { -- index name of motel
		manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
		Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
		shell = 'standard', -- shell type, configure only if using Mlo = true
		label = 'Pink Cage Motel',
		rental_period = 'day',-- hour, day, month
		rate = 1000, -- cost per period
		businessprice = 1000000,
		motel = 'pinkcage',
		payment = 'money', -- money, bank
		door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
		rentcoord = vec3(313.38,-225.20,54.212),
		coord = vec3(326.04,-210.47,54.086), -- center of the motel location
		radius = 50.0, -- radius of motel location
		maxoccupants = 5, -- maximum renters per room
		uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
		doors = { -- doors and other function of each rooms
			[1] = { -- COORDINATES FOR GABZ PINKCAGE
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(307.21499633789,-212.79479980469,54.420265197754), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- [2] = {
					-- 	coord = vec3(306.67614746094,-215.63456726074,54.22175),
					-- 	model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					-- }
					-- support multiple doors just add new line of table 
				},
				stash = vec3(307.01657104492,-207.91079711914,53.758548736572), --  requires when using MLO
				wardrobe = vec3(302.58380126953,-207.71691894531,54.598297119141), --  requires when using MLO
				fridge = vec3(305.00064086914,-206.12855529785,54.544868469238), --  requires when using MLO
				-- luckyme = vec3(0.0,0.0,0.0) -- extra
			},
			[2] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(310.95474243164,-202.91288757324,54.421058654785), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(310.91235351563,-198.10073852539,53.758598327637),
				wardrobe = vec3(306.25433349609,-197.75250244141,54.564342498779),
				fridge = vec3(308.79779052734,-196.23670959473,54.440326690674),
			},
			[3] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(316.28607177734,-194.54536437988,54.391784667969), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(321.10150146484,-194.42211914063,53.758399963379),
				wardrobe = vec3(321.42459106445,-189.79216003418,54.65941619873),
				fridge = vec3(322.92010498047,-192.31481933594,54.600353240967),
			},
			[4] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(314.36087036133,-219.91516113281,58.151386260986), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},			
				stash = vec3(309.6142578125,-220.16128540039,57.557399749756),
				wardrobe = vec3(309.21203613281,-224.6675567627,58.375194549561),
				fridge = vec3(307.6989440918,-222.11755371094,58.293560028076),
			},
			[5] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(307.22616577148,-212.77645874023,58.204700469971), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(306.89093017578,-207.88090515137,57.556159973145),
				wardrobe = vec3(302.57464599609,-207.71339416504,58.440250396729),
				fridge = vec3(305.044921875,-205.99066162109,58.394989013672),
			},
			[6] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(311.00057983398,-202.87718200684,58.148029327393), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(310.88967895508,-198.16856384277,57.556510925293),
				wardrobe = vec3(306.09225463867,-198.40795898438,58.27188873291),
				fridge = vec3(308.73110961914,-196.40968322754,58.407859802246),
			},
			[7] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(316.29287719727,-194.5479888916,58.212650299072), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(321.24801635742,-194.29737854004,57.556739807129),
				wardrobe = vec3(321.46688842773,-189.68632507324,58.422557830811),
				fridge = vec3(322.98544311523,-192.33996582031,58.386581420898),
			},
			[8] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(339.43377685547,-219.99412536621,54.431659698486), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(339.67279052734,-224.8221282959,53.759098052979),
				wardrobe = vec3(344.28637695313,-224.95460510254,54.527130126953),
				fridge = vec3(341.86477661133,-226.15287780762,54.642837524414),
			},
			[9] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(343.23126220703,-210.10203552246,54.410026550293), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(343.47601318359,-214.96635437012,53.758640289307),
				wardrobe = vec3(347.99655151367,-215.08934020996,54.489669799805),
				fridge = vec3(345.53387451172,-216.53938293457,54.698444366455),
			},
			[10] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(347.0237121582,-200.22482299805,54.414268493652), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(347.33102416992,-205.13743591309,53.759078979492),
				wardrobe = vec3(351.68756103516,-205.30010986328,54.674419403076),
				fridge = vec3(349.34033203125,-206.6258392334,54.639694213867),
			},
			[11] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(334.44702148438,-227.61134338379,58.205139160156), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(329.67590332031,-227.8233795166,57.556579589844),
				wardrobe = vec3(329.43222045898,-232.33073425293,58.42276763916),
				fridge = vec3(327.64138793945,-229.79788208008,58.355628967285),
			},
			[12] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(339.44650268555,-219.9709777832,58.177570343018), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(339.79351806641,-224.86245727539,57.55553817749),
				wardrobe = vec3(344.26574707031,-225.00813293457,58.302909851074),
				fridge = vec3(341.6985168457,-226.52975463867,58.367748260498),
			},
			[13] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(343.22320556641,-210.1229095459,58.176639556885), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(343.47412109375,-214.96145629883,57.55553817749),
				wardrobe = vec3(348.07550048828,-215.08416748047,58.288040161133),
				fridge = vec3(345.40502929688,-216.88189697266,58.281555175781),
			},
			[14] = {
				door = { -- Door config requires when using MLO
					[1] = { -- requested by community. supports multiple door models.
						coord = vec3(347.03012084961,-200.20816040039,58.177433013916), -- exact coordinates of door
						model = `gabz_pinkcage_doors_front` -- model of target door coordinates
					},
					-- support multiple doors just add new line of table 
				},
				stash = vec3(347.12841796875,-205.05494689941,57.55553817749),
				wardrobe = vec3(351.77719116211,-205.24267578125,58.351734161377),
				fridge = vec3(349.24819946289,-206.78134155273,58.326892852783),
			},
			
		},
	},

	-- [2] = { -- index name of motel
	-- 	manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
	-- 	Mlo = true, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
	-- 	shell = 'modern', -- shell type, configure only if using Mlo = true
	-- 	label = 'Yacht Club Motel',
	-- 	rental_period = 'day',-- hour, day, month
	-- 	payment = 'money', -- money, bank
	-- 	rate = 1000, -- cost per period
	-- 	motel = 'yacht',
	-- 	door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
	-- 	businessprice = 1000000,
	-- 	rentcoord = vec3(-916.54,-1302.56,6.2001),
	-- 	coord = vec3(-916.54,-1302.56,6.2001), -- center of the motel location
	-- 	radius = 50.0, -- radius of motel location
	-- 	maxoccupants = 5, -- maximum renters per room
	-- 	uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
	-- 	doors = { -- doors and other function of each rooms
	-- 		[1] = {
	-- 			door = vec3(-936.25,-1311.38,6.20),
	-- 			stash = vec3(-944.08,-1317.83,6.19),
	-- 			wardrobe = vec3(-941.21,-1324.9,6.19),
	-- 			--fridge = vec3(305.26,-206.43,54.22),
	-- 			-- luckyme = vec3(0.0,0.0,0.0) -- extra shit
	-- 		},
	-- 	},
	-- },

	-- [3] = { -- index name of motel
	-- 	businessprice = 1000000,
	-- 	manual = false, -- set the motel to auto accept occupants or false only the owner of motel can accept Occupants
	-- 	Mlo = false, -- if MLO you need to configure each doors coordinates,stash etc. if false resource will use shells
	-- 	shell = 'modern', -- shell type, configure only if using Mlo = true
	-- 	label = 'Motel Modern', -- hotel label
	-- 	rental_period = 'day',-- hour, day, month
	-- 	payment = 'money', -- money, bank
	-- 	rate = 1000, -- cost per period
	-- 	door = `gabz_pinkcage_doors_front`, -- door hash for MLO type
	-- 	motel = 'hotelmodern3', -- hotel index name
	-- 	rentcoord = vec3(515.21173095703,225.36326599121,104.74),
	-- 	coord = vec3(505.55709838867,213.49201965332,102.89), -- center of the motel location
	-- 	radius = 50.0, -- radius of motel location
	-- 	maxoccupants = 5, -- maximum renters per room
	-- 	uniquestash = true, -- if true. each players has unique stash ID (non sharable and non stealable). if false stash is shared to all Occupants if maxoccupans is > 1
	-- 	doors = { -- doors and other function of each rooms
	-- 		[1] = {
	-- 			door = vec3(496.90872192383,237.74664306641,105.28434753418),
	-- 			-- stash = vec3(-944.08,-1317.83,6.19),
	-- 			-- wardrobe = vec3(-941.21,-1324.9,6.19),
	-- 			--fridge = vec3(305.26,-206.43,54.22),
	-- 			-- luckyme = vec3(0.0,0.0,0.0) -- extra shit
	-- 		},
	-- 	},
	-- }
}
config.extrafunction = {
	['bed'] = function(data,identifier)
		TriggerEvent('luckyme')
	end,
	['fridge'] = function(data,identifier)
		TriggerEvent('ox_inventory:openInventory', 'stash', {id = 'fridge_'..data.motel..'_'..identifier..'_'..data.index, name = 'Fridge', slots = 30, weight = 20000, coords = GetEntityCoords(cache.ped)})
	end,
	['exit'] = function(data)
		local coord = LocalPlayer.state.lastloc or vec3(data.coord.x,data.coord.y,data.coord.z)
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SendNUIMessage({
			type = 'door'
		})
		return Teleport(coord.x,coord.y,coord.z,0.0,true)
	end,
}

config.Text = {
	['stash'] = 'Stash',
	['fridge'] = 'My Fridge',
	['wardrobe'] = 'Wardrobe',
	['bed'] = 'Sleep',
	['door'] = 'Door',
	['exit'] = 'Exit',
}

config.icons = {
	['door'] = 'fas fa-door-open',
	['stash'] = 'fas fa-box',
	['wardrobe'] = 'fas fa-tshirt',
	['fridge'] = 'fas fa-ice-cream',
	['bed'] = 'fas fa-bed',
	['exit'] = 'fas fa-door-open',
}

config.stashblacklist = {
	['stash'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			water = true,
		},
	},
	['fridge'] = { -- type of inventory
		blacklist = { -- list of blacklists items
			WEAPON_PISTOL = true,
		},
	},
}

PlayerData,ESX,QBCORE,zones,shelzones,blips = {},nil,nil,{},{},{}

function import(file)
	local name = ('%s.lua'):format(file)
	local content = LoadResourceFile(GetCurrentResourceName(),name)
	local f, err = load(content)
	return f()
end

if GetResourceState('es_extended') == 'started' then
	ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
	QBCORE = exports['qb-core']:GetCoreObject()
end